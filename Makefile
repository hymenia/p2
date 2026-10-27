PC = fpc
PCFLAGS = -Mobjfpc -Sh -FUobj

.PHONY: all clean

all: bin/p2

bin/p2: $(shell find src -name "*.pp")
	-mkdir -p obj bin
	$(PC) -o$@ $(PCFLAGS) src/p2.pp

clean:
	rm -rf obj bin
