import Foundation
import CryptoKit
import Darwin

struct PatcherError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
func fail(_ message: String) -> PatcherError { PatcherError(message: message) }
func digest(_ data: Data) -> String { SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined() }
struct Recipe: Decodable {
    let format: Int
    let release, stockOS, stockSHA256, mainInputSHA256, mainOutputSHA256, outputSHA256: String
    let outputSize: Int
    let operations: [[Int]]
}
final class Engine {
    let resources: URL
    let recipe: Recipe
    let additions: Data
    init() throws {
        guard let resources = Bundle.main.resourceURL else { throw fail("Application resources are missing.") }
        self.resources = resources
        let bytes = try Data(contentsOf: resources.appendingPathComponent("firmware-patch.json"))
        additions = try Data(contentsOf: resources.appendingPathComponent("additions.bin"))
        guard digest(bytes) == recipePin, digest(additions) == additionsPin else {
            throw fail("The patch resources failed their integrity check. Obtain a fresh copy of the patcher.")
        }
        guard digest(try Data(contentsOf: resources.appendingPathComponent("elektron-firmware-tool"))) == backendPin else {
            throw fail("The firmware processing tool failed its integrity check. Obtain a fresh copy of DigiRust.")
        }
        recipe = try JSONDecoder().decode(Recipe.self, from: bytes)
        guard recipe.format == 1, recipe.outputSize > 0, recipe.outputSize < 8_000_000 else {
            throw fail("Unsupported patch format.")
        }
    }
    func readStock(_ input: URL) throws -> Data {
        let attrs = try FileManager.default.attributesOfItem(atPath: input.path)
        guard let size = attrs[.size] as? NSNumber, size.intValue > 0, size.intValue < 16_000_000 else {
            throw fail("Choose the official Digitone II OS 1.12 .syx file, not a ZIP archive or folder.")
        }
        let data = try Data(contentsOf: input)
        guard digest(data) == recipe.stockSHA256 else {
            throw fail("This is not the supported official Digitone II OS 1.12 file. Other versions, modified files and ZIP archives cannot be patched.")
        }
        return data
    }
    func runTool(_ arguments: [String], in directory: URL) throws {
        let log = directory.appendingPathComponent("tool.log")
        FileManager.default.createFile(atPath: log.path, contents: nil)
        let handle = try FileHandle(forWritingTo: log)
        defer { try? handle.close() }
        let task = Process()
        task.executableURL = resources.appendingPathComponent("elektron-firmware-tool")
        task.arguments = arguments
        task.standardOutput = handle
        task.standardError = handle
        try task.run()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw fail("Firmware processing failed. No output was saved. Check that the disk has free space and reinstall the patcher if this persists.")
        }
    }
    func patch(input: URL, output: URL, progress: @escaping (Double, String) -> Void) throws {
        let fm = FileManager.default
        // Reject symlinks, existing files and collisions; never replace an input or earlier output.
        guard output.standardizedFileURL.resolvingSymlinksInPath() != input.standardizedFileURL.resolvingSymlinksInPath(),
              (try? fm.attributesOfItem(atPath: output.path)) == nil else {
            throw fail("Choose a new output filename. Existing files and the original firmware are never overwritten.")
        }
        progress(0.05, "Checking official OS 1.12…")
        let stock = try readStock(input)
        let temporary = fm.temporaryDirectory.appendingPathComponent("DigiRust-" + UUID().uuidString, isDirectory: true)
        try fm.createDirectory(at: temporary, withIntermediateDirectories: false, attributes: [.posixPermissions: 0o700])
        defer { try? fm.removeItem(at: temporary) }
        let snapshot = temporary.appendingPathComponent("stock.syx")
        try stock.write(to: snapshot)
        progress(0.15, "Extracting your firmware…")
        try runTool(["-i", snapshot.path, "-d", "3", "-o", temporary.path], in: temporary)
        let main = try Data(contentsOf: temporary.appendingPathComponent("section_3_MAIN_OS.bin"))
        guard digest(main) == recipe.mainInputSHA256 else { throw fail("The stock operating system section failed verification.") }
        progress(0.35, "Applying DigiRust…")
        var result = Data(); result.reserveCapacity(recipe.outputSize)
        for op in recipe.operations {
            guard op.count == 3, op[0] == 0 || op[0] == 1, op[1] >= 0, op[2] > 0 else { throw fail("Invalid patch operation.") }
            let source = op[0] == 0 ? main : additions
            guard op[1] <= source.count, op[2] <= source.count - op[1], op[2] <= recipe.outputSize - result.count else {
                throw fail("Patch operation exceeds its permitted range.")
            }
            result.append(source.subdata(in: op[1]..<(op[1] + op[2])))
        }
        guard result.count == recipe.outputSize, digest(result) == recipe.mainOutputSHA256 else { throw fail("The modified operating system failed verification.") }
        let patchedMain = temporary.appendingPathComponent("modified-main.bin")
        try result.write(to: patchedMain)
        let candidate = temporary.appendingPathComponent("candidate.syx")
        progress(0.55, "Rebuilding the firmware package…")
        try runTool(["-i", snapshot.path, "-c", "3", patchedMain.path, "-l", "0", "-o", candidate.path], in: temporary)
        progress(0.85, "Verifying the complete DigiRust package…")
        let final = try Data(contentsOf: candidate)
        guard digest(final) == recipe.outputSHA256 else { throw fail("The completed firmware differs from the verified DigiRust release. No output was saved.") }
        try runTool(["-i", candidate.path], in: temporary)
        // Publish a completely written file using an atomic, exclusive hard link on the destination volume.
        let staging = output.deletingLastPathComponent().appendingPathComponent(".DigiRust-" + UUID().uuidString)
        defer { try? fm.removeItem(at: staging) }
        let fd = Darwin.open(staging.path, O_WRONLY | O_CREAT | O_EXCL, 0o600)
        guard fd >= 0 else { throw fail("Cannot write to the selected destination.") }
        let handle = FileHandle(fileDescriptor: fd, closeOnDealloc: true)
        do { try handle.write(contentsOf: final); guard fsync(fd) == 0 else { throw fail("Could not finish writing the output file.") }; try handle.close() }
        catch { try? handle.close(); throw error }
        guard Darwin.link(staging.path, output.path) == 0 else { throw fail("Could not save the output. Use a new filename on a local APFS or HFS+ volume; existing files are never replaced.") }
        progress(1, "DigiRust created and verified.")
    }
}
