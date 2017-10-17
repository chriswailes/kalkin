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

# Arrays
[|1, 2, 3, 4|]
[|:hello, :world|]

# Strings
"Hello world!"

# Tuples
(| 1, 2 |)
(| :hello, :world |)
(| 1, 2.0, :three, "four" |)

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

# Parametrized types

Array{String}
Vector{42, Float}
Tuple{Int, Int}

# Function Types

# Taking no argument and returning an Int
void -> Int

# Taking an Int and returning an Int
Int -> Int

# The `array map` function
(Int -> Int) -> Array{Int} -> Array{Int}

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

# This form of let returns the result of evaluating the expression with the
# new binding instead of the value of the new binding.
let a := SomeClass(300, "towel") in a.some_method

# After the above line `a` will have the reference it was bound to in the
# previous let expression.

########################
# Function definitions #
########################

def fib(n : Int) -> Int
	if n <= 1 then 1 else fib(n-1) + fib(n-2) end
end

# Parameter overloading

def add(a, b : Int) -> Int :~ a + b
def add(a, b, c : Int) -> Int :~ a + b + c

def add(a : Int, b : Float) :~ a + b

# Calls bar with a new instance of SomeClass.
bar(SomeClass())

###################
# Type conversion #
###################

let x := 42
float_fun(x.to Float) # This would normally get done automatically

# Converting inline.
array.map(lambda (x : Int) :~ x + 10).to(List).each ...

##############
# Namespaces #
##############

# Definition of a namespace
namespace Math
	def cos(x : Real) : Real
		...
	end
end

# Calling a member of the Math namespace
Math::cos(0.1234)

#*
 * Namespace Scoping
 *#

# Reference a name in a namespace
SomeNamespace::name
SomeNamespace::InnerNamespace

###########
# Classes #
###########

#*
 * Defining a class.  The object Point, in which the body of the class is
 * evaluated, is an instance of the class named Class.
 *
 * Classes are objects, and therefore have instance variables.  They also
 * define 'instantiated variables' that are present when instances of the class
 * are created.  Therefore a class's instance variables are the instantiated
 * variables of the class named Class.
 *#
class Point
	#*
	 * This defines the instantiated variables for the class Point.  Each
	 * instance of the Point class will have their own copy of these
	 * variables.  In the scope of an instance of the Point class the
	 * variables may be referenced using the $ sigil.
	 *#
	let-i x : Int
	let-i y : Int

	#*
	 * Instances methods where `self` points to an instance of Point.
	 *#

	# A default constructor
	constructor :~ $x = $y = 0

	# A constructor where arguments get assigned to the instance's variables $x
	# and $y.
	constructor ($x, $y) :~ void

	# A constructor with an initialization list.
	constructor with $x := 0, $y := 0 :~ void


	constructor with $x := 0, $y := 0 do
		# Other code goes here
	end

	constructor with
		$x := 0
		$y := 0

		# The normal ; sequencing operator can be used here.
	do
		# Other code goes here.
	end

	#*
	 * The return type of 'self' tells us that not only does this method
	 * return an object of type Point, it returns the object it was called on.
	 *#
	def-i move(x : Int, y : Int) : Point
		$x += x
		$y += y
	end

	# Assignment messages must always return self.
	def-i =(other : Point) : Point
		# Parallel assignment.
		$x, $y = other.x, other.y
	end

	# Definition of a (not very useful) postfix operator.
	def-i ! : Point :~ $x, $y = 0, 0

	# Definition of the prefix negation operator.
	def-i - self : Point
		Point(-$x, -$y)
	end

	# Definition of an infix operator.
	@assoc(:left) @prec(0)
	def-i + (ref other : Point) :~ Point($x + other.x, $y + other.y)

	@assoc(:right) @prec(1)
	def-i * (scale : Int) :~ Point($x * scale, $y * scale)

	#*
	* Functions in the Point namespace.  The self variable is not in scope for
	* these functions.
	*#

	def origin : Point
		Point(0, 0)
	end
end

# Calling a member of the Point namespace
Point::origin()

class ExampleClass
	let-i a0, a1 : Array{Int}

	def-i ExampleClass($a0, $a1) :~ void

	# Defining the two special case operators.
	def-i ()(x, y : Int) : Int :~ $a0[x] + $a1[y]

	def-i [](x, y : Int) : (Int, Int) :~ ($a0[x], $a1[y])
end

let example := ExampleClass([1, 2, 3], [4, 5, 6])

example(0, 0) # Evaluates to 5
example[1, 2] # Evaluates to (2, 6)

#######################
# Polymorphic Objects #
#######################

#*
 * Syntax
 *#

# Full form
poly
	# Complex params
class Foo
	...
end

# Shorthand
poly #* Simple Params *#
def fun(args : Type)
...
end

## Type Parameters

poly A, B : Type
def fun(a : A, b : B) :~ void

poly
	A : Type
	B : Type
class Foo
	let-i a : A
	let-i b : B

	constructor ($a, $b)
end

fun("hello", 42)
fun{String, Int}("hello", 42)

let f := Foo("hello", 42)
let f := Foo{String, Int}("hello", 42)

# Access type parameters
f.class::A

poly A, bType : Type
class Bar
	def-i a : A
	def-i b : bType
end

# If we use a "variable" name we can't access it outside the class later.
let b := Bar("hello", 42)
b.class::bType # FAILS!

#*
 * Functions
 *#

poly T : Type
def id(obj : T) -> T :~ obj

#*
 * Classes
 *#

poly T : Type
class Wrapper
	let-i el : T

###############
# Annotations #
###############

@O(arr.size)
poly DataType : Type
def my_algorithm(arr : Array{DataType}) -> DataType
	...
end

class Point
	@reader
	let-i x, y : Int
end
