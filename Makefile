PC = fpc
PCFLAGS = -Mobjfpc -Sh -FUobj -Fllib `pkg-config --libs-only-L libcrypto | sed s/-L/-Fl/`

AR = ar

CC = gcc
CFLAGS =

CXX = g++
CXXFLAGS =

CPPFLAGS = `pkg-config --cflags libcrypto`

.PHONY: all clean

all: bin/p2

bin/p2: src/*.pp lib/libargon2.a lib/libaltcha.a
	@mkdir -p obj bin
	$(PC) -o$@ $(PCFLAGS) src/p2.pp

include gen.mk

clean:
	rm -rf obj bin lib
