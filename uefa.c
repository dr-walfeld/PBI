#include <stdlib.h>
#include <stdio.h>

#define NUMTEAMS 8
//#define NUMTEAMS 4

enum countries {
  D,F,P,GB,E,I,UA,SC,TR};

typedef struct team {
  char* name;
  int land;
  int group;
  int pos;
  int selected;
} team;

team* team_new(char* name, int land, int group, int pos)
{
  team* temp = (team*) malloc(sizeof(team));
  temp->name = name;
  temp->land = land;
  temp->group = group;
  temp->pos = pos;
  temp->selected = 0;

  return temp;
}

void combine(team** fst, team** snd, int n, int dephth, long* target)
{
  if (dephth == n)
  {
    (*target)++;
    //printf("%d\n",*target);
  }
  else
  {
    int i,j;
    for(i = 0; i < n; i++)
    {
      for (j = 0; j < n; j++)
      {
        if (i != j && !fst[i]->selected && !snd[j]->selected && fst[i]->land != snd[j]->land)
        {
          fst[i]->selected = 1;
          snd[j]->selected = 1;
          combine(fst,snd,n,dephth+1,target);
          fst[i]->selected = 0;
          snd[j]->selected = 0;
        }
      }
    }
  }
}

int main()
{
  team** firsts = (team**) malloc(NUMTEAMS*sizeof(team));
  team** secnds = (team**) malloc(NUMTEAMS*sizeof(team));

  firsts[0] = team_new("Paris",F,0,0);
  firsts[1] = team_new("Schalke",D,1,0);
  firsts[2] = team_new("Malaga",E,2,0);
  firsts[3] = team_new("Dortmund",D,3,0);
  firsts[4] = team_new("Turin",I,4,0);
  firsts[5] = team_new("Bayern",D,5,0);
  firsts[6] = team_new("Barcelona",E,6,0);
  firsts[7] = team_new("ManU",GB,7,0);

  secnds[0] = team_new("Porto",P,0,1);
  secnds[1] = team_new("Arsenal",GB,1,1);
  secnds[2] = team_new("Mailand",I,2,1);
  secnds[3] = team_new("Madrid",E,3,1);
  secnds[4] = team_new("Donezk",UA,4,1);
  secnds[5] = team_new("Valencia",E,5,1);
  secnds[6] = team_new("Celctic",SC,6,1);
  secnds[7] = team_new("Galatasaray",TR,7,1);

  long numbers = 0;
  (void) combine(firsts,secnds,NUMTEAMS,0,&numbers);
  printf("%d\n",numbers);

  return 0;
}
