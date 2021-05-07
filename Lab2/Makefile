CC=gcc
AS=as
LD=ld

CFLAGS=-std=c99
LFLAGS=-fPIC -no-pie

OUT=counter
OBJ=counter_c.o counter_S.o

all: counter

$(OUT): *.S *.c
	$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS)

submission: *.S *.c Makefile
	tar czf submission.tgz *.S *.c Makefile

clean:
		rm -f $(OBJ)
		rm -f $(OUT)
