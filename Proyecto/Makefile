a.out: CGrammar.tab.o main.o lex.yy.o 	
	gcc main.o lex.yy.o CGrammar.tab.o 

main.o: main.c
	gcc -c main.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

CGrammar.tab.o: CGrammar.tab.c
	gcc -c CGrammar.tab.c

lex.yy.c: CGrammar.l
	flex CGrammar.l

CGrammar.tab.c: CGrammar.y
	bison -d CGrammar.y

clean:
	rm -f a.out main.o lex.yy.o CGrammar.tab.o lex.yy.c CGrammar.tab.c CGrammar.tab.h

run:a.out
	./a.out