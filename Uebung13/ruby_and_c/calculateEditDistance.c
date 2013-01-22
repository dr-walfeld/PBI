#include "ruby.h"
#define MIN(a,b)  ((a < b) ? a : b)

static int calculateEditDistance(char *string_a, int length_a,
                                 char *string_b, int length_b){
  /* reserve memory for DP-table */
  int** matrix = malloc((length_a+1)*sizeof(int*));
  int* row = malloc((length_a+1)*(length_b+1)*sizeof(int));
  int i,j,equal,replacement,insertion,deletion,retval;

  /* set pointers and initialize first row/column */
  for(i = 0; i<= length_a; i++)
  {
    matrix[i] = row;
    matrix[i][0] = i;
    row += (length_b+1);
  }

  for(i = 0; i <= length_b; i++)
  {
    matrix[0][i] = i;
  }

  /* fill DP-table */
  for(i = 1; i <= length_a; i++)
  {
    for(j = 1; j <= length_b; j++)
    {
      equal = matrix[i-1][j-1];
      insertion = matrix[i-1][j] + 1;
      deletion = matrix[i][j-1] + 1;
      replacement = equal+1;

      /* when using unit costs replacement of equal bases if always minimal */
      if (string_a[i-1] == string_b[j-1])
        matrix[i][j] = equal;
      else
        matrix[i][j] = MIN(replacement,MIN(insertion,deletion));
    }
  }

  /* edit distance */
  retval = matrix[length_a][length_b];

  /* free memory */
  free(matrix[0]);
  free(matrix);

  return retval;
}


static VALUE t_init(VALUE self, VALUE s1, VALUE s2){
  rb_iv_set(self, "@string1", s1);
  rb_iv_set(self, "@string2", s2);
  return self;
}

static VALUE t_get_edit_dist(VALUE self){
  int retval;
  VALUE rubyVar1;
  VALUE rubyVar2;
  VALUE rubyString1;
  VALUE rubyString2;
  char *cString1;
  char *cString2;
  int length1;
  int length2;

  rubyVar1 = rb_iv_get(self, "@string1");
  rubyVar2 = rb_iv_get(self, "@string2");

  rubyString1 = StringValue(rubyVar1);
  rubyString2 = StringValue(rubyVar2);

  cString1 = RSTRING_PTR(rubyString1);
  cString2 = RSTRING_PTR(rubyString2);
  length1 = RSTRING_LEN(rubyString1);
  length2 = RSTRING_LEN(rubyString2);

  retval = calculateEditDistance(cString1,length1,cString2,length2);
  return INT2NUM(retval);
}

VALUE cClass;

void Init_calculateEditDistance(){
  cClass = rb_define_class("EditDistanceCalculator", rb_cObject);
  rb_define_method(cClass, "initialize", t_init, 2);
  rb_define_method(cClass, "getEditDistance", t_get_edit_dist, 0);
}
