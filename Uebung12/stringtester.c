#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "strfun.h"

#define MAXLINE 1024

int testfunctions(FILE* stream)
{
  char line[MAXLINE+1];
  char oldline[MAXLINE+1];
  char *c;
  char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  int firstline = 1;

  while (fgets(line,MAXLINE,stream) != NULL)
  {
    /* test search A-Za-z for each line */
    c = alphabet;
    while (*c != '\0')
    {
      if (mystrchr(line, (int)*c) != strchr(line, (int)*c))
      {
        printf("fail in function mystrchr for c = \\%d\n",*c);
        return 1;
      }
      if (mystrrchr(line, (int)*c) != strrchr(line, (int)*c))
      {
        printf("fail in function mystrrchr for c = \\%d\n",*c);
        return 1;
      }
      c++;
    }
    /* test accepted characters (A-Za-z) */
    if (mystrpbrk(line, alphabet) != strpbrk(line, alphabet))
    {
      printf("fail in function mystrpbrk\n");
      return 1;
    }
    if (mystrspn(line, alphabet) != strspn(line, alphabet))
    {
      printf("fail in function mystrspn\n");
      return 1;
    }

    /* test cmp of current line and preceeding line */
    if (!firstline)
    {
      if (mystrncmp(line, oldline, MAXLINE) != strncmp(line, oldline, MAXLINE))
      {
        printf("fail in function mystrcmp\n");
        return 1;
      }
    }
 
    strcpy(oldline,line);
    firstline = 0;
  }
  printf("test passed!\n");
  return 0;
}

int main(int argc, char* argv[])
{
  int retval;

  if (argc < 2)
  {
    printf("usage: %s testfile\n", argv[0]);
    return 0;
  }

  FILE* stream = fopen(argv[1], "rt");
  if (stream == NULL)
  {
    printf("ERROR: could not open testfile %s\n", argv[1]);
    return 1;
  }

  retval = testfunctions(stream);

  fclose(stream);

  return retval;
}
