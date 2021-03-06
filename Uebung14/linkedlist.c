#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

#include "linkedlist.h"

struct List_element {
  struct List_element* prev;
  struct List_element* next;
  unsigned long key;
};

struct List {
  List_element* first;
  List_element* last;
};

unsigned long list_element_get_value(const List_element* el)
{
  assert(el);
  return el->key;
}

void list_element_show(const List_element* el)
{
  if (el != NULL)
  {
    printf("%lu\n", list_element_get_value(el));
  }
}

List_element* list_first(const List* l)
{
  assert(l);
  return l->first;
}

List_element* list_last(const List* l)
{
  assert(l);
  return l->last;
}

List* list_new(void)
{
  List* l = malloc(sizeof(List));
  assert(l);
  l->first = l->last = NULL;
  return l;
}

List_element* list_element_next(const List_element* le)
{
  assert(le);
  return le->next;
}

List_element* list_element_prev(const List_element* le)
{
  assert(le);
  return le->prev;
}

void list_append(List* l, unsigned long value)
{
  List_element* new_el = malloc(sizeof(List_element));
  assert(new_el);
  new_el->next = NULL;
  new_el->key = value;
  new_el->prev = l->last;
  if (l->last)
    l->last->next = new_el;
  else
    l->first = new_el;
  l->last = new_el;
}

bool list_search(const List* l, unsigned long value)
{
  assert(l);
  if (l->last != NULL && value <= l->last->key)
  {
    List_element* curr = l->first;
    while(curr != NULL && curr->key <= value)
    {
      if (curr->key == value)
        return true;
      curr = curr->next;
    }
  }
  return false;
}

void list_ordered_insert(List* l, unsigned long value)
{
  assert(l);
  List_element* new_el = malloc(sizeof(List_element));
  assert(new_el);
  new_el->key = value;

  if (l->last == NULL)
  {
    l->first = l->last = new_el;
    new_el->next = new_el->prev = NULL;
  }
  else
  {
    if (value <= l->last->key)
    {
      if (value <= l->first->key)
      {
        new_el->next = l->first;
        new_el->prev = NULL;
        l->first->prev = new_el;
        l->first = new_el;
      }
      else
      {
        List_element* curr = l->first;
        while(curr->next->key < value)
        {
          curr = curr->next;
        }
        new_el->prev = curr;
        new_el->next = curr->next;
        curr->next->prev = new_el;
        curr->next = new_el;
      }
    }
    else
    {
      l->last->next = new_el;
      new_el->prev = l->last;
      l->last = new_el;
      new_el->next = NULL;
    }

  }
}

void list_show(const List* l)
{
  assert(l);
  List_element* curr;
  unsigned int counter = 0;
  curr = list_first(l);

  while (curr != NULL)
  {
    printf("#%d: %lu\n", counter, curr->key);
    counter++;
    curr = curr->next;
  }
}

void list_delete_element(List* l, List_element* el)
{
  assert(l);
  assert(el);

  if (el->prev != NULL)
    el->prev->next = el->next;
  else
    l->first = el->next;
  if (el->next != NULL)
    el->next->prev = el->prev;
  else
    l->last = el->prev;

  free(el);
}

void list_delete(List* l)
{
  assert(l);

  List_element* curr = l->first;
  List_element* next;
  while(curr != NULL)
  {
    next = curr->next;
    free(curr);
    curr = next;
  }
  free(l);
}
