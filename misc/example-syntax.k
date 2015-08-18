#* Features
 *
 * - Comments ✓
 * - Literals ✓
 *   - Full binary syntax
 * - Basic expressions ✓
 * - Types ✓
 *   - Type names ✓
 *   - Tuple types ✓
 *   - Function types ✓
 *   - Parametrized types ✓
 * - Function definition ✓
 *   - Default values ✓
 *   - Keyword arguments ~✓
 *   - Splat parameters/arguments
 * - Namespaces ✓
 * - Classes ✓
 *   - Constructors
 *   - Destructors
 *   - Destructuring
 *   - Operator deffinition
 *     - Prefix
 *     - Infix
 *     - Postfix
 *     - Special cases
 *     - Precedence
 *     - Associativity
 *   - Method + operator definitions
 * - Interfaces ✓
 * - Mixins ✓
 * - Reopening ✓
 * - Generics Functions ✓
 *   - Default parameters
 *   - Specialization
 * - Parametrized types ✓
 *   - Type parameters ✓
 *   - Non-type parameters
 *   - Default parameters
 *   - Specialization
 * - Lambdas ✓
 * - Block syntax ✓
 * - Aliasing ✓
 * - Currying ✓
 * - Exceptions
 * - Local type inference ✓
 * - Destructuring
 * - Pattern matching
 * - String interpolation ✓
 * - Macros
 * - Annotations ✓
 * - Implementation selectors ✓
 * - Semantic versioning
 * - Debugging expressions
 * - Documentation
 *
 * NOTE: ... is most often used here to indicate elided code.  The only
 *       exception is for integer range literals.
 *#

############
# Comments #
############

# This is a line comment.
#* This is a block comment. *#

#~ This is a temporary comment.  Kalkin will refuse to merge code into a
#~ project's master branch if it has these.

############
# Literals #
############

# Arrays
[1, 2, 3, 4]
[:hello, :world]

# Atoms
:foo
:bar_

# Binaries
<|1, 17, 42|>
<|"abc"|>

# Hashes
{ :one => 1, :two => 2, :three => 3 }

# Integers
42
100
100,000
1E10

# Floats
3.1415926
2.71828
1.234E-56

# Regular Expressions
/ab*/

# Strings
"Hello world!"

# Tuples
(1, 2)
(:hello, :world)
(1, 2.0, :three, "four")

# Integer ranges
0..5  # 0, 1, 2, 3, 4
0...5 # 0, 1, 2, 3, 4, 5

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
my_array.size
my_array.append(42)

# Conditionals
if val % 2 then :odd else :even end
val % 2 ? :odd : :even

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
1 + 2; my_array << 42; fib(6)

#########
# Types #
#########

# Type names
Foo
Bar
CarClass

# Tuple types

# Single element tuples are not allowed.  This simply evaluates to the
# expression `42`: (42)

def foo : (Integer, Integer) ->> (7, 8)

# Function Types

def returnsConstant42 ->> λ 42
def returnsConstant42 : -> Integer ->> λ 42

def returnsAddOne : Integer -> Integer ->> λ (n) n + 1

def returnsMap : (Integer -> Integer) -> Array -> Array
	...
end

# Parametrized types

Array{String}
Vector{42, Float}

########################
# Function definitions #
########################

# These are function definitions.  Return types can be infered if the body is a
# literal.
def fib(1) ->> 1
def fib(2) ->> 1
def fib(n : Integer) : Integer ->> fib(n - 1) + fib(n - 2)

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
	let x := get_int(), y := get_int() # Type inference.
	let x := get_int(), y := get_int() : Integer

	# Creates a new copy of SomeClass and default initializes another
	# SomeClass.
	let a := SomeClass(42), b := SomeClass()
	let a := SomeClass(42), b : SomeClass

	# Re-bind the name `a` to different memory location.
	a := get_some_class()
	a := SomeClass(100)

	# You can also do this to be explicit
	let a := SomeClass(200)

	# This form of let returns the result of evaluating the expression with the
	# new binding instead of the value of the new binding.
	let a := SomeClass(300) in a.some_method

	# After the above line `a` will have the reference it was bound to in the
	# previous let expression.
