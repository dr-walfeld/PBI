#include <stdlib.h>
#include <stdio.h>

//int a, b, c, d;

static int read_input_number(char* whatnumber)
{
  int inputnum;
  printf("input %s: ", whatnumber);
  
  if(scanf("%d",&inputnum) != 1 || inputnum <= 0) {
  fprintf(stderr,"wrong input for %s\n", whatnumber);
  return -1;
  }

  return inputnum;
}

static int calc_exponent(int base, int exp)
{
  int result = base;

  int c;
  for(c = 1; c < exp; c++){ result *= base; }
  
  return result;
}

int main ()
{
  int result;

  int base = read_input_number("base");
  if (base == -1)
    return EXIT_FAILURE;

  int exp = read_input_number("exponent");
  if (exp == -1)
    return EXIT_FAILURE;

  result = calc_exponent(base,exp);

  printf("result of %d^%d is %d\n", base, exp, result);
  return( EXIT_SUCCESS );
}
