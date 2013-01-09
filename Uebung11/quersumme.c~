#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
  int n;
  if (argc < 2)
  {
    printf("usage: %s n\n", argv[0]);
    return 0;
  }

  if (sscanf(argv[1],"%d",&n) != 1)
  {
    printf("%s is no valid integer!\n", argv[1]);
    return 1;
  }

  int qs = quersumme(n);

  printf("qs from %d = %d\n", n, qs);

  return 0;
}
