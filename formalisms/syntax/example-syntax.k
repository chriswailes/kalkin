#* Features
 *
 * - Comments ✓
 * - Literals
 *   - Binary syntax
 * - Basic expressions
 * - Types
 *   - Type names
 *   - Tuple types
 *   - Function types
 *   - Parametrized types
 * - Variable definitions
 * - Function definition
 *   - Default values
 *   - Keyword arguments
 *   - Splat parameters/arguments
 * - Namespaces
 * - Classes
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
 *   - Self types
 *   - ADTs
 * - Polymorphic Objects
 *   - Syntax
 *     - Type parameters
 *     - Non-type parameters
 *     - Default parameters
 *   - Namespaces
 *   - Functions
 *   - Types
 * - Interfaces
 * - Mixins
 * - Composits
 * - Reopening
 * - Lambdas
 * - Block syntax
 * - Aliasing
 * - Currying
 * - Local type inference
 * - Destructuring
 * - Pattern matching
 * - Exceptions
 * - Default exception handlers
 * - String interpolation
 * - Return type overloading
 * - Synchronizers
 * - Annotations
 * - Implementation selectors
 * - Semantic versioning
 *
 * NOTE: ... is most often used here to indicate elided code.  The only
 *       exception is for Int range literals.
 *
 * TODO:
 * - Default exception handlers
 * - Type conversion
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

# Ints
42
1E10

# Floats
3.1415926
2.71828
1.234E-56

# Atoms
:foo
:bar_
:foo12

#*
 * Unicode Delimiter Alternatives
 *
 * - Guillemet «»
 * - Angle Brackets 〈〉
 * - Double Angle Bracket ⟪⟫
 * - Tortoises Shell Bracket ⟬⟭
 * - Angle Brackets with Dot ⦑⦒
 * - Half Brackets ⸢⸣⸤⸥
 * - Corner Brackets 「」
 * - Lenticular Bracket 〖〗
 *#


# Arrays
# TODO: Change delimiters to [] if it doesn't cause parsing problems for the final grammar.
[|1, 2, 3, 4|]
[|:hello, :world|]

# Binaries

# Constructs three byte binaries.
# TODO: Change delimiters to <> if it doesn't cause parsing problems for the final grammar.
<|42, 100, 87|>
<|"cat"|>
let a := 42, b := 100, c := 87
<|a, b, c|>

# Constructs four byte binaries.
<|42, 100, 87{16}|>
<|42, 100, 550|>

# Store an Int in a specific representation:
<|100{8, signed}, 200{unsigned}, -20{signed}|> # The last signedness specification is redundant.

# Specify the endianness:
<|600{16, unsigned, big}, 700{signed, little}, 800{native}|>

# Hashes
# TODO: Change delimiters to {} if it doesn't cause parsing problems for the final grammar.
{| :one :=> 1, :two :=> 2, :three => 3 |}

# Regular Expressions
/ab*/

# Strings
"Hello world!"

# Tuples
# TODO: Change delimiters to () if it doesn't cause parsing problems for the final grammar.
(| 1, 2 |)
(| :hello, :world |)
(| 1, 2.0, :three, "four" |)

# Int ranges
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
fib 6

# Method calls
my_array.size()
my_array.size
my_array.append(42)
my_array.append 42

# Conditionals
if val % 2 then :odd else :even end

# Actually a call to the ? operator for Ints, which converts the value to a
# Boolean and calls the ? operator on that.
val % 2 ? :odd, :even

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

# These are function definitions.  Return types can be inferred if the body is a
# literal.
def fib(1) :~ 1
def fib(2) :~ 1
def fib(n : Int) -> Int :~ fib(n - 1) + fib(n - 2)

# OR

def fib(n : Int)
	if n <= 1 then 1 else fib(n-1) + fib(n-2) end
end

# OR

def fib(n : Int)
	if n <= 1
		1
	else
		fib(n - 1) + fib(n - 2)
	end
end

# Parameter overloading

def add(a, b : Int) -> Int :~ a + b
def add(a, b, c : Int) -> Int :~ a + b + c

