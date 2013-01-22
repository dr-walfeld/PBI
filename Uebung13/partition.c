#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define MAXNOFELEMENTS 5000
#define SEEDVALUE 42349421
#define MAXVALUE 10000

typedef struct {
  unsigned int *values,*intermediates;
  unsigned int nofelements;
  unsigned int totalsum, partsum;
  char* isinA;
} Partition;

Partition* partition_initialize(unsigned int nofelements)
{
  Partition* part = malloc(sizeof(Partition));
  assert(part);
  part->nofelements = nofelements;
  part->values = calloc(nofelements, sizeof(unsigned int));
  assert(part->values);
  part->totalsum = 0;
  part->partsum = 0;
  part->isinA = calloc(nofelements, sizeof(char));
  assert(part->isinA);
  part->intermediates = calloc(nofelements, sizeof(unsigned int));
  assert(part->intermediates);
  return part;
}

unsigned int generate_random_numbers(unsigned int* values, unsigned int nofelements, unsigned int maxvalue, long int seed)
{
  unsigned int i, sum = 0;
  srand48(seed);
  
  for (i = 0; i < nofelements; i++)
  {
    values[i] = 1 + (unsigned int)(drand48()*maxvalue);
    sum += values[i];
  }

  return sum;
}

void partition_delete(Partition* part)
{
  if (part != NULL)
  {
    free(part->values);
    free(part->isinA);
    free(part);
  }
}

void partition_show(Partition* part, int which)
{
  int i;
  for (i = 0; i < part->nofelements; i++)
  {
    if ((which == 0 && part->isinA[i]) || (which == 1 && !part->isinA[i]))
    {
      printf("%u ", part->values[i]);
    }
  }
  printf("\n");
}

int makepartition(Partition* part, int nextelem, int branchandbound)
{
  int success;

  /* if totalsum is not even => partition impossible */
  if (part->totalsum & 1)
    success = -1;
  /* if partsum already greater than half of totalsum
     => summing up more values won't help (check upper bound)*/
  else if (branchandbound && part->partsum > part->totalsum >> 1)
    success = -1;
  /* check if partition is already matching */
  else if (part->partsum == part->totalsum >> 1)
    success = 0;
  /* look ahead if the target could be reached by
     summing up all following values (check lower bound) */
  else if (branchandbound && nextelem < part->nofelements && part->partsum < part->intermediates[nextelem])
    success = -1;
  /* if partsum still smaller than totalsum/2 =>
     call makepartition recusively, if elements left;
     calls to makepartition with nextelem == part->nofelements
     are either successfull or fall through to else case */
  else if (nextelem < part->nofelements)
  {
    /* if partition without current element successfull
       => try with current element */
    if(makepartition(part,nextelem+1,branchandbound))
    {
      part->isinA[nextelem] = 1;
      part->partsum += part->values[nextelem];
      /* if partition with current element also not
         successfull => move up in recursive tree */
      if(makepartition(part,nextelem+1,branchandbound))
      {
        part->isinA[nextelem] = 0;
        part->partsum -= part->values[nextelem];
        success = -1;
      }
      /* if partition with current element successfull
         => result has been found */
      else
      {
        success = 0;
      }
    }
    /* if partition without current element successfull
       => result found */
    else
    {
      success = 0;
    }
  }
  /* if none of the above conditions match
     => non-successfull end of recursion */
  else
  {
    success = -1;
  }

  return success;
}

/* calculate intermediate threshold values */
void calculate_intermediates(unsigned int* values, unsigned int* intermediates, 
    unsigned int nofelements, unsigned int threshold)
{
  int i = nofelements-1;
  int diff;
  /* if difference is negative => set to 0 (because of unsigned int) */
  intermediates[i] = (diff = threshold-values[i]) > 0 ? diff : 0;
  
  for (i = nofelements-2; i >= 0; i--)
  {
    intermediates[i] = (diff = intermediates[i+1]-values[i]) > 0 ? diff : 0;
  }
}

/* calculate partition given number of elements */
int test_number(int nofelements, int branchandbound, int printout)
{
  Partition* part;
  int result;

  part = partition_initialize(nofelements);
  part->totalsum = generate_random_numbers(part->values, part->nofelements, MAXVALUE, SEEDVALUE);
  if (branchandbound)
  {
    calculate_intermediates(part->values, part->intermediates, part->nofelements,
        part->totalsum >> 1);
  }
  
  result = makepartition(part,0,branchandbound);

  if (printout)
  {
    if (result)
    {
      printf("Die Zahlenmenge\n");
      partition_show(part,1);
      printf("der Groesse %u kann nicht in zwei\n", part->nofelements);
      printf("summengleiche Untermengen aufgeteilt werden!\n");
    }
    else
    {
      printf("Die Zahlenmenge der Groesse %u kann in\n" , part->nofelements);
      printf("zwei Untermengen mit der Summe %u aufgeteilt werden:\n", part->totalsum >> 2);
      printf("Zahlen in Untermenge A:\n");
      partition_show(part,0);
      printf("Zahlen in Untermenge B:\n");
      partition_show(part,1);
    }
  }

  partition_delete(part);

  return result;
}

void benchmark(int nofelements)
{
}

int main(int argc, char* argv[])
{
  unsigned int nofelements,mode,i;

  if (argc < 3)
  {
    fprintf(stderr,"usage: %s nofelements mode (0: show result, \n", argv[0]);
    fprintf(stderr,"1: test b&b, 2: benchmark without b&b, 3: benchmark with b&b\n");
    return 0;
  }

  if (sscanf(argv[1], "%u", &nofelements) != 1 || nofelements > MAXNOFELEMENTS)
  {
    fprintf(stderr,"ERROR: %s is no valid number of elements!\n", argv[1]);
    return 1;
  }

  if (sscanf(argv[2], "%u", &mode) != 1 || (mode < 0 || mode > 3))
  {
    fprintf(stderr,"ERROR: %s is no valid parameter for benchmark (0 or 1)!\n",
        argv[2]);
  }

  if (mode == 0)
  {
    test_number(nofelements,0,1);
    test_number(nofelements,1,1);
  }
  else
  {
    for (i = 1; i <= nofelements; i++)
    {
      if (mode == 1)
        assert(test_number(nofelements,0,0) == test_number(nofelements,1,0));
      else if (mode == 2)
        test_number(nofelements,0,0);
      else if (mode == 3)
        test_number(nofelements,1,0);
    }
  }

  return 0;
}
