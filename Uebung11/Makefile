CFLAGS?=-Wall -Werror -g -O3

all: bitvector.x quersumme.x stack.x

%.x: %.o
	${CC} ${LDFLAGS} -o $@ $<

%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<
