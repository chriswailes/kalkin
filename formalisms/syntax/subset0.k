############
# Comments #
############

# This is a line comment.
#* This is a block comment. *#

############
# Literals #
############

# Ints
42

# Floats
3.1415926
2.71828
1.234E-56

# Atoms
:foo
:bar_
:foo12

# Strings
"Hello world!"

#####################
# Basic expressions #
#####################

# Operator usage
1 + 2
my_array << 42

# Function calls
fib(6)

# Method calls
my_array.size()
my_array.append(42)

# Conditionals
if val % 2 then :odd else :even end

if val == 0
	:zero
else if val == 1
	:one
else
	:number
end

# Logical keywords
not bool_val0
bool_val0 or bool_val1
bool_val0 and bool_val1
bool_val0 nor bool_val1
bool_val0 xor bool_val1

# Sequencing
1 + 2
my_array << 42
fib(6)

# Return value is the result of the fib(6) call.
1 + 2; my_array << 42; fib(6)

#########
# Types #
#########

# Type names
Foo
Bar
CarClass

########################
# Variable definitions #
########################

# Declare a new Int variable 'x' that will be default initialized.
let x : Int

# Declare a new Int variable 'y' and give it a value.  Its type is inferred.
let y := 42

# Declare two default initialized strings called 'foo', and 'bar'.
let foo, bar : String

# Creates a new copy of SomeClass and default initializes another
# SomeClass.
let a := SomeClass(42, "hoopy"), b := SomeClass()
let a := SomeClass(42, "hoopy"), b : SomeClass

# Re-bind the name `a` to different memory location.
a := get_some_class()
a := SomeClass(100, "frood")

let a := SomeClass(200, "frood") # Warning: Attemping to re-introduce a name that is already in scope.

########################
# Function definitions #
########################

def fib(n : Int) -> Int
	if n <= 1 then 1 else fib(n - 1) + fib(n - 2) end
end

# Calls bar with a new instance of SomeClass.
bar(SomeClass())