def add(a, b : Array{Int}) -> Array{Int} :~ a.zip(b).map lambda (a,b : Int) :~ a + b

#*
 * This function takes four arguments: three Ints and a float.  The
 * parameter `a` must always be provided; default values are specified for the
 * other parameters.
 *#
def math_function(a, b := 2, c := 3 : Int, d := 4.0 : Float) : Float
	a + b + c + d
end

# Once you start using keyword arguments, you can't switch back.
math_function(1, c := 42, d := 100) # Valid

#*
 * Invalid:
 * math_function(1, c: 42, 100)
 *#

# Default values for non-trivial types
def bar(x := SomeClass(1, 2, 3)) -> Int :~ 42

def baz(a : SomeClass, b := SomeClass(1, 2, 3)) -> Int :~ 42
def baz(a, b := SomeClass(1, 2, 3) : SomeClass) -> Int :~ 42

# Calls bar with a new instance of SomeClass.
bar(SomeClass())

# Splat parameters
def avg(splat nums :| Splat{Int}) -> Int :~ void

# Splat arguments
let args := (1, :two, "three") : (Int, Atom, String)
def helper(a : Int, b : Atom, c : String) -> void :~ void

helper(splat args)

def min(a, b : Int) -> Int :~ if a <= b then a else b end

# This is fine because the size of the array is known statically
min(splat [12, 5])

# This will result in a dynamic check and could produce an exception
min(splat get_array())

###################
# Type conversion #
###################

let x := 42
float_fun(x.to Float) # This would normally get done automatically

# Converting inline.
array.map(lambda (x) :~ x + 10).to(List).each ...

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

