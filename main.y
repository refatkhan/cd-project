%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>

	void yyerror(char *s);
	int yylex(void);

	int sym[30];

	int variablenumber=0;
	int expressionnumber=0;
	int variableassignment=0;
	int switchnumber=0;
	int printnumber=0;
	int fornumber=0;
	int arraynumber=0;
	int classnumber=0;
	int trycatchnumber=0;
	int functionnumber=0;
	int whilenumber=0;
	int mathexpressionnumber=0;
	int ifelsenumber=0;
%}

/* Bison Declarations */
%token NUM VAR IF ELSE ARRAY MAIN INT FLOAT CHAR BRACKETSTART BRACKETEND FOR WHILE ODDEVEN PRINTFUNCTION SIN COS TAN LOG FACTORIAL CASE DEFAULT SWITCH CLASS TRY CATCH FUNCTION

%nonassoc IFX
%nonassoc ELSE

%left '<' '>'
%left '+' '-'
%left '*' '/' '%'
%right '^'

/* Grammar Rules */
%%

program: MAIN ':' BRACKETSTART line BRACKETEND {printf("Main function END\n");}
	 ;

line: /* NULL */
	| line statement
	;

statement: ';'
	| declaration ';'   { printf("Declaration\n"); variablenumber++;}

	| expression ';'    { printf("\nValue of expression: %d\n", $1); $$=$1;
		                  printf("\n.........................................\n");
		                  expressionnumber++;
		                }

	| VAR '=' expression ';' {
							printf("\nValue of the variable: %d\n", $3);
							sym[$1] = $3;
							$$ = $3;
							printf("\n.........................................\n");
							variableassignment++;
						 }

	| WHILE '(' NUM '<' NUM ')' BRACKETSTART statement BRACKETEND {
						int i;
						printf("WHILE Loop execution");
						for(i=$3; i<$5; i++) {
						    printf("\nValue of the loop: %d expression value: %d\n", i, $8);
						}
						printf("\n.........................................\n");
						whilenumber++;
					}

	| IF '(' expression ')' BRACKETSTART statement BRACKETEND %prec IFX {
						if($3){
							printf("\nValue of expression in IF: %d\n", $6);
						} else {
							printf("\nCondition value zero in IF block\n");
						}
						printf("\n.........................................\n");
						ifelsenumber++;
					}

	| IF '(' expression ')' BRACKETSTART statement BRACKETEND ELSE BRACKETSTART statement BRACKETEND {
						if($3){
							printf("Value of expression in IF: %d\n", $6);
						} else {
							printf("Value of expression in ELSE: %d\n", $11);
						}
						ifelsenumber++;
						printf("\n.........................................\n");
					}

	| PRINTFUNCTION '(' expression ')' ';' {
						printf("\nPrint Expression %d\n", $3);
						printnumber++;
						printf("\n.........................................\n");
					}

	| FACTORIAL '(' NUM ')' ';' {
						printf("\nFACTORIAL declaration\n");
						int i;
						int f=1;
						for(i=1; i<=$3; i++) { f=f*i; }
						printf("FACTORIAL of %d is : %d\n", $3, f);
						printf("\n.........................................\n");
						functionnumber++;
					}

	| ODDEVEN '(' NUM ')' ';' {
						printf("Odd Even Number detection \n");
						if($3 % 2 == 0) {
							printf("Number : %d is -> Even\n", $3);
						} else {
							printf("Number is :%d is -> Odd\n", $3);
						}
						printf("\n.........................................\n");
						functionnumber++;
					}

	| FUNCTION VAR '(' expression ')' BRACKETSTART statement BRACKETEND {
						printf("FUNCTION found\n");
						printf("Function Parameter : %d\n", $4);
						printf("Function internal block statement : %d\n", $7);
						printf("\n.........................................\n");
						functionnumber++;
					}

	| ARRAY TYPE VAR '(' NUM ')' ';' {
						printf("ARRAY Declaration\n");
						printf("Size of the ARRAY is : %d\n", $5);
						arraynumber++;
						printf("\n.........................................\n");
					}

	| SWITCH '(' NUM ')' BRACKETSTART SWITCHCASE BRACKETEND {
						printf("\nSWITCH CASE Declaration\n");
						printf("\nFinally Choose Case number :-> %d\n", $3);
						printf("\n.........................................\n");
						switchnumber++;
					}

	| CLASS VAR BRACKETSTART statement BRACKETEND {
						printf("Class Declaration\n");
						// printf("Expression : %d\n", $4); // This can print garbage
						classnumber++;
					}

	| CLASS VAR ':' VAR BRACKETSTART statement BRACKETEND {
						printf("Inheritance occur \n");
						// printf("Expression value : %d", $6); // This can print garbage
						classnumber++;
					}

	| TRY BRACKETSTART statement BRACKETEND CATCH '(' expression ')' BRACKETSTART statement BRACKETEND {
						printf("TRY CATCH block found\n");
						printf("TRY Block operation : %d\n", $3);
						printf("CATCH Value : %d\n", $7);
						printf("Catch Block operation :%d\n", $10);
						printf("\n.........................................\n");
						trycatchnumber++;
					}

	| FOR '(' NUM ',' NUM ',' NUM ')' BRACKETSTART statement BRACKETEND {
						int i;
						printf("FOR Loop execution");
						for(i=$3; i<$5; i=i+$7) {
						    printf("\nValue of i: %d, expression value : %d\n", i, $10);
						}
						printf("\n.........................................\n");
						fornumber++;
					}
	;

