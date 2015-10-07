#* Features
 *
 * - Comments ✓
 * - Literals ✓
 *   - Binary syntax ✓
 * - Basic expressions ✓
 * - Types ✓
 *   - Type names ✓
 *   - Tuple types ✓
 *   - Function types ✓
 *   - Parametrized types ✓
 * - Variable definitions ✓
 * - Function definition ✓
 *   - Default values ✓
 *   - Keyword arguments ✓
 *   - Splat parameters/arguments ✓
 * - Namespaces ✓
 * - Classes ✓
 *   - Constructors ✓
 *   - Destructors ✓
 *   - Destructuring ✓
 *   - Operator deffinition ✓
 *     - Prefix ✓
 *     - Infix ✓
 *     - Postfix ✓
 *     - Special cases ✓
 *     - Precedence ✓
 *     - Associativity ✓
 *   - Method + operator definitions ✓
 *   - Self types ✓
 *   - ADTs ✓
 * - Interfaces ✓
 * - Mixins ✓
 * - Reopening ✓
 * - Generic Functions ✓
 *   - Default parameters ✓
 * - Parametrized types ✓
 *   - Type parameters ✓
 *   - Non-type parameters ✓
 *   - Default parameters ✓
 * - Lambdas ✓
 * - Block syntax ✓
 * - Aliasing ✓
 * - Currying ✓
 * - Local type inference ✓
 * - Destructuring ✓
 * - Pattern matching ✓
 * - Exceptions ✓
 * - String interpolation ✓
 * - Return type overloading ✓
 * - Synchronizers ✓
 * - Annotations ✓
 * - Implementation selectors ✓
 * - Semantic versioning ✓
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

# Integers
42
1E10

# Floats
3.1415926
2.71828
1.234E-56

# Atoms
:foo
:bar_

# Arrays
[1, 2, 3, 4]
[:hello, :world]

# Binaries

# Constructs three byte binaries.
[|42, 100, 87|]
[|"cat"|]
let a := 42, b := 100, c := 87
[|a, b, c|]

# Constructs four byte binaries.
[|42, 100, 87{16}]
[|42, 100, 550|]

# Store an Integer in a specific representation:
[|100{8, signed}, 200{unsigned}, -20{signed}|] # The last signedness specification is redundant.

# Specify the endianness:
[|600{16, unsigned, big}, 700{signed, little}, 800{native}|]

# Hashes
{ :one => 1, :two => 2, :three => 3 }

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
# Variable definitions #
########################

# Declare a new integer variable 'x' that will be default initialized.
let x : Integer

# Declare a new integer variable 'y' and give it a value.  Its type is inferred.
let y := 42

# Declare two default initialized strings called 'a', and 'b'.
let foo, bar : String

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

########################
# Function definitions #
########################

# These are function definitions.  Return types can be inferred if the body is a
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
math_function(1, c := 42, d := 100) # Valid

#*
 * Invalid:
 * math_function(1, c: 42, 100)
 *#

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
def avg(splat nums : Integer) : Integer ->> ...
def avg(splat ref nums : Integer) : Integer ->> ...

# Splat arguments
let args := (1, :two, "three") : (Integer, Atom, String)
def helper(a : Integer, b : Atom, c : String) : void ->> ...

helper(splat args)

def min(a, b : Integer) : Integer ->> if a <= b then a else b end

# This is fine because the size of the array is known statically
min(splat [12, 5])

# This will result in a dynamic check and could produce an exception
min(*get_array())

# Mixed splat usage (both work)

avg([1, 2, 3, 4])
avg(splat [1, 2, 3, 4])

# Forwarding of an arbitrary number of arguments is done thusly:
def wrapper_fun(splat args :? splat ArgTypes) : RetType
	unwrapped_fun(splat args)
