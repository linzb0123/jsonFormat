%{
#include "common.h"
#include "jsformat.tab.h"

%}


%%

"{"   return LBRACE;
"}"   return RBRACE;
"["  return LBRACKET;
"]"  return RBRACKET; 
":"  return COLON; 
"," return COMMA;
";" return STOP;
("null")|("NULL")  {yylval.str=strdup(yytext); return NULLTOKEN;}
("true")|("false")|("TRUE")|("FALSE")  {yylval.str=strdup(yytext); return BOOLTOKEN;}
(-?[0-9]+)(\.[0-9]+)?  {yylval.num=atoi(yytext); return NUM;} 
\"(\\\"|[^\"])*\" {yylval.str=strdup(yytext); return STR;} 
[ ] {}
[\n] {}
[\r] {}
[\t] {}

%%