declaration: TYPE ID1 {
						printf("\nVariable Detection\n");
						printf("\n.........................................\n");
					}
	;

TYPE: INT   {printf("Integer declaration\n");}
	| FLOAT {printf("Float declaration\n");}
	| CHAR  {printf("Char declaration\n");}
	;

ID1: ID1 ',' VAR
   | VAR
   ;

SWITCHCASE: casegrammer
			| casegrammer defaultgrammer
			;

casegrammer: /*empty*/
			| casegrammer casenumber
			;

casenumber: CASE NUM ':' expression ';' {printf("Case No : %d & expression value :%d \n", $2, $4);}
			;
defaultgrammer: DEFAULT ':' expression ';' {
				printf("\nDefault case & expression value : %d\n", $3);
			}
		;

expression: NUM                                { printf("\nNumber :  %d\n", $1); $$ = $1; }
	| VAR                                   { $$ = sym[$1]; }
	| expression '+' expression             { printf("\nAddition : %d + %d = %d\n", $1, $3, $1 + $3); $$ = $1 + $3; }
	| expression '-' expression             { printf("\nSubtraction : %d - %d = %d\n", $1, $3, $1 - $3); $$ = $1 - $3; }
	| expression '*' expression             { printf("\nMultiplication : %d * %d = %d\n", $1, $3, $1 * $3); $$ = $1 * $3; }
	| expression '/' expression             { if($3) { printf("\nDivision : %d / %d = %d\n", $1, $3, $1 / $3); $$ = $1 / $3; }
											  else { $$ = 0; printf("\nDivision by zero\n"); }
											}
	| expression '%' expression             { if($3) { printf("\nMod : %d %% %d = %d\n", $1, $3, $1 % $3); $$ = $1 % $3; }
											  else{ $$ = 0; printf("\nMOD by zero\n"); }
											}
	| expression '^' expression             { printf("\nPower : %d ^ %d = %d\n", $1, $3, (int)pow($1, $3)); $$ = (int)pow($1, $3); }
	| expression '<' expression             { printf("\nLess Than : %d < %d = %d\n", $1, $3, $1 < $3); $$ = $1 < $3; }
	| expression '>' expression             { printf("\nGreater than : %d > %d = %d\n", $1, $3, $1 > $3); $$ = $1 > $3; }
	| '(' expression ')'                    { $$ = $2; }
	| SIN expression                        { printf("\nValue of Sin(%d) is : %lf\n", $2, sin($2*3.1416/180)); $$ = (int)sin($2*3.1416/180); }
	| COS expression                        { printf("\nValue of Cos(%d) is : %lf\n", $2, cos($2*3.1416/180)); $$ = (int)cos($2*3.1416/180); }
	| LOG expression                        { printf("\nValue of Log(%d) is : %lf\n", $2, log($2)); $$ = (int)log($2); }
	;
%%

void yyerror(char *s) {
	fprintf(stderr, "Error: %s\n", s);
}

int yywrap() {
	return 1;
}

int main() {
	// Make sure you have an "input.txt" file in the same directory
	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);
	
	yyparse();

	printf("\n**********************************\n");
	printf("All the input parsing complete \n");
	printf("**********************************\n\n");

	printf("Number of array declarations : %d\n", arraynumber);
	printf("Number of if/else statements : %d\n", ifelsenumber); // FIXED
	printf("Number of while loops : %d\n", whilenumber);
	printf("Number of for loops : %d\n", fornumber);
	printf("Number of switch statements : %d\n", switchnumber); // FIXED
	printf("Number of classes : %d\n", classnumber);
	printf("Number of print function calls : %d\n", printnumber);
	printf("Number of try-catch blocks : %d\n", trycatchnumber);
	printf("Number of variable declarations : %d\n", variablenumber);
	printf("Number of variable assignments : %d\n", variableassignment);
	printf("Number of expressions : %d\n", expressionnumber);

	printf("\n**********************************\n");
	printf("Name : Faisal Ahmed\n");
	printf("Roll : 1607048\n");
	// ... rest of your info
	printf("**********************************\n");

	return 0;
}