/* Test oracle: exercise the existing C compressor for browser-port parity. */
#include "aplib.h"
#include <stdio.h>
#include <stdlib.h>
int main(int argc,char **argv){
 if(argc!=3)return 1;
 FILE *f=fopen(argv[1],"rb");if(!f)return 2;fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);
 unsigned char *input=calloc(n?n:1,1),*output=calloc(n*2+512,1);
 if(fread(input,1,n,f)!=(size_t)n)return 3;fclose(f);
 size_t size=ap_pack(input,n,output,n*2+512,0);if(size==(size_t)-1)return 4;
 f=fopen(argv[2],"wb");if(!f)return 5;fwrite(output,1,size,f);fclose(f);free(input);free(output);return 0;
}
