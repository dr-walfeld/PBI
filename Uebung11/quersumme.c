#include <stdlib.h>
#include <stdio.h>

/* calculate digit sum of n */
unsigned int quersumme (unsigned int n)
{
  unsigned int result = 0;

  while (n > 0)
  {
    result += n%10;
    n /= 10;
  }

  return result;
}

int main(int argc, char* argv[])
{
  /* read number from command line */
  int n;
  if (argc < 2)
  {
    printf("usage: %s n\n", argv[0]);
    return 0;
  }

  if (sscanf(argv[1],"%d",&n) != 1 || n < 0)
  {
    printf("%s is no valid positive integer!\n", argv[1]);
    return 1;
  }

  /* calculate digit sum */
  unsigned int qs = quersumme((unsigned int) n);

  printf("qs from %d = %d\n", n, qs);

  return 0;
}
