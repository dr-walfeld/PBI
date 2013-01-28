CFLAGS?=-Wall -Werror -g -O3

all: partition.x

%.x: %.o
	${CC} ${LDFLAGS} -o $@ $<

%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<
