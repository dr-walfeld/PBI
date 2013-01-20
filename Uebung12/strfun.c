#include <stdlib.h>
#include "strfun.h"

/* search character c in string s (first hit) */
char* mystrchr(const char* s, int c)
{
  while(*s != '\0')
  {
    /* return first character found */
    if (*s == c)
      return (char*)s;
    s++;
  }
  return NULL;
}

/* search character c in string s (last hit) */
char* mystrrchr(const char* s, int c)
{
  char* found = NULL;

  while (*s != '\0')
  {
    if(*s == c)
      found = (char*)s;
    s++;
  }
  return found;
}

/* find first accepted character in string s */
char* mystrpbrk(const char* s, const char* accept)
{
  const char* sa;
  while(*s != '\0')
  {
    sa = accept;
    while(*sa != '\0')
    {
      if (*s == *sa)
        return (char*)s;
      sa++;
    }
    s++;
  }
  return NULL;
}

/* longest stretch of accepted characters in s */
size_t mystrspn(const char* s, const char* accept)
{
  const char* sa;
  char* found;
  size_t length = 0;

  while(*s != '\0')
  {
    sa = accept;
    found = NULL;
    while(*sa != '\0')
    {
      if (*s == *sa)
        found = (char*)s;
      sa++;
    }
    if (found == NULL)
      return length;
    length++;
    s++;
  }

  return length;
}

/* compare n bytes in strings s1 and s2 */
int mystrncmp(const char* s1, const char* s2, size_t n)
{
  unsigned int i = 0, j = 0;
  int diff = 0;
  for (i = 0; i < n && s1[i] != '\0' && s2[i] != '\0' && diff == 0; i++)
  {
    diff = s1[i]-s2[i];
  }
  return diff;
}
