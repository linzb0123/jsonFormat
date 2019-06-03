%{
#include "common.h"
//缩进2个空格
#define STEPSIZE  2  

//生成树结点
JsonTreeNode * newTreeNode(ValType type)
{ JsonTreeNode * node = (JsonTreeNode *) malloc(sizeof(JsonTreeNode));
  if (node==NULL){
    printf("Out of memory error\n");
    exit(1);
  }
  else {
      node->key = NULL;/*NULL 代表没有key */
      node-> type= type;
      node->next=NULL; /*NULL 代表没有兄弟结点了 结束当前递归 */
  }
  return node;
}
//设置缩进
void setSpace(int step){
    for(int i=0;i<step;i++){
        printf(" ");
    }
}
//json本质就是一个对象，按一定格式递归输出树
void printObjTree( JsonTreeNode * tree,int step)
{ int i;
  while(tree!=NULL){
      setSpace(step);
      if(tree->key!=NULL){
        printf("%s:",tree->key);
      } 
      switch(tree->type){
        case ObjType:
            printf("{\n");
            //递归输出
            printObjTree(tree->ptr,step+STEPSIZE);
            setSpace(step);
            printf("}");
            break;
        case ArrType:
            printf("[\n");
            //递归输出
            printObjTree(tree->ptr,step+STEPSIZE);
            setSpace(step);
            printf("]");
            break;
        case NumType:
            printf("%d",tree->val);
            break;
        case StrType:
            printf("%s",tree->str);
            break;
        case BoolType:
        case NullType:
            printf("%s",tree->str);
            break;
      }
      tree = tree->next;
      if(tree!=NULL) printf(",\n");
      else printf("\n");
  }

}


%}
%union {
    int num;      
    char *str;
    JsonTreeNode  *pnode;
}
%token LBRACE RBRACE LBRACKET RBRACKET COLON STOP COMMA 
%token <num> NUM
%token <str> STR
%token <str> BOOLTOKEN
%token <str> NULLTOKEN
%type <str> KEY 
%type <pnode> VAL
%type <pnode> ITEM
%type <pnode> ITEMS
%type <pnode> ARRAY
%type <pnode> VALUE
%type <pnode> FIELD
%type <pnode> FIELDS
%type <pnode> OBJ


%% 
start : OBJ STOP {printObjTree($1,0); exit(1);/*以在末尾加个分号来结束*/} 
;
OBJ: LBRACE FIELDS RBRACE {  //对象{ k:v[,k2:v2....] }
        PNode pNode = newTreeNode(ObjType);
        pNode->ptr = $2;
        $$=pNode;
    };
FIELDS: FIELD{  
        $$ = $1;
    } 
    | FIELDS COMMA FIELD {  //可能由多个键值对组成
        PNode p = $1;
        //最左归约，后来的追加到末尾
        while(p->next!=NULL) p = p->next; 
        p->next = $3;
        $$ = $1;
    };
FIELD: KEY VALUE{
        // 键值对 key : value 下面 判断key已经判断 : 了
        $$ = $2;
        $$->key = $1;
    };
VALUE:OBJ{ //value的取值
        $$ = $1;
    }
     | ARRAY {
         $$ = $1;
     }
     | VAL {
         $$ = $1;
      };
ARRAY: LBRACKET ITEMS RBRACKET {
        //生成数组类型 [ item1 [,item2....] ] 项可能为字符串 数字 布尔 对象 数组(多维数组)
        PNode pNode = newTreeNode(ArrType);
        pNode->ptr = $2;
        $$ = pNode;
    };
ITEMS: ITEM{
         $$=$1;
    } 
    | ITEMS COMMA ITEM {
        PNode p = $1;
         //最左归约，后来的追加到末尾
        while(p->next!=NULL) p = p->next; 
        p->next = $3;
        $$ = $1;
    };
ITEM:OBJ{
        $$=$1;
    } 
    | VAL {
        $$=$1;
    }
    |ARRAY{
        $$=$1;
    }
KEY: STR COLON {
        //都是字符串str ，为避免冲突，采用 key : 判断
        //key 类型 key :
        $$=$1;
    };
VAL: STR { 
        //字符串str
        PNode pNode = newTreeNode(StrType);
        pNode->str = $1;
        $$ = pNode;
    } 
    | NUM{ 
        //数字类型 
        PNode pNode = newTreeNode(NumType);
        pNode->val = $1;
        $$ = pNode;
    } 
    | BOOLTOKEN{
        //布尔类型 true false 
        PNode pNode = newTreeNode(BoolType);
        pNode->str = $1;
        $$ = pNode;
    }
    | NULLTOKEN{
         //null
        PNode pNode = newTreeNode(NullType);
        pNode->str = $1;
        $$ = pNode;
    }
;
%%

main(){
    return(yyparse());          /* Start the parser */
}
 
yyerror(s)
char *s; {
    printf("yacc error: %s\n", s);
}
 
yywrap(){
    return(0);
}

