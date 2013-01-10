#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <assert.h>

#define MAX_STACK_ELEMENTS 100
/* random number [0.0,1.0) */
#define RANDOM_NUMBER_01 ( (double)rand() / ((double)RAND_MAX+1.0) )


typedef struct Stackelement {
  struct Stackelement *next;
  unsigned int data;
} Stackelement;

typedef struct {
  Stackelement *top;
  unsigned size;
} Stack;

int stack_is_empty(Stack*);

Stackelement* stackelement_new()
{
  Stackelement *se;
  se = malloc(sizeof(Stackelement));
  assert(se);
  /* initialize next element with NULL */
  se->next = NULL;
  return se;
}

void stackelement_delete(Stackelement* se)
{
  /* free memory and set pointer to NULL*/
  if (se != NULL)
  {
    free(se);
    se = NULL;
  }
}

Stack* stack_new()
{
  Stack *s;
  s = malloc(sizeof(Stack));
  assert(s);
  /* initialize first element with NULL */
  s->top = NULL;
  return s;
}

void stack_delete(Stack *s)
{
  /* delete all elements starting from top */
  if (s != NULL)
  {
    Stackelement* se = s->top;
    Stackelement* next;
    while (se != NULL)
    {
      next = se->next;
      stackelement_delete(se);
      se = next;
    }
    free(s);
    s = NULL;
  }
}

void stack_push(Stack *s, unsigned int data)
{
  assert(s);
  /* create new stackelement, write data and set element to top of stack */
  Stackelement* se = stackelement_new();
  se->data = data;
  se->next = s->top;
  s->top = se;
}

unsigned int stack_pop(Stack *s)
{
  unsigned int retval;
  assert(s);
  /* assert stack is not empty */
  assert(!stack_is_empty(s));
  /* store data-value, set top to next element and delete old top element */
  Stackelement* se = s->top;
  retval = se->data;
  s->top = se->next;
  stackelement_delete (se);

  return retval;
}

int stack_is_empty(Stack *s)
{
  assert(s);
  /* stack is empty if first element is NULL */
  return (s->top == NULL);
}

/* test the stack. returns 0 if stack is good, 1 else */
int test_stack(Stack *s)
{
  unsigned int expected_result[MAX_STACK_ELEMENTS];
  unsigned int u;
  unsigned int number;
  int retval = 0;

  for ( u=0 ; u < MAX_STACK_ELEMENTS; u++ ){
    number = RANDOM_NUMBER_01 * (UINT_MAX);
    stack_push (s, number);
    expected_result[u] = number;
  }

  u = MAX_STACK_ELEMENTS-1;
  while (!stack_is_empty(s)) {
    number = stack_pop(s);
    if (number != expected_result[u]) {
      printf("Expected %u but got %u\n", expected_result[u], number);
      retval = 1;
      break;
    }
    else {
      printf(".");
    }
    u--;
  }
  if (!stack_is_empty(s)) {
    printf("Stack should be empty!\n");
    retval = 1;
  }
  printf("\n");
  return retval;
}

int main()
{
  Stack *s;
  s = stack_new();
  if (test_stack(s) == 1) {
    puts("Schlechter Stack");
  }
  else {
    puts("Guter Stack");
  }
  stack_delete(s);
  return 0;
}