end

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

	# This is a constructor for the Point class.  Arguments get assigned to the
	# instance's variables $x and $y.
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

	# Definition of a (not very usefull) postfix operator.
	def-i ! : self ->> $x, $y = 0, 0

	# Definition of the prefix negation operator.
	def-i - self : Point
		Point(-$x, -$y)
	end

	# Definition of an infix operator.
	@assoc(:left) @prec(0)
	def-i + (ref other : Point) ->> Point($x + other.x, $y + other.y)

	@assoc(:right) @prec(1)
	def-i * (scale : Integer) ->> Point($x * scale, $y * scale)

	# How to declare ways to destructure a Point object.
	def-i Point~ : (Integer, Integer) ->> ($x, $y)
	# Now with type inference...
	def-i Point~ ->> ($x, $y, 0)

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

class Dog <: Animal
end

class Cat <: Animal
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

	# Overload the class constructor.
	def-c CountingClass{splat ArgTypes}(splat args : ArgTypes)
		$count++
		let space := CountingClass.allocate in space.CountingClass(splat args)
	end

	# Returns the number of instantiations of this class.
	def-c count : Integer ->> $count
end

# Sending a message to the object CountingClass.
CountingClass.count

#*
 * This factors out the counting behavior above and then creates a new class
 * that uses the counting behavior.
 *#

class CountingClass <: Class
	# Define the counter.
	let-i count : Integer

	# Overload the new message.
	def-i CountingClass{splat ArgTypes}(splat args : ArgTypes)
		$count++
		let space := CountingClass.allocate in space.CountingClass(splat args)
	end

	# Returns the number of instantiations of this class.
	def-i count : Integer ->> $count
end

class[CountingClass] CountedAnimals
	#*
	 * Define the body of the CountedAnimals class.
	 *#
	def-c count_as_string : String
		"There are #{self.count} animals."
	end
end

class LoggedClass
	let-i id : Integer
	let-i log : Stream

	# Called when an object's reference count reaches zero, before the class
	# level destroy callback.
	def-i destroy : void
		$log.write("Destroying an instance of LoggedClass")
	end

	def-c destroy(obj : LoggedClass)
		# TODO: Figure out Kalkin syntax for writting to the output channel.
		puts "Destorying LoggeClass instance #{obj.id}"
	end
end

class ExampleClass
	let-i a0, a1 : Array{Integer}

	def-i ExampleClass($a0, $a1) ->> void

	# Defining the two special case operators.
	def-i ()(x, y : Integer) : Integer ->> $a0[x] + $a1[y]

	def-i [](x, y : Integer) : (Integer, Integer) ->> ($a0[x], $a1[y])
end

let example := ExampleClass([1, 2, 3], [4, 5, 6])

example(0, 0) # Evaluates to 5
example[1, 2] # Evaluates to (2, 6)

class AnotherExample
	let-i $x : Integer

	def-i AnotherExample($x) ->> void

	# Accessor for the x member.
	def-i x ->> $x

	# Assignment for the x member.
	def-i x= (new_x : Integer)
		log("Changing x to #{new_x} from #{$x}")
		$x = new_x
	end
end

let ae := AnotherExample(42)

ae.x # Evalutes to 42
ae.x = 100 # Calles the method x=

let x_val = ae.x in x_val = 100 # Does not call the x= method

# Self types

class Foo
	let-i val : Integer

	def-i Foo($val) ->> void

	# Returns the very same object that the method was called on.
	def-i bar : self
		return self
	end

	# Returns a (possibly new) object of type Foo
	def-i baz : Foo
		if get_condition() then Foo($val) else self end
	end

	# Returns a (possibly new) object of the same type as the object it was
	# called on.
	def-i baf : self.class
		if get_condition() then self.class($val) else self end
	end
end

class Fud <: Foo
end

let var := Fud(42)

# Returns the object that `var` points to.
var.bar

# Could return either the object that `var` points to or a new object.  The
# type of this expression is Foo.
var.baz

# Could return either the object that `var` points to or a new object.  The
# type of this expression is Fud.
var.baf

