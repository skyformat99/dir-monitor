CC := gcc

ifeq ($(release), y)
    CFLAGS := -O2 -Wall -Werror
else
    CFLAGS := -g -Wall -Werror
endif

INCLUDE :=
LIBS := -lpthread

SRC := $(wildcard *.c)
OBJS := $(patsubst %.c, %.o, $(SRC))
DEF := $(patsubst %.c, %.d, $(SRC))

TARGET := test-dir-monitor

.PHONY: all clean

all: $(TARGET)

test-dir-monitor: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS)

.c.o:
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

sinclude $(DEF)
%.d:%.c
	@set -e; rm -f $@; \
	    $(CC) -MM $(INCLUDE) $< > $@.$$$$; \
	    sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	    rm -f $@.$$$$

clean:
	rm -f $(OBJS) $(DEF) $(TARGET) *.d.*