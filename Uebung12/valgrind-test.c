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
  matrix[1][10] = 23;

  if (val % 2 == 0) {
    printf("foo\n");
    free(array);
  }

  *valp = 2;
  for (i=0; i<10; i++) {
    free(matrix[i]);
  }

  free(array);
  return 0;
}
