#include <stdlib.h>
#include <stdio.h>

int a, b, c, d;

static int
ask()
{
  printf("input number\n");
  d=a;
  if(scanf("%d",&b) != 1 || b <= 0) {
  fprintf(stderr,"wrong input\n");
  return( 1000 );
  }
  return( 4 );
}

static int
do_it()
{
  int r;
  r = ask();
  if( r == 1000 ) return 1000;
  for(c=1; c < b; c++){ d *= a; }
  return( 4 );
}

int main ()
{
  int r;

  printf("input number\n");
  if(scanf("%d",&a) != 1 || a <= 0) {
  fprintf(stderr,"wrong input\n");
  return EXIT_FAILURE;
  }

  r = do_it();
  if(r == 1000 ) return(EXIT_FAILURE);
  printf("result is %d\n", d);
  return( EXIT_SUCCESS );
}
