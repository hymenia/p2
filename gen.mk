ARGON2_OBJS += obj/argon2/argon2.o
obj/argon2/argon2.o: ext/argon2/src/argon2.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/argon2.c

ARGON2_OBJS += obj/argon2/bench.o
obj/argon2/bench.o: ext/argon2/src/bench.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/bench.c

ARGON2_OBJS += obj/argon2/core.o
obj/argon2/core.o: ext/argon2/src/core.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/core.c

ARGON2_OBJS += obj/argon2/encoding.o
obj/argon2/encoding.o: ext/argon2/src/encoding.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/encoding.c

ARGON2_OBJS += obj/argon2/genkat.o
obj/argon2/genkat.o: ext/argon2/src/genkat.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/genkat.c

ARGON2_OBJS += obj/argon2/opt.o
obj/argon2/opt.o: ext/argon2/src/opt.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/opt.c

ARGON2_OBJS += obj/argon2/ref.o
obj/argon2/ref.o: ext/argon2/src/ref.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/ref.c

ARGON2_OBJS += obj/argon2/run.o
obj/argon2/run.o: ext/argon2/src/run.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/run.c

ARGON2_OBJS += obj/argon2/test.o
obj/argon2/test.o: ext/argon2/src/test.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/test.c

ARGON2_OBJS += obj/argon2/thread.o
obj/argon2/thread.o: ext/argon2/src/thread.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/thread.c

ARGON2_OBJS += obj/argon2/blake2b.o
obj/argon2/blake2b.o: ext/argon2/src/blake2/blake2b.c
	@mkdir -p obj/argon2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/argon2/include -c -o $@ ext/argon2/src/blake2/blake2b.c

lib/libargon2.a: $(ARGON2_OBJS) ext/argon2/src/argon2.c
	@mkdir -p lib
	$(AR) rcs $@ $(ARGON2_OBJS)

ALTCHA_OBJS += obj/altcha/algorithms.o
obj/altcha/algorithms.o: ext/altcha/src/algorithms.cpp
	@mkdir -p obj/altcha
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Iext/argon2/include -Iext/altcha/third_party -c -o $@ ext/altcha/src/algorithms.cpp

ALTCHA_OBJS += obj/altcha/altcha.o
obj/altcha/altcha.o: ext/altcha/src/altcha.cpp
	@mkdir -p obj/altcha
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Iext/argon2/include -Iext/altcha/third_party -c -o $@ ext/altcha/src/altcha.cpp

ALTCHA_OBJS += obj/altcha/helpers.o
obj/altcha/helpers.o: ext/altcha/src/helpers.cpp
	@mkdir -p obj/altcha
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Iext/argon2/include -Iext/altcha/third_party -c -o $@ ext/altcha/src/helpers.cpp

ALTCHA_OBJS += obj/altcha/json_utils.o
obj/altcha/json_utils.o: ext/altcha/src/json_utils.cpp
	@mkdir -p obj/altcha
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Iext/argon2/include -Iext/altcha/third_party -c -o $@ ext/altcha/src/json_utils.cpp

lib/libaltcha.a: $(ALTCHA_OBJS) ext/altcha/src/algorithms.cpp
	@mkdir -p lib
	$(AR) rcs $@ $(ALTCHA_OBJS)

P2_OBJS += obj/p2/altcha.o
obj/p2/altcha.o: src/cxx/altcha.cc
	@mkdir -p obj/p2
	$(CC) $(CFLAGS) $(CPPFLAGS) -Iext/altcha/include -c -o $@ src/cxx/altcha.cc

lib/libp2.a: $(P2_OBJS) src/cxx/altcha.cc
	@mkdir -p lib
	$(AR) rcs $@ $(P2_OBJS)

