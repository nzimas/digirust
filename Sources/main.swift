import AppKit

private enum Palette {
    static let canvas = NSColor(srgbRed: 0.055, green: 0.068, blue: 0.085, alpha: 1)
    static let surface = NSColor(srgbRed: 0.095, green: 0.118, blue: 0.148, alpha: 1)
    static let border = NSColor(srgbRed: 0.23, green: 0.28, blue: 0.34, alpha: 1)
    static let text = NSColor(srgbRed: 0.96, green: 0.97, blue: 0.99, alpha: 1)
    static let secondary = NSColor(srgbRed: 0.73, green: 0.78, blue: 0.84, alpha: 1)
    static let accent = NSColor(srgbRed: 0.553, green: 0.706, blue: 1.0, alpha: 1)
    static let success = NSColor(srgbRed: 0.60, green: 0.87, blue: 0.70, alpha: 1)
}
private func label(_ text: String, _ size: CGFloat = 18, _ weight: NSFont.Weight = .regular, _ color: NSColor = Palette.text) -> NSTextField {
    let field = NSTextField(wrappingLabelWithString: text)
    field.font = .systemFont(ofSize: size, weight: weight); field.textColor = color
    field.setContentCompressionResistancePriority(.required, for: .vertical)
    return field
}
private func stack(_ views: [NSView], vertical: Bool = true, spacing: CGFloat = 12) -> NSStackView {
    let result = NSStackView(views: views); result.orientation = vertical ? .vertical : .horizontal
    result.alignment = vertical ? .leading : .centerY; result.distribution = .fill; result.spacing = spacing
    return result
}
private func inset(_ child: NSView, in parent: NSView, amount: CGFloat = 24, pinBottom: Bool = true) {
    child.translatesAutoresizingMaskIntoConstraints = false; parent.addSubview(child)
    NSLayoutConstraint.activate([child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: amount), child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -amount), child.topAnchor.constraint(equalTo: parent.topAnchor, constant: amount), child.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor, constant: -amount)])
    if pinBottom { child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -amount).isActive = true }
}
final class Card: NSView {
    var highlighted = false { didSet { needsDisplay = true } }
    override func draw(_ dirtyRect: NSRect) {
        let path = NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 16, yRadius: 16)
        Palette.surface.setFill(); path.fill()
        (highlighted ? Palette.accent : Palette.border).setStroke(); path.lineWidth = highlighted ? 2 : 1; path.stroke()
    }
}
final class FirmwareDrop: NSView {
    var accept: ((URL) -> Void)?
    var enabled = true
    weak var card: Card?
    override init(frame: NSRect) { super.init(frame: frame); registerForDraggedTypes([.fileURL]) }
    required init?(coder: NSCoder) { fatalError() }
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard enabled, let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: [.urlReadingFileURLsOnly: true]) as? [URL], urls.count == 1 else { return [] }
        card?.highlighted = true; return .copy
    }
    override func draggingExited(_ sender: NSDraggingInfo?) { card?.highlighted = false }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        card?.highlighted = false
        guard enabled, let urls = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: [.urlReadingFileURLsOnly: true]) as? [URL], urls.count == 1 else { return false }
        accept?(urls[0]); return true
    }
}
final class RustButton: NSButton {
    var primary = false
    override func draw(_ dirtyRect: NSRect) {
        let path = NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 10, yRadius: 10)
        let background = primary && isEnabled ? Palette.accent : Palette.surface
        (isHighlighted ? background.blended(withFraction: 0.15, of: .black)! : background).setFill(); path.fill()
        if !primary || !isEnabled { Palette.border.setStroke(); path.lineWidth = 1; path.stroke() }
        let color: NSColor = primary && isEnabled ? Palette.canvas : (isEnabled ? Palette.text : Palette.secondary)
        let style = NSMutableParagraphStyle(); style.alignment = .center
        let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: 18, weight: .semibold), .foregroundColor: color, .paragraphStyle: style]
        let height = (title as NSString).size(withAttributes: attrs).height
        (title as NSString).draw(in: NSRect(x: 12, y: (bounds.height-height)/2, width: bounds.width-24, height: height+2), withAttributes: attrs)
        if window?.firstResponder === self {
            let focus = NSBezierPath(roundedRect: bounds.insetBy(dx: 3, dy: 3), xRadius: 8, yRadius: 8)
            Palette.text.setStroke(); focus.lineWidth = 2; focus.stroke()
        }
    }
}
final class RustWordmark: NSView {
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        drawDigiRustWordmark(context, in: bounds)
    }
}
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    var engine: Engine?
    var input: URL?
    var savedOutput: URL?
    var busy = false
    let fileLabel = label("Drop your OS 1.12 file here", 22, .semibold)
    let fileHint = label("Official Digitone II firmware · .syx file", 18, .regular, Palette.secondary)
    let status = label("Choose the stock firmware to get started.", 18, .regular, Palette.secondary)
    let statusTitle = label("Ready when you are", 20, .semibold)
    let choose = RustButton(title: "Choose file…", target: nil, action: nil)
    let create = RustButton(title: "Create patched firmware…", target: nil, action: nil)
    let reveal = RustButton(title: "Show in Finder", target: nil, action: nil)
    let bar = NSProgressIndicator()
    var drop: FirmwareDrop!
    func applicationDidFinishLaunching(_ notification: Notification) {
        let menu = NSMenu(); let appItem = NSMenuItem(); menu.addItem(appItem)
        let appMenu = NSMenu(); appItem.submenu = appMenu
        appMenu.addItem(withTitle: "About DigiRust", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(.separator()); appMenu.addItem(withTitle: "Quit DigiRust", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        NSApp.mainMenu = menu
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 880, height: 760), styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        window.title = "DigiRust"; window.delegate = self
        window.minSize = NSSize(width: 880, height: 760)
        window.titlebarAppearsTransparent = true; window.backgroundColor = Palette.canvas
        window.appearance = NSAppearance(named: .darkAqua)
        let view = window.contentView!
        let mark = RustWordmark(); mark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([mark.widthAnchor.constraint(equalToConstant: 220), mark.heightAnchor.constraint(equalToConstant: 47)])
        let brand = stack([mark, label("Firmware patcher for Digitone II", 18, .regular, Palette.secondary)], spacing: 4)
        let badge = label("OS 1.12", 18, .semibold, Palette.accent); badge.setAccessibilityLabel("Based on official OS 1.12")
        let spacer = NSView(); spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let header = stack([brand, spacer, badge], vertical: false, spacing: 18)
        let separator = NSBox(); separator.boxType = .separator
        let intro = stack([label("Create your DigiRust firmware", 26, .semibold), label("Start with official OS 1.12. Save a patched copy.", 19, .regular, Palette.secondary)], spacing: 7)
        let fileCard = Card()
        drop = FirmwareDrop(frame: .zero); drop.card = fileCard
        drop.accept = { [weak self] url in self?.select(url) }
        let fileSymbol = NSImageView(image: NSImage(systemSymbolName: "doc.badge.arrow.up", accessibilityDescription: "Stock firmware file")!)
        fileSymbol.contentTintColor = Palette.accent; fileSymbol.imageScaling = .scaleProportionallyUpOrDown
        fileSymbol.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([fileSymbol.widthAnchor.constraint(equalToConstant: 42), fileSymbol.heightAnchor.constraint(equalToConstant: 48)])
        fileLabel.setAccessibilityLabel("Selected stock firmware")
        let fileInfo = stack([fileLabel, fileHint], spacing: 6)
        fileInfo.setContentHuggingPriority(.defaultLow, for: .horizontal)
        fileLabel.preferredMaxLayoutWidth = 485
        choose.target = self; choose.action = #selector(chooseFile); choose.keyEquivalent = "o"
        choose.isBordered = false; choose.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([choose.widthAnchor.constraint(equalToConstant: 155), choose.heightAnchor.constraint(equalToConstant: 44)])
        let fileLine = stack([fileSymbol, fileInfo, choose], vertical: false, spacing: 20)
        let fileContents = stack([label("01   STOCK FIRMWARE", 16, .semibold, Palette.secondary), fileLine], spacing: 14)
        fileLine.widthAnchor.constraint(equalTo: fileContents.widthAnchor).isActive = true
        inset(fileContents, in: drop, amount: 20); inset(drop, in: fileCard, amount: 0)
        let releaseCard = Card()
        let releaseContents = stack([label("02   DIGIRUST", 16, .semibold, Palette.accent), label("Patch, kit, pattern & phrase generators", 21, .semibold), label("Adjustable kit Brutality, performance macros and drone latch.", 18, .regular, Palette.secondary)], spacing: 8)
        inset(releaseContents, in: releaseCard, amount: 20)
        create.primary = true; create.isBordered = false; create.target = self; create.action = #selector(createFile); create.keyEquivalent = "\r"; create.isEnabled = false
        reveal.isBordered = false; reveal.target = self; reveal.action = #selector(revealFile); reveal.isHidden = true
        for (button,width) in [(create,CGFloat(300)),(reveal,CGFloat(175))] {
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: width), button.heightAnchor.constraint(equalToConstant: 48)])
        }
        let actions = stack([create,reveal], vertical: false, spacing: 14)
        bar.isHidden = true; bar.isIndeterminate = false; bar.minValue = 0; bar.maxValue = 1; bar.style = .bar
        bar.setAccessibilityLabel("Firmware patching progress"); status.setAccessibilityLabel("Patcher status")
        let state = stack([statusTitle, status, bar], spacing: 9)
        status.preferredMaxLayoutWidth = 790
        let footer = label("Processed on this Mac. Your original file stays intact. No device connection.", 17, .regular, Palette.secondary)
        let content = stack([header,separator,intro,fileCard,releaseCard,actions,state,footer], spacing: 20)
        inset(content, in: view, amount: 34, pinBottom: false)
        // Every content card follows the window width; the layout remains readable when enlarged.
        for child in [header,separator,intro,fileCard,releaseCard,state,footer] {
            child.translatesAutoresizingMaskIntoConstraints = false
            child.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        }
        bar.widthAnchor.constraint(equalTo: state.widthAnchor).isActive = true
        do { engine = try Engine() } catch { showError(error); choose.isEnabled = false }
        window.center(); window.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps: true)
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { !busy }
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply { busy ? .terminateCancel : .terminateNow }
    func windowShouldClose(_ sender: NSWindow) -> Bool { !busy }
    func showError(_ error: Error) {
        statusTitle.stringValue = "Couldn’t complete this step"; statusTitle.textColor = Palette.accent
        status.stringValue = error.localizedDescription
        NSAccessibility.post(element: status, notification: .valueChanged)
    }
    func setBusy(_ value: Bool) {
        if value { bar.isHidden = false }
        busy = value; choose.isEnabled = !value; create.isEnabled = !value && input != nil; drop.enabled = !value
        window.standardWindowButton(.closeButton)?.isEnabled = !value
    }
    func select(_ url: URL) {
        guard !busy, let engine = engine else { return }
        savedOutput = nil; reveal.isHidden = true
        do {
            _ = try engine.readStock(url)
            input = url; fileLabel.stringValue = url.lastPathComponent
            fileHint.stringValue = "Verified official OS 1.12"; fileHint.textColor = Palette.success
            statusTitle.stringValue = "Ready to create"; statusTitle.textColor = Palette.text
            status.stringValue = "Choose where to save your DigiRust firmware."
            create.isEnabled = true; bar.doubleValue = 0
        } catch {
            input = nil; create.isEnabled = false; fileLabel.stringValue = "Choose a different firmware file"
            fileHint.stringValue = "Official Digitone II OS 1.12 required"; fileHint.textColor = Palette.secondary
            showError(error)
        }
    }
    @objc func chooseFile() {
        let panel = NSOpenPanel(); panel.canChooseDirectories = false; panel.allowsMultipleSelection = false; panel.allowedFileTypes = ["syx"]
        panel.message = "Choose the official Digitone II OS 1.12 .syx file."
        panel.beginSheetModal(for: window) { [weak self] response in if response == .OK, let url = panel.url { self?.select(url) } }
    }
    @objc func revealFile() { if let output = savedOutput { NSWorkspace.shared.activateFileViewerSelecting([output]) } }
    @objc func createFile() {
        guard let input = input, let engine = engine, !busy else { return }
        let panel = NSSavePanel(); panel.allowedFileTypes = ["syx"]; panel.nameFieldStringValue = "Digitone_II_OS1.12_DigiRust.syx"
        panel.message = "Save a new DigiRust firmware file. Existing files are never replaced."
        panel.beginSheetModal(for: window) { [weak self] response in
            guard response == .OK, let output = panel.url, let self = self else { return }
            self.setBusy(true); self.reveal.isHidden = true
            self.statusTitle.stringValue = "Creating your firmware"; self.statusTitle.textColor = Palette.text
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try engine.patch(input: input, output: output) { value, message in DispatchQueue.main.async { self.bar.doubleValue = value; self.status.stringValue = message } }
                    DispatchQueue.main.async {
                        self.setBusy(false); self.savedOutput = output; self.reveal.isHidden = false
                        self.statusTitle.stringValue = "Your firmware is ready"; self.statusTitle.textColor = Palette.success
                        self.status.stringValue = "DigiRust verified and saved. Show in Finder to locate your file."
                        NSAccessibility.post(element: self.status, notification: .valueChanged)
                    }
                } catch { DispatchQueue.main.async { self.setBusy(false); self.showError(error) } }
            }
        }
    }
}
if CommandLine.arguments.count > 1 {
    guard CommandLine.arguments.count == 4, CommandLine.arguments[1] == "--patch" else {
        fputs("Usage: DigiRust --patch stock.syx new-output.syx\n", stderr); exit(2)
    }
    do {
        let engine = try Engine()
        try engine.patch(input: URL(fileURLWithPath: CommandLine.arguments[2]), output: URL(fileURLWithPath: CommandLine.arguments[3])) { _, message in print(message) }
        print("SHA-256: \(engine.recipe.outputSHA256)")
    } catch { fputs("Error: \(error.localizedDescription)\n", stderr); exit(1) }
} else {
    let app = NSApplication.shared
    app.setActivationPolicy(.regular)
    let delegate = AppDelegate(); app.delegate = delegate
    app.run()
}
