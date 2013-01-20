#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  int **matrix,
      val,
      *valp = NULL,
      *array;
  unsigned long i;

  array = malloc(10 * sizeof (*array));
  matrix = malloc(10 * sizeof (int*));
  for (i=0; i<10; i++) {
    matrix[i] = malloc(10 * sizeof (int));
  }
  matrix[0][9] = 23; /* wrong indexing */

  val = 2; /* initialize val */

  if (val % 2 == 0) {
    printf("foo\n");
    /* free(array); */
  }
  /* allocate memory for valp, do not write to NULL */
  valp = malloc(sizeof(int));
  *valp = 2;
  for (i=0; i<10; i++) {
    free(matrix[i]);
  }

  free(valp); /* free valp */
  free(matrix); /* free matrix */
  free(array);
  return 0;
}
