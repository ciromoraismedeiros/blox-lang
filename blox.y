%{
#include <stdio.h>
#include "util.h"
#include "errormsg.h"

int yylex(void); /* function prototype */

void yyerror(char *s)
{
 EM_error(EM_tokPos, "%s", s);
}
%}

%union {
	int pos;
	int ival;
    double fval;
	string sval;
	}

%define parse.error verbose

%token AND ASSIGN BLOCK BREAK COLON COMMA CONTINUE

%token DIVIDE

%token DOT ELIF ELSE

%token EQ 

%token <fval> FLOAT
%token GE GT
%token <sval> ID
%token IF
%token <ival> INT
%token LBRACE LBRACK LE LOOP LPAREN LT

%token MINUS

%token NEQ
 
%token NIL

%token NOT OR PLUS

%token RBRACE RBRACK RETURN RPAREN SEMICOLON
%token <sval> STRING

%token TIMES
  
%start program

%%

program: block_body

block_body: block_defs_opt stmts

block_defs_opt: block_def block_defs_opt
    | %empty

colon_opt: COLON
    | %empty

decl: ID type decl_init_opt

type: ID

decl_opt: decl
    | %empty

decl_init_opt: decl_init
    | %empty

decl_init: ASSIGN exp

block_def: BLOCK ID formal_params_opt return_type_opt stmt_block_opt

stmt_block_opt : stmt_block
    | %empty

stmt_or_stmt_block_opt : stmt_or_stmt_block
    | %empty

return_type_opt: return_type
    | %empty

return_type: ID 

formal_params_opt: LPAREN formal_params RPAREN
    | %empty

formal_params: param more_formal_params

more_formal_params: COMMA formal_params
    | %empty

param: decl

stmt_or_stmt_block: stmt_block
    | stmt

stmt_block: LBRACK stmts RBRACK

stmts: stmt colon_opt stmts
    | %empty

stmt: func_call
    | assign
    | decl
    | if
    | loop
    | continue
    | break
    | return

return: RETURN exp

loop: LOOP decl_opt condition stmt_or_stmt_block
    | LOOP decl_opt stmt_or_stmt_block condition

continue: CONTINUE

break: BREAK

if: IF decl_opt condition stmt_or_stmt_block elif_opt

condition: LPAREN exp RPAREN

elif_opt: ELIF decl_opt condition stmt_or_stmt_block elif_opt
    | else_opt

else_opt: ELSE stmt_or_stmt_block
    | %empty

assign: ID ASSIGN exp

func_call: ID LPAREN actual_params RPAREN

actual_params: exps

exps: exp more_exps
    | %empty

more_exps: COMMA exps
    | %empty

exp: literal
    | ID
    | LPAREN exp RPAREN
    | exp binop exp
    | unop exp

binop: PLUS | MINUS | TIMES | DIVIDE | EQ | NEQ | GT | GE | LT | LE | AND | OR

unop: MINUS | NOT

literal: STRING
    | INT
    | FLOAT