# Syntactic sugar for ADTs

adt Maybe {ValType} := None or Some(ValType)

adt Expr {NumberType} := IfExpr(Expr, Expr, Expr) or BinExpr(Expr, Expr) or Number(NumberType)

# or...

adt Expr {NumberType}
	IfExpr(Expr, Expr, Expr)
	BinExpr(Expr, Expr)
	Number(NumberType)
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
	require-i ImplementingClass : void
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

	def-i map{NewElementType}(fun : ElementType -> NewElementType) -> ImplementingClass{NewElementType}
		let new_container : ImplementingClass

		self.each do (el)
			new_container << fun(el)
		end

		return new_container
	end
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

def min{T |: Comparable}(v0, v1 : T) : T ->> if v0 < v1 then v0 else v1 end
def fold{ContainerType{ElementType}}(fun : ElementType -> ElementType, container : ContainerType) : ContainerType
	...
end

# These two declarations are all equivalent:
def log{LogType}(ref message : String, ref log : LogType |: Stream) ->> void
def log(ref message : String, ref log |: Stream) ->> void

# Default value for generic function:
def my_algorithm{ContainerType := List}(ref data : Stream) : Integer ->> void

# If you use a name that is already taken in the current namespace the compiler
# will generate a warning.

class Foo; end

# Generates a compiler warning that the name Foo is already used in this namespace.
def generic_function{Foo}(f : ref Foo) ->> void

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

# Non-type parameters.
class Vector{n : Integer, ElementType}
end

let vec0 := [1, 2, 3] : Vector{3, Integer}

let num := getNumElements()
let vec1 := Vector{num, Integer}(getElements())

# Default type parameters:
class Graph{NodeType := Integer, EdgeType := Integer}
	...
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

########################
# Local type inference #
########################

let value := get_int()

[1, 2, 3, 4].each do (x) x + 1

#################
# Destructuring #
#################

# Tuples
let a, b ~= (1, 2)
let a, b ~= (1, 2, 3) # a == 1, b == (2, 3)

let a, b : Integer
a, b ~= (1, 2) # Fine
a, b ~= (1, 2, 3) # Type error

# Arrays
let a, b ~= [1, 2]
let a, b ~= [1, 2, 3] # a == 1, b == [2, 3]

let a, b : Integer
a, b ~= [1, 2] # Fine
a, b ~= [1, 2, 3] # Type error

# Binaries
let bin := [|1, 17, 42|]
let [|a{8}, b, c|} ~= bin

def bin_func(bin : Binary) : Maybe{(Integer, Integer, Integer)}
	if (bin.length == 32)
		let [|a{16;:signed;:big}, b{12;:unsigned;:little}, c{4}|] := bin in Maybe((a, b, c))
	else
		None{(Integer, Integer, Integer)}
	end
end

# Other objects
class Foo
	def-i Foo~ ->> (42, "world")
	def-i Foo~ ->> ("hello", 42)
	def-i Foo~ ->> (1, 2.3, :four)
end

# Ambiguous
let a, b ~= Foo()

# First
let a : Integer, b : String ~= Foo()
let a : Integer, b ~= Foo()

# Second
let a : String, b : Integer ~= Foo()
let a : String, b ~= Foo()

# Third
let a, b, c ~= Foo()

####################
# Pattern matching #
####################

def number_function(n : Integer) : Symbol
	match n with
		n where n < 0 ->> :neg
		0             ->> :zero
		1             ->> :one
		_             ->> :other
	end
end

def binornot(n : Integer) : Symbol
	match n with
		0 or 1 ->> :binary
		_      ->> :not_binary
	end
end

def point_function(p : Point) : Symbol
	match p with
		Point(0, 0) ->> :origin
		Point(0, _) ->> :vertical
		Point(_, 0) ->> :horizontal
		Point(a, a) ->> :diagonal
		_           ->> :other
	end
end

