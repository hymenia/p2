# Contributing to P2

There are several rules about the coding convention:
1. You MUST write `Name : Type` as `Name: Type`.
2. You MUST write continue, break, halt, and exit as Continue, Break, Halt, Exit.
3. You MUST do Exit(n) instead of assigning value to the function and Exit()ing.
4. You MUST assign default return value to the function in the first line. (See Init in P2.Config.pp)
4. You MUST put newline between statement and block.
5. You MUST put brackets after the function name, even if it does not take any arguments. This does not apply to compiler intrinsics excluding Exit.
6. You MUST concatenate string and character with + instead of `'string'#123`.
7. Units in `used` MUST be separated by newlines by each groups: (Object) Pascal native, Each groups of Free Pascal native units, and P2's own units.
8. You MUST access properties by `Self.Property` not `Property`.