end

# Takes x by value and y by reference.
def bar(x, ref y : Integer) : Integer
	# Does something
end

# Default values for non-trivial types
def bar(x := SomeClass(1, 2, 3)) : Integer -> 42

def baz(a : SomeClass, b := SomeClass(1, 2, 3)) : Integer ->> 42
def baz(a, b := SomeClass(1, 2, 3) : SomeClass) : Integer ->> 42

# Calls bar with a new instance of SomeClass.
bar(SomeClass())

# Splat parameters
def avg(*nums : Integer) : Integer ->> ...
def avg(nums* : Integer) : Integer ->> ...

def avg(*ref nums : Integer) : Integer ->> ...
def avg(ref *nums : Integer) : Integer ->> ...
def avg(ref nums* : Integer) : Integer ->> ...

# Splat arguments
let args := (1, :two, "three") : (Integer, Atom, String)
def helper(a : Integer, b : Atom, c : String) : void ->> ...

helper(*args)

def min(a, b : Integer) : Integer ->> if a <= b then a else b end

# This is fine because the size of the array is known statically
min(*[12, 5])

# This will result in a dynamic check and could produce an exception
min(*get_array())

# Mixed splat usage

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
	let-i x : Integer
	let-i y : Integer

	#*
	 * Instances methods where `self` points to an instance of Point.
	 *#

	# Arguments get assigned to the instance's variables $x and $y.
	def-i Point($x, $y) ->> void

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
		# Parallel assignment.
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

##############
# Interfaces #
##############

#*
 * Interfaces may not specify implementations of methods.  If you wish to
 * provide partial implementations you can declare a mixin and then use it as
 * an interface.
 *#

interface Monoid {ImplementingClass}
	require-i ImplementingClass : -> ImplementingClass
	require-i successor : -> ImplementingClass
end

interface Container {ImplementingClass{ElementType}}
	# ImplementingClass must also implement the Iterable interface.
	require Iterable
	
	require-i [] : Integer -> ElementType
	require-i size : -> Integer
end

##########
# Mixins #
##########

mixin Mappable {ImplementingClass{ElementType}}
	# ImplementingClass must implement the Appendable and Iterable interface.
	require Appendable, Iterable
	
	require-i helper_fun : Integer -> Integer
	
	def-i map(fun :? ElementType -> NewElementType) -> ImplementingClass{NewElementType}
		let new_container : ImplementingClass
		
		self.each do (el)
			new_container << fun(el)
		end
		
		return new_container
	end
	
	# Alternative map declaration:
	def-i map{NewElementType}(fun : ElementType -> NewElementType) -> ImplementingClass{NewElementType} ->> void
end

###############################
# Using Interfaces and Mixins #
###############################

class Foo
	implements Monoid{successor/increment}
	
	def increment : self.class
		...
	end
end

class Bar
	implements Appendable, Iterable
	include Mappable{helper/my_helper}{map/other_name}
	
	def-i my_helper(a : Integer) : Integr ->> a
end

#############
# Reopening #
#############

namespace Outer
	class Foo
		def bar(x : Integer) : Integer ->> x
	end

	namespace Inner
		reopen Foo
			def bar(x : Integer) : Integer ->> x + 100
		end
		
		Foo().bar(42) # Evaluates to 142
	end
	
	Foo().bar(42) # Evaluates to 42
end

#####################
# Generic Functions #
#####################

def min{T}(v0, v1 : T |: Comparable) : T ->> if v0 < v1 then v0 else v1 end
def fold{ContainerType{ElementType}}(fun : ElementType -> ElementType, container : ContainerType) : ContainerType
	...
end