def handle_request(r : Request) : Response
	match r with
		Request(:simple, data) ->> handle_simple_request(data)
		Request(:complex, data) do
			# Do something complicated.
		end
	end
end

match get_animal() with
	Cat as c ->> "cat"
	Dog(breed) ->> "dog - #{breed}"
	Animal as a ->> p.class.name
end

def string_function(str : String) : Symbol
	match str with
		/cat/ ->> :cat
		/\d+/ ->> :number
		/(\d+):num bottles of beer/ ->> Symbol(num + "bb")
	end
end

def tuple_function(tup : (Integer, Integer, String)) : Symbol
	match tup with
		0, 0, "zero" ->> :zero
		1, 1, "one" ->> :one
		n, n, w where w == n.to(String) ->> :other_same
		_ ->> :not_same
	end
end

def sum{NumType |: Numeric}(arr : Array{NumType}, acc := NumType()) : NumType
	match arr with
		[] ->> acc
		x, xs ->> sum(xs, acc + x)
	end
end

##############
# Exceptions #
##############

def dangerous_operation() : void :! Exception1, Exception2
	match rand() % 3 with
		0 ->> 42
		1 ->> Exception1(42)
		2 ->> Exception2(42, 42)
	end
end

do
	dangerous_operation()

handle Exception1(v) as e
	...

handle Exception2(v0, v1) as e
	...
end

########################
# String interpolation #
########################

def great(p : Person) : String
	"Hello #{p.name}!"
end

###########################
# Return type overloading #
###########################

class Simulation
	def-i run : void
		# Execute simulation without collecting statistics
	end

	def-i run : Report
		# Execute simulation and collect statistics
	end
end

#################
# Synchronizers #
#################

# This synchronizer will process messages in the order they are received.
synchronizer FIFO
	receive ->> (messages : Mailbox, mailboxes : PostOffice) messages
end

# This synchronizer will select one message from each sender in turn.
synchronizer RoundRobin
	require-i last_sender : Object

	receive do (messages : Mailbox, mailboxes : Postoffice)
		$last_sender = mailboxes.next($last_sender)
	end
end

# Implements two synchronizers that work together to lock access to an object.
mixin Lockable
	let-i lock_holder : Maybe{ref Object}

	require-i lock : void
	require-i unlock : void

	default synchronizer Unlocked
		on lock : void do (sender : ref Object)
			$lock_holder = Maybe(sender)
			sync Locked
			accept
		end

		default ->> accept

		receive := FIFO
	end

	synchronizer Locked
		on unlock : void do (sender : ref Object)
			if sender == $lock_holder
				$lock_holder = Maybe{ref Object}()
				sync Unlocked
				accept
			else
				reject
			end
		end

		default do (sender : Object)
			if sender == $lock_holder then accept else reject end
		end

		receive ->> (messages : Mailbox, mailboxes : PostOffice) mailboxes[$lock_holder]
	end
end

###############
# Annotations #
###############

@O(arr.size)
def my_algorithm{DataType}(arr : Array{DataType}) : DataType
	...
end

class Point
	@reader
	let-i x, y : Integer
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

# Implementation selectors can also be used to describe other properties.
def sort[:stable](array : Array{Integer}) : Array{Integer} ->> void

class Point
	@reader
	let-i x, y : Integer

	# This could cause a lot of horizontal creep.  Is there a better way to do this?
	def-i +[:commutative, :associative](other : ref Point) ->> Point($x + other.x, $y + other.y)
end

#######################
# Semantic versioning #
#######################

namespace LinearAlgebra
	@version(1, 2, 3)
end

namespace MyApplication
	@require(LinearAlgebra, :>=, 1, 2, 4) # Failure - generates a compiler warning.
	@require(LinearAlgebra, :>=, 1, 2, 2) # Success
	@require(LinearAlgebra, :>=, 1, 2) # Success
	@require(LinearAlgebra, :>=, 1) # Success
end
