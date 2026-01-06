CC = gcc
RM = rm -rf

CFLAGS +=	\
-Wextra		\
-Wall   	\
-lm   		\

.PHONY: clean static dyn

static: main.c | libEDOsolver.a
	gcc main.c -o main -L. -lEDOsolver $(CFLAGS)

libEDOsolver.a: EDOsolver.c
	$(CC) $(CFLAGS) -c EDOsolver.c
	ar -cvq libEDOsolver.a EDOsolver.o
	@ar -t libEDOsolver.a


# Pour lancer le main si pas "-Wl,-rpath=./"
# LD_LIBRARY_PATH="./" ./main

dyn: main.c | libEDOsolver.so
	gcc main.c -o main $(CFLAGS) -L. -lEDOsolver -Wl,-rpath=./


libEDOsolver.so: EDOsolver.c
	$(CC) $(CFLAGS) -fPIC -shared -o libEDOsolver.so EDOsolver.c

clean:
	$(RM) *.o
	$(RM) *.a
	$(RM) *.so
	$(RM) main
