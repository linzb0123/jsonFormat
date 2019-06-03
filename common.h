#ifndef _COMMON_H_
#define _COMMON_H_
#include <stdio.h>
#include <stdlib.h>

typedef enum {NumType,StrType,BoolType,ObjType,ArrType,NullType} ValType;
typedef  struct jsonTreeNode{
    char *key; /* NULL 代表没有key */
    ValType type; /* 类型 */
    union{
        int val;    /*数字*/
        char *str;  /* 字符串或布尔 */
        struct jsonTreeNode * ptr;  /* 子结点 */ 
    };
    struct jsonTreeNode * next ; /*兄弟结点，下一个结点*/
} JsonTreeNode,*PNode;

#endif