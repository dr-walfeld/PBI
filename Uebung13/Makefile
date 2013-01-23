CFLAGS?=-Wall -Werror -g -O3

all: partition.x partition_new.x

%.x: %.o
	${CC} ${LDFLAGS} -o $@ $<

%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<
