%{
#include <string.h>
#include "util.h"
#include <stdlib.h>
#include "errormsg.h"
#include "absyn.h"
#include "y.tab.h"

int charPos=1;

int yywrap(void)
{
 charPos=1;
 return 1;
}

void adjust(void)
{
 EM_tokPos=charPos;
 charPos+=yyleng;
}

%}

ws                  [\t ]+
comment             #.*
ignore              ({ws}|{comment})
digit               [0-9]
number              {digit}+
real                {number}\.{number}
string              (("\'".*"\'")|("\"".*"\""))
alpha               [a-zA-Z]
id                  ({alpha}|_)({alpha}|{digit}|_)*
invalid_id          {digit}+({alpha}|_)+

%%
{ws}                {adjust(); continue;}
{comment}           {adjust(); continue;}
"\n"                {adjust(); EM_newline(); continue;}
"if"                {adjust(); return IF;}
"else"{ws}"if"      {adjust(); return ELSEIF;}
"else"              {adjust(); return ELSE;}
"block"             {adjust(); return BLOCK;}
"as"                {adjust(); return AS;}
"loop"              {adjust(); return LOOP;}
"not"               {adjust(); return NOT;}
"and"               {adjust(); return AND;}
"or"                {adjust(); return OR;}
"return"            {adjust(); return RETURN;}
"this"              {adjust(); return THIS;}
"goto"              {adjust(); return GOTO;}
"true"              {adjust(); return TRUE_TOK;}
"false"             {adjust(); return FALSE_TOK;}
"="                 {adjust(); return ASSIGN;}
"&"                 {adjust(); return ADDRESS;}
";"                 {adjust(); return COLON;}
","                 {adjust(); return COMMA;}
"+"                 {adjust(); return PLUS;}
"-"                 {adjust(); return MINUS;}
"*"                 {adjust(); return TIMES;}
"/"                 {adjust(); return DIVIDE;}
"=="                {adjust(); return EQ;}
"!="                {adjust(); return NEQ;}
">"                 {adjust(); return GT;}
"<"                 {adjust(); return LT;}
">="                {adjust(); return GE;}
"<="                {adjust(); return LE;}
"."                 {adjust(); return DOT;}
\{                  {adjust(); return LBRACK;}
\}                  {adjust(); return RBRACK;}
\[                  {adjust(); return LBRACE;}
\]                  {adjust(); return RBRACE;}
\(                  {adjust(); return LPAREN;}
\)                  {adjust(); return RPAREN;}
{number}            {adjust(); yylval.ival=atoi(yytext); return INT;}
{real}              {adjust(); yylval.fval=atof(yytext); return FLOAT;}
{string}            {adjust(); yylval.sval=String(yytext); return STRING;}
{id}                {adjust(); yylval.sval=String(yytext); return ID;}

