PC = fpc
PCFLAGS = -Mobjfpc -Sh -FUobj

AR = ar

CC = gcc
CFLAGS =

CXX = g++
CXXFLAGS =

CPPFLAGS = 

.PHONY: all clean

all: bin/p2

bin/p2: $(shell find src -name "*.pp") lib/libaltcha.a
	-mkdir -p obj bin
	$(PC) -o$@ $(PCFLAGS) src/p2.pp

include gen.mk

clean:
	rm -rf obj bin lib
