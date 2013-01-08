#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define NUMOFBITS 32

unsigned int bitvector2decimal(const char* bitvector)
{
  if (bitvector[NUMOFBITS] != '\0')
  {
    printf("ERROR: bitvector %s not of length %d!\n", bitvector, NUMOFBITS);
    return -1;
  }

  int i;
  unsigned int pot = 1;
  unsigned int result = 0;
  for (i = NUMOFBITS-1; i >= 0; i--)
  {
    if (bitvector[i] != '0' && bitvector[i] != '1')
    {
      printf("ERROR: %c is no allowed character of bitvector!\n", bitvector[i]);
      return -1;
    }
    result += (bitvector[i]-'0')*pot;
    pot *= 2;
  }

  return result;
}

void decimal2bitvector(char* bitvector, unsigned int n)
{
  unsigned int exp = NUMOFBITS-1;
  unsigned int pot = 1 << exp;

  for (;pot > 0; pot /= 2)
  {
    if (n >= pot)
    {
      n -= pot;
      bitvector[NUMOFBITS-1-exp] = '1';
    }
    else
    {
      bitvector[NUMOFBITS-1-exp] = '0';
    }

    exp--;
  }

  bitvector[NUMOFBITS] = '\0';
}

int main()
{
  unsigned int m,n;
  char* bitvector = (char*) malloc ((NUMOFBITS+1)*sizeof(char));
  unsigned int N = 1 << 24;
  for (n = 0; n < N; n++)
  {
    decimal2bitvector(bitvector,n);
    m = bitvector2decimal(bitvector);
    //printf("%s\n",bitvector);
    if (m != n)
    {
      printf("test failed (%d != %d)!\n", n, m);
      return 1;
    }
  }
  printf("test passed!\n");

  free(bitvector);
  return 0;
}
