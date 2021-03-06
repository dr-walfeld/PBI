#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define MAXNOFELEMENTS 5000
#define SEEDVALUE 42349421
#define MAXVALUE 10000

/* structure representing partition */
typedef struct {
  unsigned int *values,*intermediates; /* values and intermediates */
  unsigned int nofelements; /* number of values */
  unsigned int totalsum, partsum; /* total sum and partial sum */
  char* isinA; /* is element i in A or B */
} Partition;

/* initialize new partition */
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

/* generate nofelements random numbers (1..maxvalue) and save to values 
   returns sum of generated randon numbers */
unsigned int generate_random_numbers(unsigned int* values, 
    unsigned int nofelements, unsigned int maxvalue, long int seed)
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

/* free memory of partition */
void partition_delete(Partition* part)
{
  if (part != NULL)
  {
    free(part->values);
    free(part->isinA);
    free(part->intermediates);
    free(part);
  }
}

/* show partition part on stdout (A: which = 0, B: which = 1, A&B: which = 2) */
void partition_show(Partition* part, int which)
{
  int i;
  for (i = 0; i < part->nofelements; i++)
  {
    if (which == 2 || (which == 0 && part->isinA[i]) 
        || (which == 1 && !part->isinA[i]))
    {
      printf("%u ", part->values[i]);
    }
  }
  printf("\n");
}

/* check if partition is correct;
   return 0 if correct, 1 otherwise */
int partition_validate(Partition* part)
{
  unsigned int sumA = 0, sumB = 0, i;

  for (i = 0; i < part->nofelements; i++)
  {
    if (part->isinA[i])
      sumA += part->values[i];
    else
      sumB += part->values[i];
  }

  return !(sumA == sumB && sumA+sumB == part->totalsum);
}

/* recursive function for calculation of partition;
   set brachandbound = 1 for use of branch&bound;
   return -1 if no partition possible and 0 otherwise */
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
  else if (branchandbound && nextelem < part->nofelements 
      && part->partsum < part->intermediates[nextelem])
    success = -1;
  /* if partsum still smaller than totalsum/2 =>
     call makepartition recusively, if elements left;
     calls to makepartition with nextelem == part->nofelements
     were either successfull or fall through to else case */
  else if (nextelem < part->nofelements)
  {
    /* if partition without current element successfull
       => try with current element */
    if(makepartition(part,nextelem+1,branchandbound))
    {
      part->partsum += part->values[nextelem];
      /* if partition with current element also not
         successfull => move up in recursive tree */
      if(makepartition(part,nextelem+1,branchandbound))
      {
        part->partsum -= part->values[nextelem];
        success = -1;
      }
      /* if partition with current element successfull
         => result has been found */
      else
      {
        success = 0;
        part->isinA[nextelem] = 1;
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

int makePartitionDP(Partition* part)
{
  if (part->totalsum & 1)
    return -1;

  unsigned int j,target, **dptable,*row;
  int i,result;

  target = part->totalsum >> 1;

  dptable = malloc((target+1)*sizeof(unsigned int*));
  row = calloc((target+1)*(part->nofelements+1), sizeof(unsigned int));

  for (i = 0; i <= target; i++)
  {
    dptable[i] = row + i*(part->nofelements+1);
  }

  for (i = 1; i <= target; i++)
  {
    for (j = 1; j <= part->nofelements; j++)
    {
      if(i - part->values[j-1] == 0)
      {
        dptable[i][j] = j;
      }
      else if (i > part->values[j-1])
      {
        if (dptable[i - part->values[j-1]][j-1] > 0)
          dptable[i][j] = j;
        else
          dptable[i][j] = dptable[i][j-1];
      }
    }
  }

  if (!dptable[target][part->nofelements])
    result = -1;
  else
  {
    result = 0;
    i = target;
    j = part->nofelements;
    while(i > 0)
    {
      //printf("%d,",i);
      j = dptable[i][j];
      part->isinA[j-1] = 1;
      i -= part->values[j-1];
      j--;
    }
  }

  free(dptable[0]);
  free(dptable);

  return result;
}



/* calculate intermediate threshold values:
   which value has to be reached at position i
   so the target could be reached with sum i..nofelements-1 */
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

/* calculate partition of random numbers given number of elements;
   branchandbound specifies usage of branch&bound by partition function
   and values are printed on stdout, if printout is set; results are validated
   if validate is set;
   returns return-value of makepartition */
int test_number(int nofelements, int branchandbound, int printout, int validate)
{
  Partition* part;
  int result;

  part = partition_initialize(nofelements);
  /* generate random numbers */
  part->totalsum = generate_random_numbers(part->values, part->nofelements, 
      MAXVALUE, SEEDVALUE);

  /* calculate intermediate scores only if branch&bound is used */
  if (branchandbound)
  {
    calculate_intermediates(part->values, part->intermediates, part->nofelements,
        part->totalsum >> 1);
  }
  
  /* try partitioning part */
  result = makePartitionDP(part);//makepartition(part,0,branchandbound);

  /* show results */
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
      printf("zwei Untermengen mit der Summe %u aufgeteilt werden:\n", part->totalsum >> 1);
      printf("Zahlen in Untermenge A:\n");
      partition_show(part,0);
      printf("Zahlen in Untermenge B:\n");
      partition_show(part,1);
    }
  }

  /* test validity if partition was possible */
  if(validate && !result)
  {
    assert(!partition_validate(part));
  }

  /* free memory */
  partition_delete(part);

  return result;
}

/* test partitioning;
   parameters: number of elements and test-mode;
   test-mode:
     0: calculate partition for array with nofelements and show results
     1: calculate partition for array (1 upto nofelements) with and 
        without branch&bound and compare and check results
     2: calculate partition for array (1 upto nofelements) without
        branch&bound for benchmark
     3: same as 2 WITH branch&bound
*/
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
    test_number(nofelements,0,1,0);
    test_number(nofelements,1,1,0);
  }
  else
  {
    for (i = 1; i <= nofelements; i++)
    {
      /* test if correct */
      if (mode == 1)
        assert(test_number(i,0,0,1) == test_number(i,1,0,1));
      /* benchmark w/o b&b */
      else if (mode == 2)
        test_number(i,0,0,0);
      /* benchmark with b&b */
      else if (mode == 3)
        test_number(i,1,0,0);
    }
  }

  return 0;
}