# Query types
def min(v0, v1 :? T |: Comparable) : T ->> if v0 < v1 then v0 else v1 end
def fold(fun :? ElementType -> ElementType, container :? ContainerType{ElementType}) : ContainerType
	...
end

# These three declarations are all equivalent:
def log{LogType}(ref message : String, ref log : LogType |: Stream) ->> void
def log(ref message : String, ref log :? LogType |: Stream) ->> void
def log(ref message : String, ref log |: Stream) ->> void

######################
# Parametrized Types #
######################

class Maybe {ValType}
	let-i isSet : Boolean
	let-i val : ValType
	
	def-i Maybe ->> isSet = False
	def-i Maybe($val) ->> isSet = True
	
	def-i isSet : Boolean ->> $isSet
	def-i val : ValType ->> $val
end

Maybe{Integer}(42)

# Multiple type arguments
class Graph {NodeType, EdgeType}
	let-i nodes : Array{NodeType}
	let-i edges : Array{EdgeType}
end

# Subclass requirement
class Zoo {AnimalType <: Animal}
	let-i animals : Array{AnimalType}
end

# Interface requirement
class IntegerStore {ContainerType |: Container}
	let-i storage : ContainerType{Integer}
end

# Multiple interface requirements
class LoggingClass {StreamType |: Writable, Seekable}
	let-i stream : StreamType
end

###########
# Lambdas #
###########

# The return type is optional for these two forms.
lambda (args) : RetType expression
λ (args) : RetType expression

lambda (args) : RetType
	# code
end

λ (args) : RetType
	# code
end

# Other valid lambdas
λ (a : Integer) a + 42
λ 42

################
# Block syntax #
################

class Array{ElType}
	...
	
	def-i each(block :? ElType -> _) : self
		...
	end
end

[1, 2, 3, 4].each do (el : Integer) : void
	log_number(el)
end

############
# Aliasing #
############

def a_long_descriptive_function_name ->> void
alias a_long_descriptive_function_name short_name

############
# Currying #
############

def foo(a, b, c : Integer) : Integer ->> 42

let my_foo := `foo(1, 2) : Integer -> Integer

def bar (a, b : Integer) : Integer ->> 100
def bar (a : Integer) : Integer ->> 200

let my_bar := `bar(1) : -> Integer

#############
# Exception #
#############

########################
# Local type inference #
########################

let value := get_int()

[1, 2, 3, 4].each do (x) x + 1

#################
# Destructuring #
#################

let a, b = (1, 2)
let a, b = (1, 2, 3) # a == 1, b == (2, 3)

let a, b = [1, 2]
let a, b = [1, 2, 3] # a == 1, b == [2, 3]

let a, b, c := <|1, 17, 42|>

let binary := <|a, b, c|>

####################
# Pattern matching #
####################

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

########################
# String interpolation #
########################

def great(p : Person) : String
	"Hello #{p.name}!"
end

##########
# Macros #
##########

###############
# Annotations #
###############

@O(arr.size)
def my_algorithm(arr :? Array{DataType}) : Integer
	...
end

class Maybe {ValType}
	@reader
	let-i isSet : Boolean
	@reader
	let-i val : ValType
	
	def-i Maybe ->> isSet = False
	def-i Maybe($val) ->> isSet = True
end

class Point
	@reader
	let-i x, y : Integer
	
	@commutative
	def-i + (ref other : Point) : self
		...
	end
end

############################
# Implementation selectors #
############################

def shortest_path[:Dijkstra](ref g : Graph{NodeData, EdgeData}) : NodeData
	...
end

def shortest_path[:BellmanFord](ref g : Graph{NodeData, EdgeData}) : NodeData
	...
end

# The compiler is free to select whichever version of the function it wishes.
shortest_path(my_graph)

# Selecting a specific implementation:
shortest_path[:Dijkstra](my_graph)

#######################
# Semantic versioning #
#######################

#########################
# Debugging expressions #
#########################

#################
# Documentation #
#################
