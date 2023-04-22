# A simple program for Mini-Lisp interpreter

execute `execute.sh` to compile this file in linux system

or type command in terminal
```
bison -d -o MiniLisp.tab.c MiniLisp.y
gcc -c -g -I.. MiniLisp.tab.c
flex -o lex.yy.c MiniLisp.l
gcc -c -g -I.. lex.yy.c
gcc -o MiniLisp y.tab.o lex.yy.o -ll
```

# to execute the file
type these in terminal
```
./MiniLisp < {File you want to input}
```