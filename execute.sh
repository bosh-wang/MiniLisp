bison -d -o MiniLisp.tab.c MiniLisp.y
gcc -c -g -I.. MiniLisp.tab.c
flex -o lex.yy.c MiniLisp.l
gcc -c -g -I.. lex.yy.c
gcc -o MiniLisp y.tab.o lex.yy.o -ll
