%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "main.tab.h" // Assumes bison output is main.tab.c
%}

/*
WARNING: The 'variable' rule only supports single, lowercase letters
and will not work for multi-character names or uppercase letters.
*/
variable    [a-zA-Z]
digit       [0-9]
header      "import ".*
Comment     #.*

%%
"CASE"          {return CASE;}
"SWITCH"        {return SWITCH;}
"DEFAULT"       {return DEFAULT;}
{digit}+        {yylval = atoi(yytext); return NUM;}
"PRINTFUNCTION" {return PRINTFUNCTION;}
"IF"            {return IF;}
"ELSE"          {return ELSE;}
"{"             {return BRACKETSTART;}
"}"             {return BRACKETEND;}
"FOR"           {return FOR;}
"WHILE"         {return WHILE;}
"FACTORIAL"     {return FACTORIAL;}
"ODDEVEN"       {return ODDEVEN;}
"SIN"           {return SIN;}
"COS"           {return COS;}
"TAN"           {return TAN;}
"LOG"           {return LOG;}
"INTEGER"       {return INT;}
"CHAR"          {return CHAR;}
"FLOAT"         {return FLOAT;}
"ARRAY"         {return ARRAY;}
"TRY"           {return TRY;}
"CATCH"         {return CATCH;}
"FUNCTION"      {return FUNCTION;}
"CLASS"         {printf("New Class  Name : "); ECHO; printf(" "); return CLASS;}
"Main"          {printf("\nMain Function Start\n"); return MAIN;}
{Comment}       {printf("\nSingle line Comment found :: %s\n", yytext);}
{header}        {printf("\nHeader file found: %s\n", yytext);}
[-+/*<>=,():;%^] {yylval = yytext[0]; return yytext[0];}
{variable}      {yylval = yytext[0] - 'a'; return VAR;}

[ \t\n]+        /* Eat up whitespace */
.               {printf("\nUnknown Syntax : %s\n", yytext);}

%%