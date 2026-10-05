#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>

typedef u_int16_t word;
typedef u_int8_t byte;

int offset;
unsigned char data[65535];

void processBinFile(char *name) {
  FILE *inc;
  int   i;
  int   file;
  char filename[256];
  char line[256];
  char buffer[256];
  byte temp[65535];
  word size;
  int  count;
  size = 0;
  strcpy(filename, "../Common/");
  strcat(filename, name);
  strcat(filename,".bin");

  inc = fopen("equ.inc", "a");
  sprintf(buffer,"%s_offset:", name);
  while (strlen(buffer) < 20) strcat(buffer," ");
  strcat(buffer,"equ      ");
  sprintf(line,"%d",offset);
  strcat(buffer,line);
  fprintf(inc, "%s\n",buffer);

  file = open(filename, O_RDONLY);
  while ((count = read(file, temp, 256)) > 0) {
    size += count;
    for (i=0; i<count; i++)
      data[offset++] = temp[i];
    }

  sprintf(buffer,"%s_size:", name);
  while (strlen(buffer) < 20) strcat(buffer," ");
  strcat(buffer,"equ      ");
  sprintf(line,"%d",size);
  strcat(buffer,line);
  fprintf(inc, "%s\n",buffer);
  fclose(inc);
  }

void processFile(char *name) {
  FILE *inc;
  int   i;
  FILE *file;
  char filename[256];
  char line[256];
  char buffer[256];
  byte temp[65535];
  word lowest;
  word highest;
  word address;
  char *pchar;
  byte value;
  byte valid;
  word size;
  size = 0;
  address = 0;
  lowest = 0xffff;
  highest = 0x0000;
  strcpy(filename, name);
  strcat(filename,".hex");

  inc = fopen("equ.inc", "a");
  sprintf(buffer,"%s_offset:", name);
  while (strlen(buffer) < 20) strcat(buffer," ");
  strcat(buffer,"equ      ");
  sprintf(line,"%d",offset);
  strcat(buffer,line);
  fprintf(inc, "%s\n",buffer);

  file = fopen(filename,"r");
  if (file == NULL) {
    strcpy(filename, "../Common/");
    strcat(filename, name);
    strcat(filename,".hex");
    file = fopen(filename,"r");
    if (file == NULL) {
      printf("Could not open file: %s\n",filename);
      exit(1);
      }
    }
  while (fgets(line,255,file) != NULL) {
    if (strlen(line) > 5) {
      value = 0;
      valid = 0;
      pchar = line;
      while (*pchar != 0) {
        if (*pchar == ':') {
          pchar++;
          address = 0;
          while (*pchar > ' ') {
            if (*pchar >= '0' && *pchar <= '9') 
              address = (address << 4) + (*pchar - '0');
            if (*pchar >= 'A' && *pchar <= 'F') 
              address = (address << 4) + (*pchar - 55);
            if (*pchar >= 'a' && *pchar <= 'f') 
              address = (address << 4) + (*pchar - 87);
            pchar++;
            }
          }
        if (*pchar >= '0' && *pchar <= '9') {
          value = (value << 4) + (*pchar - '0');
          valid = -1;
          }
        else if (*pchar >= 'A' && *pchar <= 'F') {
          value = (value << 4) + (*pchar - 55);
          valid = -1;
          }
        else if (*pchar >= 'a' && *pchar <= 'f') {
          value = (value << 4) + (*pchar - 87);
          valid = -1;
          }
        else if (*pchar == ' ') {
          if (valid != 0) {
            if (address < lowest) lowest = address;
            if (address > highest) highest = address;
            temp[address++] = value;
            size++;
            value = 0;
            valid = 0;
            }
          }
        else if (*pchar < ' ') *pchar = 0;
        if (*pchar != 0) pchar++;
        }
      if (valid) {
        if (address < lowest) lowest = address;
        if (address > highest) highest = address;
        temp[address++] = value;
        size++;
        value = 0;
        valid = 0;
        }
      }
    }
  fclose(file);
  size = (highest - lowest) + 1;

  sprintf(buffer,"%s_size:", name);
  while (strlen(buffer) < 20) strcat(buffer," ");
  strcat(buffer,"equ      ");
  sprintf(line,"%d",size);
  strcat(buffer,line);
  fprintf(inc, "%s\n",buffer);
  fclose(inc);

  for (i=lowest; i<= highest; i++) data[offset++] = temp[i];
  }

int main(int argc, char **argv) {
  int i;
  int count;
  offset = 0;
  unlink("equ.inc");
  processFile("sector0");
  processFile("sector1");
  processFile("sector2");
  processFile("md");
  processFile("bin");
  processFile("os");
  processFile("kernel");
  processBinFile("dir");
  processBinFile("chdir");
  processBinFile("lbr");
  processBinFile("xr");
  processBinFile("chmod");

  count = 0;
  for (i=0; i<offset; i++) {
    if (count == 0) printf("  db  ");
    printf("0%02xh",data[i]);
    if (i != offset-1) printf(",");
    count++;
    if (count == 16) {
      printf("\n");
      count = 0;
      }
    }
  if (count != 0) printf("\n");
  printf("; Data size: %d\n",offset);
  }

