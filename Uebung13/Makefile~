CFLAGS?=-Wall -Werror -g -O3
LDFLAGS?=-lm

all: stringtester basevector

stringtester: stringtester.o strfun.o
basevector: basevector.o
#%.x: %.o
#	${CC} ${LDFLAGS} -o $@ $<

%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<
