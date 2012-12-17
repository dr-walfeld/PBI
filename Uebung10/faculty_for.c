#include <stdio.h>                         /* use standard output routines */
#include <stdlib.h>                       /* use standard library functions */

int main(int argc, char *argv[])       /* name of function and arguments */
{                                         /* start block of statements */
  int value, count, n;                       /* declare variables */

  printf("input non-negative int: ");     /* ask for input */
  if(scanf("%d",&n) != 1)                 /* try to read integer */
  {                                       /* and check if successful */
    fprintf(stderr,"incorrect input\n");  /* show error message */
    return EXIT_FAILURE;                  /* return with error code */
  }
  if(n < 0)                               /* check if n is negative */
  {
    fprintf(stderr,"incorrect input\n");  /* show error message */
    return EXIT_FAILURE;                  /* return with error code */
  } 
  value = 1;                              /* initialize variable */
  for (count = 1; count <= n; count++)
  {
    value = value * count;                 /* modify value */
  }
  printf("%d!=%d\n",n,value);             /* print result */
  return EXIT_SUCCESS;                    /* return with success */
}                                   /* end block of statements */
