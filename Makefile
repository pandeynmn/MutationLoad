CC = gcc
INCLUDES = -I/home/npandey/gsl/include -I/home/npandey/tskit/c -I/home/npandey/tskit/c/subprojects/kastore/

LFLAGS = -L/home/npandey/gsl/lib # needed for fusion.
CFLAGS = $(INCLUDES) -O3 -frounding-math

mutationload: main.o dependencies/pcg_basic.o sharedfunc_flag.o relative_functions.o absolute_functions.o /home/npandey/tskit/c/tskit/tables.o /home/npandey/tskit/c/subprojects/kastore/kastore.o /home/npandey/tskit/c/tskit/core.o
	$(CC) $(LFLAGS) -O3 -frounding-math dependencies/pcg_basic.o main.o sharedfunc_flag.o relative_functions.o absolute_functions.o tables.o kastore.o core.o -lm -lgsl -lgslcblas -o mutationload

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

dependencies/pcg_basic.o: dependencies/pcg_basic.c
	$(CC) $(CFLAGS) -c dependencies/pcg_basic.c

sharedfunc_flag.o: sharedfunc_flag.c
	$(CC) $(CFLAGS) -c sharedfunc_flag.c

relative_functions.o: relative_functions.c
	$(CC) $(CFLAGS) -c relative_functions.c

absolute_functions.o: absolute_functions.c
	$(CC) $(CFLAGS) -c absolute_functions.c

/home/npandey/tskit/c/tskit/tables.o: /home/npandey/tskit/c/tskit/tables.c
	$(CC) $(CFLAGS) -c -std=c99 /home/npandey/tskit/c/tskit/tables.c

/home/npandey/tskit/c/subprojects/kastore/kastore.o: /home/npandey/tskit/c/subprojects/kastore/kastore.c
	$(CC) $(CFLAGS) -c -std=c99 /home/npandey/tskit/c/subprojects/kastore/kastore.c

/home/npandey/tskit/c/tskit/core.o: /home/npandey/tskit/c/tskit/core.c
	$(CC) $(CFLAGS) -c -std=c99 /home/npandey/tskit/c/tskit/core.c
clean:
	rm ./mutationload -f
	rm *.o -f

