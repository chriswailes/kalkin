# This is a line comment.
#* This is a block comment. *#

#~ This is a temporary comment.  Kalkin will refuse to merge code that has
#~ these into a project's master.

# These are function definitions.
def fib(1) -> 1
def fib(2) -> 1
def fib(n : Integer) : Integer -> fib(n - 1) + fib(n - 2)

#*
 * This function takes four arguments: three integers and a float.  The
 * parameter `a` must always be provided; default values are specified for the
 * other parameters.
 *#
def math_function(a, b := 2, c := 3 : Integer, d := 4.0 : Float) : Float
	a + b + c + d
end

# Once you start using keyword arguments, you can't switch back.
math_function(1, c: 42, d: 100) # Valid

#*
 * Invalid:
 * math_function(1, c: 42, 100)
 *#

def foo : void
	# Captures references to two integers returned from functions.
	let x := get_int(), y := get_int() : Integer

	# Creates a new copy of an integer and default initializes a new integer.
	let a := SomeClass(42), b := SomeClass()
	let a := SomeClass(42), b : SomeClass

	# Re-bind the name `a` to different values.
	a := get_some_class()
	a := SomeClass(100)

	# You can also do this to be explicit
	let a := SomeClass(200)

	# This form of let returns the result of evaluating the expression with the
	# new binding instead of the value of the new binding.
	let a := SomeClass(300) in a.some_method

	# After the above line `a` will have the reference it was bound to on line
	# 42.
end

# Takes x and y by reference and b and c by value.
def bar(x, y : Integer, copy b, copy c : Float) : Integer
	# Does something
end

# Takes x and b by reference and y and c by value.
def baf(x, copy y : Integer, b, copy c : Float) : Integer
	# Does something
end

# Takes an instance of SomeClass by reference.
def bar(x : SomeClass) : void
	...
end

# Default values for non-trivial types
def bar(x := SomeClass()) : Integer -> 42

def baz(a : SomeClass, b := SomeClass()) : Integer -> 42
def baz(a, b := SomeClass() : SomeClass) : Integer -> 42

# I don't really like this form.  It might be disallowed.
def baz(a, b := SomeClass()) : Integer -> 42

# Calls bar with a new instance of SomeClass.
bar(SomeClass())

# Definition of a namespace
namespace Math
	def cos(x : Real) : Real
		...
	end
end

# Calling a member of the Math namespace
Math::cos(0.1234)

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
	@accessor
	let-i x : Integer
	@accessor
	let-i y : Integer

	#*
	 * Instances methods where `self` points to an instance of Point.
	 *#

	# Arguments get assigned to the instance's variables $x and $y.
	def-i Point($x, $y) -> void

	#*
	 * The return type of 'self' tells us that not only does this method
	 * return an object of type Point, it returns the object it was called on.
	 *#
	def-i move(x : Integer, y : Integer) : self
		$x += x
		$y += y
	end

	# Assignment messages must always return self.
	def-i =(other : Point) : self
		$x, $y = other.x, other.y
	end

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

# This is an example of some subclassing relationships.
class Animal
end

class Dog : Animal
end

class Cat : Animal
end

#*
 * Because classes are objects themselves they too can have state.  In practice
 * it is best to avoid this as it causes a bottle neck for instantiation, but
 * sometimes you just need to (factories).
 *#
class CountingClass
	#*
	 * Defines an instance variable for the CountingClass.  This is an
	 * instantiated variable of an anonymous subclass of the class named
	 * Class; CountingClass is an instance of that anonymous subclass.
	 *#
	let-c count : Integer

	# Overload the new message.
	def-c new : CountingClass
		$count++
		CountingClass.allocate
	end

	# Returns the number of instantiations of this class.
	def-c count : Integer
		$count
	end
end

# Sending a message to the object CountingClass.
CountingClass.count

#*
 * This factors out the counting behavior above and then creates a new class
 * that uses the counting behavior.
 *#

class CountingClass : Class
	# Define the counter.
	let-i count : Integer

	# Overload the new message.
	def-i new : CountingClass
		$count++
		CountingClass.allocate
	end

	# Returns the number of instantiations of this class.
	def-i count : Integer
		$count
	end
end

class[CountingClass] CountedAnimals
	#*
	 * Define the body of the CountedAnimals class.
	 *#
	def-c count_as_string : String
		# Borrowing Ruby's string interpolation syntax for now.
		"There are #{$count} animals."
	end
end


# Local type inference
let value := get_int()

#*
 * Lambdas
 *
 * The return type can be omitted in the case of the first two forms.
 *#
lambda (args):RetType expression
λ (args):RetType expression

lambda (args):RetType
	# code
end

λ (args):RetType
	# code
end

# Other valid lambdas
λ (a : Integer) a + 42
λ 42

#*
 * Literals
 *#

# Atoms
:foo
:bar_
:?

# Integers
42
100
100,000

# Floats
3.1415926
2.71828

# Regular Expressions
/ab*/

# Tuples
(1, 2)
(:hello, :world)
(1, 2.0, :three, "four")

let one, two := (1, 2)

# Arrays
[1, 2, 3, 4]
[:hello, :world]

# Hashes
{ :one => 1, :two => 2, :three => 3 }

# Binaries
<|1, 17, 42|>
<|"abc"|>

let a, b, c := <|1, 17, 42|>

let binary := <|a, b, c|>

# Tuple and Array Deconstruction
let a, b = (1, 2)
let a, b = (1, 2, 3) # a == 1, b == (2, 3)

let a, b = [1, 2]
let a, b = [1, 2, 3] # a == 1, b == [2, 3]

# Pattern Matching
match object with
	42                          -> :a
	3.14                        -> :b
	:c                          -> :c
	Point(0, a)
	Point(a, 0)                 -> :d
	Point(a, b) where a == b
	Point(a, a)                 -> :e
	Point as p                  -> :f
	[x, xs] where xs.length > 0 -> :g
	<|42:8, x:4, y:4|>          -> :h
	_                           -> :z
end
