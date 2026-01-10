CC = gcc
MD = mkdir -p
RM = rm -rf

CFLAGS +=	\
-Wextra		\
-Wall   	\
-lm   		\

SAVE_FILE := results

COMPMODE ?= P1


.PHONY: header obj static dynamic clean


header: main | $(SAVE_FILE)

obj: main | libODEsolver.o $(SAVE_FILE)

dynamic: main | libODEsolver.so $(SAVE_FILE)

static: main | libODEsolver.a $(SAVE_FILE)


# test: libODEsolver.h ODEsolver.h | ODEsolver.c
# 	@echo [$@], [$^], [$<], [$?]


libODEsolver.o: libODEsolver.h
	$(CC) -DLIBIMAGEFILE_IMPLEMENTATION -x c -c $<

libODEsolver.so: ODEsolver.c
	$(CC) $(CFLAGS) -DPROG3 -fPIC -shared -o $@ $<


libODEsolver.a: ODEsolver.o
	ar -cvq $@ $<
	@ar -t $@

ODEsolver.o: ODEsolver.c
	$(CC) $(CFLAGS) -c $<

main: main.c
ifeq ($(COMPMODE), P1)
	@echo Simple compilation of programs
	$(CC) $< -o $@ -DPROG1 $(CFLAGS)
else ifeq ($(COMPMODE), P2)
	@echo Compile with obj lib
	$(CC) $< libODEsolver.o -o $@ -DPROG2 $(CFLAGS)
else ifeq ($(COMPMODE), PD)
	@echo Compile the dynamique library
	$(CC) $< -o $@ -DPROG3 $(CFLAGS) -L. -libODEsolver -Wl,-rpath=./
else ifeq ($(COMPMODE), PS)
	@echo Compile the static library
	$(CC) $< -o $@ -L. -lODEsolver -DPROG4 $(CFLAGS)
else
	@echo ERROR
endif


$(SAVE_FILE):
	$(MD) $(SAVE_FILE)

clean:
	$(RM) *.o
	$(RM) *.a
	$(RM) *.so
	$(RM) results
	$(RM) main
