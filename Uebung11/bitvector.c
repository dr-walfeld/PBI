#include <stdlib.h>
#include <stdio.h>

#define NUMOFBITS 32

/* convert bitvector to decimal number */
unsigned int bitvector2decimal(const char* bitvector)
{
  /* check bitvector length */
  if (bitvector[NUMOFBITS] != '\0')
  {
    printf("ERROR: bitvector %s not of length %d!\n", bitvector, NUMOFBITS);
    return -1;
  }

  int i;
  unsigned int pot = 1;
  unsigned int result = 0;
  /* start with 2^0 = 1 (last bit in bitvector) */
  for (i = NUMOFBITS-1; i >= 0; i--)
  {
    /* bitvector may contain only '0' and '1' (and terminating \0) */
    if (bitvector[i] != '0' && bitvector[i] != '1')
    {
      printf("ERROR: %c is no allowed character of bitvector!\n", bitvector[i]);
      return -1;
    }
    result += (bitvector[i]-'0')*pot;
    pot <<= 1;
  }

  return result;
}

/* build bit vector from unsigned int */
void decimal2bitvector(char* bitvector, unsigned int n)
{
  /* highest exponent is NUMOFBITS-1 */
  unsigned int exp = NUMOFBITS-1;
  unsigned int pot;

  /* start at first bit with 2^(NUMOFBITS-1) */
  for (pot = 1 << exp; pot > 0; pot >>= 1, exp--)
  {
    /* if 2^exp fits into n => subtract and set bitvector position to '1' */
    if (n >= pot)
    {
      n -= pot;
      bitvector[NUMOFBITS-1-exp] = '1';
    }
    else
    {
      bitvector[NUMOFBITS-1-exp] = '0';
    }
  }

  /* terminating \0 */
  bitvector[NUMOFBITS] = '\0';
}

int test()
{
  unsigned int m,n;
  /* allocate memory for bitvector */
  char* bitvector = (char*) malloc ((NUMOFBITS+1)*sizeof(char));
  /* look at numbers 0..n^24-1 */
  unsigned int N = 1 << 24;
  for (n = 0; n < N; n++)
  {
    decimal2bitvector(bitvector,n);
    m = bitvector2decimal(bitvector);
    /* show first 100 results */
    if (n < 100)
    {
      printf("%2d ^= %s\n",m,bitvector);
    }
    /* check if n and recalculated value from bitvector match */
    if (m != n)
    {
      printf("test failed (%d != %d)!\n", n, m);
      free(bitvector);
      return 1;
    }
  }
  printf("test passed!\n");

  free(bitvector);
  return 0;
}

int main()
{
  int status = test();

  return status;
}