# Apply selector to namespace
SomeNamespace::[#* selector syntax *#]

# Chaining namespace selectors
SomeNamespace::[#* selector syntax *#]::[#* selector syntax *#]

# Select several names from a namespace
SomeNamespace::[ns_name0, ns_name1]

# SomeNamespace, but with some names changed.  This doesn't change how
# functions inside the namespace refer to each other, nor how other namespaces
# view the namespace.
SomeNamespace::[rename ns_name0 as local_name1]

# SomeNamespace, but with some aliases added.  This doesn't change how
# functions inside the namespace refer to each other, nor how other namespaces
# view the namespace.
SomeNamespace::[alias ns_name0 as local_name1]

# SomeNamespace, but with some names removed.  This doesn't change how
# functions inside the namespace refer to each other, nor how other namespaces
# view the namespace.
SomeNamespace::[hide ns_name0, ns_name1]

# Putting it all together
SomeNamespace::[alias ns_name0 as local_name0]::[hide ns_name1]::[rename ns_name1 as local_name1]

#*
 * Aliasing, instantiating, and importing names
 *#

# Adds a new name `other_funame` that can be used to refer to `some_funame`
alias some_funame as other_funame

# Add the names from SomeNamespace::InnerNamespace to the current namespace.
import SomeNamespace::InnerNamespace

# Add specific names to the current namespace
import SomeNamespace::ns_name0
import SomeNamespace::[ns_name0, ns_name1]

# Maps an existing name in SomeNamespace to a new name in the current scope.
import SomeNamespace::ns_name0 as local_name0

# Import all names from SomeNamespace, but rename some of them.
import SomeNamespace::[rename ns_name0 as local_name0]
import SomeNamespace::[rename ns_name0 as local_name0, ns_name1 as local_name1]

# Same as above
import SomeNamespace::[rename namespace_name0 as local_name0]::[hide namespace_name1, namespace_name2]

namespace NamespaceExample
	def foo :~ void
	def bar :~ void
	def baz(x : Int, y : Int) :~ void
	def baz(x : Int, y : Float) :~ void
end

# Each statement here acts as a filter, just like in the shorthand above.

# Results in importing (foo :=> fud), bar, and baz : Int -> Float -> void
import NamespaceExample where
	# Hide specific instance of an overloaded function
	hide baz : Int -> Int -> void
	rename foo as fud
end

# Results in importing (foo :=> fud) and baz
import NamespaceExample where
	import foo, baz
	rename foo as fud
end

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
	def-i move(x : Int, y : Int) : self
		$x += x
		$y += y
	end

	# Assignment messages must always return self.
	def-i =(other : Point) : self
		# Parallel assignment.
		$x, $y = other.x, other.y
	end

	# Definition of a (not very useful) postfix operator.
	def-i ! : self :~ $x, $y = 0, 0

	# Definition of the prefix negation operator.
	def-i - self : Point
		Point(-$x, -$y)
	end

	# Definition of an infix operator.
	@assoc(:left) @prec(0)
	def-i + (ref other : Point) :~ Point($x + other.x, $y + other.y)

	@assoc(:right) @prec(1)
	def-i * (scale : Int) :~ Point($x * scale, $y * scale)

	# How to declare ways to destructure a Point object.
	destructure : (Int, Int) :~ ($x, $y)
	# Now with type inference...
	destructure :~ ($x, $y, 0)

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
class CountedClass
	#*
	 * Defines an instance variable for the CountedClass.  This is an
	 * instantiated variable of an anonymous subclass of the class named
	 * Class; CountedClass is an instance of that anonymous subclass.
	 *#
	let-c count : Int

	# Overload the class constructor.
	def-c CountedClass(splat args :? ArgTypes)
		$count++
		super(splat args)
	end

	# Returns the number of instantiations of this class.
	def-c count : Int :~ $count
end

# Sending a message to the object CountingClass.
CountedClass.count

#*
 * This factors out the counting behavior above and then creates a new class
 * that uses the counting behavior.
 *#

class CountingClass <: Class
	# Define the counter.
	let-i count : Int

	# Overload the new message.
	def-i CountingClass(splat args :? ArgTypes)
		$count++
		super(splat args)
	end

	# Returns the number of instantiations of this class.
	def-i count : Int :~ $count
	def-i () :~ $count
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
	let-i id : Int
	let-i log : Stream

	# Called when an object's reference count reaches zero.
	def-i destroy : void
		$log.write("Destroying an instance of LoggedClass")
	end
end

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

class AnotherExample
	let-i $x : Int

	def-i AnotherExample($x) :~ void

	# Accessor (by value) for the x member.
	def-i x :~ $x

	# Assignment for the x member.
	def-i x= (new_x : Int)
		log("Changing x to #{new_x} from #{$x}")
		$x = new_x
	end
end

let ae := AnotherExample(42)

ae.x # Evaluates to 42
ae.x = 100 # Calls the method x=

# Self types

class Foo
	let-i val : Int

	def-i Foo($val) :~ void

	# Returns the same object that the method was called on.
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
 * Full Syntax
 *#

# 1. Ensure that the implementing namespace/interface/module/class provides namespace/class/instance names

require InnerName
# OR ???
require namespace InnerNamespace
require interface InnerInterface
require module InnerModule
require class InnerClass

# Require the implementing namespace provide a function.
require helper : String -> Int

# Require the implementing class to provide an instance method.
require-i foo : void -> Int
require-i constructor (void)

# Require the implementing class to provide a class method.
require-c bar : Int -> Int -> String

# 2. Ensure that the implementing namespace/interface/module/class implements a specific interface

require $: implements SomeInterface
require Implementer implements SomeInterface

# 3. Ensure that a namespace/interface/module/class inside the implementing namespace/interface/module/class implements a specific interface

require $::InnerNamespace implements HelperInterface
require $::InnerInterface implements Collection
require $::InnerModule implements Loggable
require $::InnerClass implements DefaultConstructable

require Implementer::InnerNamespace implements HelperInterface

# 4. Ensure that a polymorphic variable, if it is a namespace/interface/module/class, implements a specific interface.

require PolyVarName implements SomeInterface

# 5. Declare that this interface subsumes another

implements Collection

#*
 * Interfaces may not specify implementations of methods.  If you wish to
 * provide partial implementations you can declare a module and then use it as
 * an interface.
 *#

interface Monoid
	require-i constructor (void)
	require-i successor : void -> self.class
	# or
	require-i successor : void -> $:
end


interface Container
	# ImplementingClass must also implement the Iterable interface.
	implements Iterable

	require-i [] : Int -> ElementType
	require-i size : -> Int
end

interface Fooable
	# A class function that takes two instances of itself and returns an
	# instance of itself.
	require-c foo(a, b : self) -> self
	# or
	require-c foo(a, b : $:) -> $:
end

###########
# Modules #
###########

# Same syntax from Interfaces works in Mappable

module Mappable
	# The implementing class must have an element type
	require class ElType

	# ImplementingClass must implement the Appendable and Iterable interface.
	require $: implements Appendable, Iterable

	def-i map(fun : ElType -> ElType) -> $:
		let new_container : Implementer

		self.each do (el)
			new_container << fun(el)
		end

		return new_container
	end
end

################################
# Using Interfaces and Modules #
################################

class Foo
	implements Monoid::[meet successor with increment]

	def-i increment : self.class
		...
	end
end

class Bar
	implements Appendable, Iterable
	include Mappable::[meet helper with my_helper]::[rename map as other_name]

	include Mappable where
		meet helper with my_helper
		rename map as other_name
	end

	def-i my_helper(a : Int) : Integr :~ a
end

#############
# Reopening #
#############

namespace Outer
	namespace Foo
		def bar(x : Int) : Int :~ x
	end

	namespace Inner
		reopen Foo
			def bar(x : Int) : Int :~ x + 100
		end

		Foo::bar(42) # Evaluates to 142
	end

	Foo::bar(42) # Evaluates to 42
end

###########
# Lambdas #
###########

# The return type is optional for this forms.
lambda (x, y : ArgType) -> RetType :~ expression
lambda (x, y : ArgType) :~ expression
lambda :~ expresssion

# ??
lambda (x, y : ArgType) expression
lambda expresssion

# Return type is required
lambda (x, y : ArgType) -> RetType
	# code
end

# No-argument long-form lambda
lambda -> RetType
	# code
end

################
# Block syntax #
################

class IntArray
	...

	def-i each(block : Int -> void) : self
		...
	end
end

# Without type inference
[1, 2, 3, 4].each do (el : Int) -> void
	log_number(el)
end

# With type inference
[1, 2, 3, 4].each do (el)
	log_number(el)
end

# Also works
[1, 2, 3, 4].each lambda (el : Int) -> void
	log_number(el)
end

[1, 2, 3, 4].each lambda (el : Int) -> void :~ log_number(el)
[1, 2, 3, 4].each lambda (el : Int) :~ log_number(el)
[1, 2, 3, 4].each lambda (el) :~ log_number(el)

############
# Aliasing #
############

def a_long_descriptive_function_name :~ void
alias a_long_descriptive_function_name as short_name

############
# Currying #
############

def foo(a, b, c : Int) -> Int :~ 42

let my_foo := `foo(1, 2) : Int -> Int

def bar (a, b : Int) -> Int :~ 100
def bar (a : Int) -> Int :~ 200

let my_bar := `bar(1) : -> Int

########################
# Local type inference #
########################

let value := get_int()

[1, 2, 3, 4].each do (x) x + 1

#################
# Destructuring #
#################

# Tuples
let a, b <~ (|1, 2|)
let a, b <~ (|1, 2, 3|) # a == 1, b == (2, 3)

let a, b : Int
a, b <~ (|1, 2|) # Fine
a, b <~ (|1, 2, 3|) # Type error

# Arrays
let a, b <~ [|1, 2|]
let a, b <~ [|1, 2, 3|] # a == 1, b == [2, 3]

let a, b : Int
a, b <~ [|1, 2|] # Fine
a, b <~ [|1, 2, 3|] # Type error

# Binaries
let bin := [|1, 17, 42|]
let [|a{8}, b, c|} <~ bin

def bin_func(bin : Binary) : Maybe{(Int, Int, Int)}
	if (bin.length == 32)
		let [|a{16;:signed;:big}, b{12;:unsigned;:little}, c{4}|] <~ bin in Maybe((a, b, c))
	else
		None
	end
end

# Other objects
class Foo
	destructure :~ (42, "world")
	destructure :~ ("hello", 42)
	destructure :~ (1, 2.3, :four)
end

# Ambiguous
let a, b <~ Foo()

# First
let a : Int, b : String <~ Foo()
let a : Int, b <~ Foo()

# Second
let a : String, b : Int <~ Foo()
let a : String, b <~ Foo()

# Third
let a, b, c <~ Foo()

####################
# Pattern matching #
####################

# Pattern matching options

def foo(node : BinOp) : void
	match node with
		Add~>(l0, r0 : ASTNode)
		Add~>(l0 : IntLiteral, r0 : ASTNode)
		Add~>(l0 : IntLiteral, r0 : Add~>(l1 : IntLiteral, r1))
	end
end


def number_function(n : Int) : Symbol
	match n with
		n where n < 0 :~ :neg
		0             :~ :zero
		1             :~ :one
		_             :~ :other
	end
end

def binornot(n : Int) : Symbol
	match n with
		0 or 1 :~ :binary
		_      :~ :not_binary
	end
end

def point_function(p : Point) : Symbol
	# Longhand
	match p with
		Point~>(0, 0) :~ :origin
		Point~>(0, _) :~ :vertical
		Point~>(_, 0) :~ :horizontal
		Point~>(a, a) :~ :diagonal
		_             :~ :other
	end

	# Shorthand
	match p with
		0, 0 :~ :origin
		0, _ :~ :vertical
		_, 0 :~ :horizontal
		a, a :~ :diagonal
		_    :~ :other
	end
end

def handle_request(r : Request) -> Response
	match r with
		Request~>(:simple, data) :~ handle_simple_request(data)
		Request~>(:complex, data) do
			# Do something complicated.
		end
		Request~>(:other, data) :~ handle_other_request(data)
	end
end

match get_animal() with
	c : Cat      :~ "cat"
	Dog~>(breed) :~ "dog - #{breed}"
	a: Animal    :~ p.class.name
end

# TODO: Name captures
def string_function(str : String) -> Symbol
	match str with
		/cat/ :~ :cat
		/\d+/ :~ :number
		/(\d+) bottles of beer/ :~ Symbol(num + "bb")
	end
end

def tuple_function(tup : Tuple{Int, Int, String}) -> Symbol
	match tup with
		0, 0, "zero" :~ :zero
		1, 1, "one"  :~ :one
		n, n, w where w == n:-String :~ :other_same
		_ :~ :not_same
	end
end

def sum(arr : Array{Int}, acc := 0) : Int
	match arr with
		[||]  :~ acc
		x, xs :~ sum(xs, acc + x)
	end
end

##############
# Exceptions #
##############

def dangerous_operation() : void :! Exception1, Exception2
	match rand() % 3 with
		0 :~ 42
		1 :~ raise Exception1(42)
		2 :~ raise Exception2(42, 42)
	end
end

do
	dangerous_operation()

handle e : Exception1~>(v)
	...

handle e : Exception2~>(v0, v1)
	...
end

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

## Non-type Parameters

poly n, m : Int, ElType : Type
class Matrix
	let-i data : Vector{n, Vector{m, ElType}}
end

## Default parameters

poly ResultType := Float
def foo(a, b : Int) -> ResultType :~ void

poly ResultType := Float : Type
def foo(a, b : Int) -> ResultType :~ void

## Named parameters

poly
	A, B : Type
	C := Bar
	d := 12
class Foo
	void
end

let f := Foo{Int, Int, d := 42}()

## Polymorphic parameters

poly ElType : Type, ContainerType : Type{1} #* Type{Type} *#
class Foo
	let-i data : ContainerType{ElType}
	constructor ($data)
end

## Requirements

poly T : Type
	require T implements Loggable
def foo(item : T) :~ void

## Instantiation of Polymorphics

# Instantiate a polymorphic namespace
use SomeNamespace::PolymorphicNamespace{Arg1, Arg2, arg_3} as InstantiatedName

# Instantiate a polymorphic class
use SomeClass{Type1, Type2} as RealClass

## Specialization

poly ElType : Type
class BinaryPrefixTree
	...
end

class BinaryPrefixTree{Float}
end

# You can also specialize with keywords
class BinaryPrefixTree{ElType := Float}
end

## Partial Specification

poly A, B : Type
class Foo
end

poly B : Type
use Foo{Int, B} as FooInt

## Re-specification

# TODO: Figure out what this should look like.  To do it properly we need a way to talk about numbers and names of type parameters.

## Extra-shorthand

# TODO: Develop the extra-short shorthand.

#*
 * Namespaces
 *#

poly T : Type
namespace Foo
	use Tuple{T, T} as Pair
	def foo(a : T) :~ void
end

#*
 * Functions
 *#

poly T : Type
def id(obj : T) -> T :~ obj

#*
 * Interfaces
 *#

poly T : Type
interface Convertable
	def-i to -> T
end

#*
 * Modules
 *#

poly T : Type
module Foo
	def bar(obj : T) -> T :~ obj
end

#*
 * Classes
 *#

poly T : ElType
class Wrapper
	let-i el : ElType
end

##############################
# Default exception handlers #
##############################

# TODO

########################
# String interpolation #
########################

def great(p : Person) : String
	"Hello #{p.name}!"
end

#################
# Synchronizers #
#################

# This synchronizer will process messages in the order they are received.
synchronizer FIFO
	receive (messages : Mailbox, mailboxes : PostOffice) :~ messages
end

# This synchronizer will select one message from each sender in turn.
synchronizer RoundRobin
	require-i last_sender : Object

	receive (messages : Mailbox, mailboxes : PostOffice)
		$last_sender = mailboxes.next($last_sender)
	end
end

# Implements two synchronizers that work together to lock access to an object.
module Lockable
	let-i lock_holder : Maybe{Object}

	require-i lock : void -> void
	require-i unlock : void -> void

	default
	synchronizer Unlocked
		# Here the type of lock is made explicit
		on lock : void -> void
			$lock_holder = Maybe($!)
			sync Locked
			accept
		end

		# However, since there aren't any other `lock`s in scope this also
		# works.
		on lock
			...
		end

		default :~ accept

		receive := FIFO
	end

	synchronizer Locked
		on unlock
			if $! == $lock_holder
				$lock_holder = Maybe{Object}()
				sync Unlocked
				accept
			else
				reject
			end
		end

		default do
			if $! == $lock_holder then accept else reject end
		end

		receive (messages : Mailbox, mailboxes : PostOffice) :~ mailboxes[$lock_holder]
	end
end

#*
 * TODO: Current design does not allow for hygienic composition of
 *       synchronizers.  Fix this by adding a notion of protocols that binds
 *       multiple synchronizers together.  New rules will be needed to describe
 *       the interaction between multiple protocols/syncronizers that know
 *       nothing about each other (e.g. all current syncronizers must accept a
 *       message for it to be handled).
 *#

########################
# Aggregation patterns #
########################

# TODO

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

############################
# Implementation selectors #
############################

# Syntax

implementation
	# Weak implementation selectors aren't required in recursive calls.
	weak :Name0

	# Strong implementation selectors are required in recursive calls.
	strong :Name1
def foo void -> void
	...
end

implementation
	weak :Dijkstra
def shortest_path(g : Graph{NodeData, EdgeData}) -> NodeData
	...
end

implementation
	weak :BellmanFord
def shortest_path[:BellmanFord](g : Graph{NodeData, EdgeData}) -> NodeData
	...
end

# The compiler is free to select whichever version of the function it wishes.
shortest_path(my_graph)

# Selecting a specific implementation:
shortest_path[:Dijkstra](my_graph)

# Implementation selectors can also be used to describe other properties.
implementation
	strong :stable
def sort(array : Array{Int}) -> Array{Int}
	...
end

class Point
	@reader
	let-i x, y : Int

	implementation
		strong :commutative, :associative
	def-i +(other : Point) :~ Point($x + other.x, $y + other.y)
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
