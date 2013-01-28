# example makefile call: make -f mustermake <executable>
# or rename it to Makefile and just call: make <executable>
.PHONY: all

CFLAGS=-Wall -Werror -g

opt?=no

all: linkedlist_test.x

ifeq (${opt}, yes)
  CFLAGS+= -O3
endif

linkedlist_test.x: linkedlist_test.o linkedlist.o
	${CC} ${CFLAGS} -o $@ $^

%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<

clean:
	${RM} *.o

cleanup: clean
	${RM} *.x

test: all
	./linkedlist_test.x linkedlist.dat

# vim: ft=make
