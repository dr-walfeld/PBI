#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>

#define NUMOFBITS 32
#define VLIMIT 127
//#define VLIMIT UINT_MAX

/* convert basenumber to decimal number;
   checks if limits of value range are violated;
   returns value limit if value encoded in basevector
   exceeds limit
*/
unsigned int basevector2decimal(unsigned int base, const char* basevector)
{
  int i,curr;
  unsigned int pot = 1;
  unsigned int result = 0;
  int limits = 0;

  /* check basevector length */
  if (basevector[NUMOFBITS] != '\0')
  {
    printf("ERROR: basevector %s not of length %d!\n", basevector, NUMOFBITS);
    return VLIMIT;
  }

  /* start with base^0 = 1 (last position in basevector) */
  for (i = NUMOFBITS-1; i >= 0; i--)
  {
    /* basevector may contain only 1..base-2 (and terminating \0) */
    if (basevector[i] < 1 || basevector[i] > base)
    {
      printf("ERROR: %d is no allowed character of basevector!\n", basevector[i]);
      return VLIMIT;
    }

    /* check if limit constants are violated */
    if (!limits)
    {
      curr = (basevector[i] - 1)*pot;

      /* check if new result violates limits */
      if (result > VLIMIT-curr)
      {
        printf("ERROR: value-limit overflow (result %u >= %u)!\n", result,
            VLIMIT-curr);
        return VLIMIT;
      }
      result += curr;

      /* if next power is outside definition range => limits */
      if (pot > VLIMIT/base)
      {
        limits = 1;
      }
      pot *= base;
    }
    /* but if limit of UINT is reached => return ERROR, if there is one value
       in basevector != 0 */
    else
    {
      if (basevector[i] != 1)
      {
        printf("ERROR: value limit overflow!\n");
        return VLIMIT;
      }
    }
  }

  return result;
}

/* return largest power base^exp in limits of UINT */
unsigned int potenz(unsigned int base, unsigned int exp, unsigned int* expc)
{
  unsigned int result = 1;
  unsigned int i;
  for (i = 1; i <= exp && result <= VLIMIT/base; i++)
  {
    result *= base;
  }

  /* save actual exponent value to parameter */
  *expc = i-1;

  return result;
}

/* build base vector from unsigned int */
void decimal2basenumber(unsigned int base, char* basevector, unsigned int n)
{
  /* highest exponent is NUMOFBITS-1 */
  unsigned int exp = NUMOFBITS-1;
  unsigned int expc;
  unsigned int pot = (unsigned int) potenz(base,exp,&expc);

  /* fill first with 0 */
  for (; exp > expc; exp--)
  {
    basevector[NUMOFBITS-1-exp] = 1;
  }

  /* if n exceeds highest value in pot
     => value can not be calculated */
  if (n/pot >= base)
  {
    printf("ERROR: value-overflow!\n");
    memset(basevector,1,NUMOFBITS*sizeof(char));
    return;
  }

  /* start at first bit with 2^(NUMOFBITS-1) */
  for (; pot > 0; pot /= base, exp--)
  {
    basevector[NUMOFBITS-1-exp] = n/pot + 1;
    n %= pot;
  }

  /* terminating \0 */
  basevector[NUMOFBITS] = '\0';
}

void show_basevector(int base, char* basevector)
{
  char chars[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int i;
  if (base <= 36)
  {
    for (i = 0; i < NUMOFBITS; i++)
    {
      putchar(chars[basevector[i]-1]);
    }
    putchar('\n');
  }
  else
  {
    printf("no meaningful characters available for base > 36\n");
  }
}

int test()
{
  unsigned int m,n,base;
  /* allocate memory for bitvector */
  char* basevector = (char*) malloc ((NUMOFBITS+1)*sizeof(char));
  /* look at numbers 0..n^24-1 */
  unsigned int N = 1 << 24;
  for (n = 0; n < N; n++)
  {
    /* printf("%u\n",n); */
    for (base = 2; base <=16; base++)
    {
      decimal2basenumber(base,basevector,n);
      m = basevector2decimal(base,basevector);
      /* show first 100 results */
      if (n <= 256)
      {
        printf("%2u_%-3u ^= ",m,base);
        show_basevector(base,basevector);
      }
      /* check if n and recalculated value from bitvector match */
      if (m != n)
      {
        printf("test failed (%u != %u)!\n", n, m);
        free(basevector);
        return 1;
      }
    }
  }
  printf("test passed!\n");

  free(basevector);
  return 0;
}

int main()
{
  int status = test();

  return status;
}
