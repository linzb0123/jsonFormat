基于Flex 和 Bison 写的一个json格式化工具

###### 使用 ：

安装 flex 和 bison 工具

```shell
sudo apt-get install flex
sudo apt-get install bison
```

编译

```shell
flex token.l && bison -d jsformat.y && gcc lex.yy.c jsformat.tab.c -o format
```

执行

``` shell
format <test.json> result.json
```



有一个缺点是要在json字符为末尾加上一个分号 “;” 来标志结束。



 

