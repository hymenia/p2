#!/bin/sh
(
	gen() {
		for i in "$@"; do
			if [ "$i" = "$1" -o "$i" = "$2" -o "$i" = "$3" ]; then
				continue
			fi	

			O="obj/$2/`echo $i | rev | cut -d/ -f1 | rev | cut -d. -f1`.o"
			echo "$1_OBJS += $O"
			echo "$O: $i"
			echo "	@mkdir -p obj/$2"
			if ( echo "$i" | grep '.c$' >/dev/null ); then
				echo "	\$(CC) \$(CFLAGS) \$(CPPFLAGS) $3 -c -o \$@ $i"
			else
				echo "	\$(CXX) \$(CXXFLAGS) \$(CPPFLAGS) $3 -c -o \$@ $i"
			fi
			echo
		done

		echo "lib/lib$2.a: \$($1_OBJS) $4"
		echo "	@mkdir -p lib"
		echo "	\$(AR) rcs \$@ \$($1_OBJS)"
		echo
	}

	gen ARGON2 argon2 "-Iext/argon2/include" ext/argon2/src/*.c ext/argon2/src/blake2/*.c
	gen ALTCHA altcha "-Iext/argon2/include -Iext/altcha/third_party" ext/altcha/src/*.cpp
	gen P2 p2 "-Iext/altcha/include" src/cxx/*.cc
) > gen.mk
