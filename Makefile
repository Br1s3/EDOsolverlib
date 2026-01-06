CC = gcc
RM = rm -rf

CFLAGS +=	\
-Wextra		\
-Wall   	\
-lm   		\

.PHONY: clean static dyn

static: main.c | libODEsolver.a
	gcc main.c -o main -L. -lODEsolver $(CFLAGS)

libODEsolver.a: ODEsolver.c
	$(CC) $(CFLAGS) -c ODEsolver.c
	ar -cvq libODEsolver.a ODEsolver.o
	@ar -t libODEsolver.a


# Pour lancer le main si pas "-Wl,-rpath=./"
# LD_LIBRARY_PATH="./" ./main

dyn: main.c | libODEsolver.so
	gcc main.c -o main $(CFLAGS) -L. -lODEsolver -Wl,-rpath=./


libODEsolver.so: ODEsolver.c
	$(CC) $(CFLAGS) -fPIC -shared -o libODEsolver.so ODEsolver.c

clean:
	$(RM) *.o
	$(RM) *.a
	$(RM) *.so
	$(RM) main
