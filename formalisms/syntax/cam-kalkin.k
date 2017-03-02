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
 * - Polymorphic Objects
 *   - Syntax
 *     - Type parameters
 *     - Non-type parameters
 *     - Default parameters
 *   - Namespaces
 *   - Functions
 *   - Types
 * - Interfaces ✓
 * - Mixins ✓
 * - Composits
 * - Reopening ✓
 * - Lambdas
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
#-- This is a block comment. --#

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
<b42, b100, b87>
<b"cat">
let a := 42, b := 100, c := 87
<a,b,c>

# Constructs four byte binaries.
<42, 100, 87{16}>
<42, 100, 550>

# Store an Integer in a specific representation:
#~ I can't even tell what this is doing.
<100{8, signed}, 200{unsigned}, -20{signed}> # The last signedness specification is redundant.

# Specify the endianness:
<600{16, unsigned, big}, 700{signed, little}, 800{native}>

# Hashes
{{ :one => 1, :two => 2, :three => 3 }}

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

#####################
# Basic expressions #
#####################

# Operator usage
1 + 2
my_array ++ 42 # presuming one-element append

# Function calls
fib 6

# Method calls
my_array.size ()
my_array.size
my_array.append 42

# Conditionals
if val % 2 then :odd else :even
val % 2 ? :odd : :even

if val == 0
then :zero
else if val == 1
     then :one
     else :number

# Logical keywords
not bool_val0
bool_val0 or bool_val1
bool_val0 and bool_val1
bool_val0 nor bool_val1
bool_val0 xor bool_val1

# Sequencing
seq
  1 + 2
  my_array ++ 42
  fib 6

seq { 1 + 2 ; my_array ++ 2 ; fib 6 }

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

foo : (Integer, Integer)
foo = (7, 8)

# Parametrized types

Array String
Vector 42 Float

# Function Types

returnsConstant42 () = 42
returnsConstant42 : void -> Integer
returnsConstant42 = 42

returnsAddOne : Integer -> Integer
returnsAddOne n = n + 1

## The following has an implicit seq in the body
returnsIntegerArrayMap : (Integer -> Integer) -> Array Integer -> Array Integer
def returnsIntegerArrayMap f as =
  let x = 5
  x + y

########################
# Variable definitions #
########################
## (These are not allowed at the top level)

# Declare a new integer variable 'x' that will be default initialized.
# You'll get an error if there isn't a default value
let x : Integer = _

# Declare a new integer variable 'y' and give it a value.  Its type is inferred.
let y = 42

# Declare two default initialized strings called 'a', and 'b'.
let foo, bar : String

# Creates a new copy of SomeClass and default initializes another
# SomeClass.
let a = SomeClass 42 ; b = SomeClass ()
let a = SomeClass 42
    b : SomeClass = _

# Re-bind the name `a` to different memory location.
a = get_some_class ()
a = SomeClass 100

# You can also do this to be explicit
let a = SomeClass 200

# This form of let returns the result of evaluating the expression with the
# new binding instead of the value of the new binding.
seq
  let a = SomeClass 300
  a.some_method

########################
# Function definitions #
########################

# These are function definitions.  Return types can be inferred if the body is a
# literal.
fib : Integer -> Integer
fib 1 = 1
fin 2 = 1
fib n = fib (n - 1) + fib (n - 2)

#--
 This function takes four arguments: three integers and a float.  The
 parameter `a` must always be provided; default values are specified for the
 other parameters.
--#

math_function : Integer -> Integer -> Integer -> Float -> Float
math_function a (b = 2) (c : Integer = 3) (d : Float = 4.0) = a + b + c + d

# you can also name your keywords, but you have to qualify them to avoid
# ambiguity
math_function 1 (c = 3) (d = 100.0)

#--
This is invalid:
  math_function 1 (c = 3) (d = 100.0)
--#

# Takes x by value and y by reference.
bar : Integer -> Ref Integer -> Integer
bar x y = ...

# Default values for non-trivial types
bar : SomeClass -> Integer
bar (x = SomeClass 1 2 3) = 42

baz (a = SomeClass (), b = SomeClass 1 2 3) = 42

# Calls bar with a new instance of SomeClass.
bar (SomeClass ())

#### # Splat parameters
#### # Da fuck is a `splat`
#### avg : Splat Int
#### def avg(splat nums : Integer) : Integer ->> ...
#### def avg(splat ref nums : Integer) : Integer ->> ...
####
#### # Splat arguments
#### let args := (1, :two, "three") : (Integer, Atom, String)
#### def helper(a : Integer, b : Atom, c : String) : void ->> ...
####
#### helper(splat args)
####
#### def min(a, b : Integer) : Integer ->> if a <= b then a else b end
####
#### # This is fine because the size of the array is known statically
#### min(splat [12, 5])
####
#### # This will result in a dynamic check and could produce an exception
#### min(splat get_array())
####
#### # Mixed splat usage (both work)
####
#### avg([1, 2, 3, 4])
#### avg(splat [1, 2, 3, 4])
####
#### # Forwarding of an arbitrary number of arguments is done thusly:
#### def wrapper_fun(splat args :? ArgTypes) : RetType
#### 	unwrapped_fun(splat args)
#### end

##############
# Namespaces #
##############

# Definition of a namespace
module Math
  cos : Real -> Real
  cos x = ...

# Calling a member of the Math namespace
Math::cos 0.1234

# Imports
import Math::cos

# Qualified imports
import Math::cos as cosine
import Math renaming (cos) as (cosine)
import Math renaming (cos,sin) as (cosine,sine)

# Qualified Instantiated Import
import Math Integer as MathInt

# Import Submodules
import Math::Trig
import Math::(Trig,Matrix)

# Maps a new name in the current scope to an existing name in another scope.
import Foo::Bar as Faz
import Foo(Bar, Baz) as (Far, Faz)

# Namespace Form
import Foo
	foo : () -> ()
	bar : () -> ()
	baz : Int -> Int -> ()
	baz : Int -> Float -> ()

# Results in importing (foo as fud), bar, and baz : Int -> Float -> ()
import Foo
  hiding (baz : Int -> Int -> ())
	renaimg foo as fud

# Results in importing (foo :=> fud) and baz
import Foo::baz
import Foo::foo as fud

###########
# Classes #
###########
# I am 100% uncertain about this syntax. This is just a dead sprint trying to
# sketch things out.

class Point
  let mut x : Integer
  let mut y : Integer

  constructor (x', y') =
    seq
      set x x'  # Maybe also valid: !x = x' ?
      set y y'  # or something like x != x', but that means a different in a lot
                # of languages

  destructor : Self -> () # type can always be inferred
  destructor self = ...

  # I presume that x / y are always in scope
  move : Integer -> Integer -> Point
  def move x' y' =
    set x (x + x')
    set y (y + y')

  rightfix 10 := # 10 is precedence level

  :=_ : Point -> Point # This means `right-a
  def := p1
    set x p1.x
    set y p1.y

  postfix self 10 !  # self means it's expecting itself as an argument
                     # it's a syntax error if `Self` doesn't occur exaclty once
                     # in the type signature
  _! : Self -> Point
  def _ !
    set x 0
    set y 0

  prefix self 10 -_ # self means it's expecting itself as an argument
  -_ : Self -> Point
  def - _
    Point (-x) (-y)

  infix self + 10
  _+_ : Self -> Point -> Point

  _ + p = Point (x + p.x) (y + p.y)

  infix self * 10
  _*_ : Self -> Integer -> Integer
  _ * scale = Point (x * scale) (y * scale)

  # define something at the class level instead
  class origin : Point

  # here the `$` means 'class-level'
  $origin = Point 0 0

# Bringing a member of the Point namespace
Point::origin

# This is an example of some subclassing relationships.
class Animal

class Dog <: Animal

class Cat <: Animal

#--
 Because classes are objects themselves they too can have state.  In practice
 it is best to avoid this!
--#
class CountedClass
  class let mut count : Integer
  class set count 0

  constructor : () -> CountedClass
  def constructor () =
    set $count ($count + 1)            ## Oh, I get it. `$` means CLASS VARIABLE
    super ()

  # Using `$` for the class definition
  $getCount : () -> Integer
  $getCount _ = $count

CountedClass::count ()

#--
 This factors out the counting behavior above and then creates a new class
 that uses the counting behavior.
--#

class CountingClass <: Class
  let mut count : Integer = 0

  constructor : () -> Class
  def constructor _ =
    set count (count + 1)
    super () # maybe Class::constructor ()

  getCount : () -> Integere
  getCount _ = count

class CountedAnimals <: CountedClass
  countAsString : () -> String
  countAsString _ = "There are " ++ (show count) ++ " animals"

class LoggedClass :< Class
  let mut id : Integer
  let mut log : Straem

  destructor : Self -> ()
  destructor _ = log.write "Destroying an instance"

  $destructor : Self -> ()
  $destructor = print ("Destroyed logging class" ++ (show id))

class ExampleClass
  let a0 , a0 : Array Integer

  constructor : ...
  def constructor a0' a1' =
    ...

  # Two special operators

  postfix self 20 _(_,_)
  _(_,_) : Self -> Integer -> Integer -> Integer
  _(x,y) = a0[x] = a1[y]

  postfix self 20 _[_,_]
  _[_,_] : Self -> Integer -> Integer -> (Integer, Integer)
  _[x,y] = (a0[x],a1[y])

let example : ExampleClass = ExampleClass [1, 2, 3] [4, 5, 6]

example(0, 0) # Evaluates to 5
example[1, 2] # Evaluates to (2, 6)

class AnotherExample
	# Generates accessor (by value) for the x member.
  let visible mut x : Integer

  constructor : Integer -> AnotherExample
  constructor x' = set x x'

  x= : Integer -> AnotherClass
  x= x' = set x x'

let ae := AnotherExample 42

ae.x # Evalutes to 42
ae.x = 100 # Calles the method x=

# Self types

class Foo
	let val : Integer

  constructor : Integer -> Foo
  def constructor val' =
    set val val'

  bar : Self
  bar = self  # I guess the self keyword exists

  baz : Foo
  baz =
    if condition
    then Foo val
    else self

  bav : $Foo # Again, `$` means 'class of'
  bav = self.class

class Fud <: Foo

let var := Fud 42

# Returns the object that `var` points to.
var.bar

# Could return either the object that `var` points to or a new object.  The
# type of this expression is Foo.
var.baz

# Syntactic sugar for ADTs

adt Maybe a where
  Just : a -> Maybe a
  None : Maybe a

adt Expr b where
  If : Expr b -> Expr b -> Expr b
  BinExp : Expr b -> Expr b -> Expr b
  Number : b -> Expr b

##############
# Interfaces #
##############

#--
 Interfaces may not specify implementations of methods.  If you wish to
 provide partial implementations you can declare a mixin and then use it as
 an interface.
--#

interface Monoid a
  empty : Monoid a
  compose : a -> Monoid a -> Monoid a

## Also implements Iterable
interface Container a implements [Iterable (Container a)]
  [] : Container a
  size : () -> Integer

  prefix self 50 _[_]

  _[_] : Self -> Integer -> a

  iter : Self -> Iterator a

## Requires it has Appendable, Iterable
interface [Iterable f] Mappable (f a)

  # default impl
  # if the implementing class doesn't provide one, this
  # is the one used
  map : f a -> (a -> b) -> f b
  map structure fun = ...

###############################
# Using Interfaces and Mixins #
###############################

class Foo implements [Monoid Int]

class Bar a implements [Monoid a]

class Bar a implements [Monoid a, Iterable (Bar a), Mappable (Bar a)]

#############
# Reopening #
#############

namespace Outer
	class Foo
		bar : Integer -> Integer
    bar x = x

	namespace Inner
		reopen Foo
      bar : Integer -> Integer
      bar x = x + 100


    (Foo ()).bar 42 # Yields 142
  # end of inner namespace due to spacing

  (Foo ()).bar 42 # Yields 42

#####################
# Generic Functions #
#####################

eq : [Comparable a b] => a -> b -> Boolean
eq x y = x == y

min : [Comparable t t] => t -> t -> Boolean
min x1 x2 = if x1 < x2 then x1 else x2

fold : [Iterable (f a)] -> (f a) -> (a -> b -> b) -> b

log : String -> Stream -> Stream

alg : List a -> Stream -> Integer -> ()

######################
# Parametrized Types #
######################

class LinkedList a

Just 42 : Maybe Integer

class Graph node edge
  let nodes : Array node
  let edges : Array edge

class Zoo (a <: Animal)
  let animals : Array a

# Interface requirement
class IntegerStorage (Container c => c)
  let storage : c Integer

class LoggingClass (Writable s, Seekable s => s)
  let stream : s


class Vector ()

# Non-type parameters.
class Vector (n : Integer) a

let vec0 := [1, 2, 3] : Vector 3 Integer

let num = vec0.getNumElements ()
let vec1 : (Vector num Integer) = vec0.getElements()

# Default type parameters:
class Graph (node = Integer) (edge = Integer)

###########
# Lambdas #
###########

\ args . expr
\ (a : Int) (b : Int) : Int . expr

λ args . expr
λ (a : Int) (b : Int) : Int . expr

################
# Block syntax #
################

class Array a
  each : (a -> b) -> Array b

[1, 2, 3, 4].each (\ el . logNumber(el))
[1, 2, 3, 4].each (λ el : Integer . logNumber(el))

############
# Aliasing #
############

longDescriptiveName = ..
shortName = longName

############
# Currying #
############

foo : Integer -> Integer -> Integer -> Integer
foo a b c = 32

let myFoo : Integer -> Integer = foo 1 2

bar : Integer -> Integer -> Integer
bar a b = 100

bar : Integer -> Integer
bar a = 200

# should raise an ambiguity error
let myBar = bar 1

# should raise an ambiguity error
let myBar = bar 1

# just fine
let myBar : Integer -> Integer = bar 1

# just fine, equals 200
let myBar : Integer = bar 1

#################
# Destructuring #
#################

# Tuples
let (a, b) = (1, 2)
let (a, b) = (1, 2, 3) # a == 1, b == (2, 3)

let (a, b) : (Integer , Integer) = (1, 2) # Fine
let (a, b) : (Integer , Integer) = (1, 2, 3) # Type error

# Arrays
let [a, b] = [1, 2]
let (a :: b) = [1, 2, 3] # a == 1, b == [2, 3]

# Binaries
let bin = [|1, 17, 42|]
let <a{8}, b, c> = bin

binFun : Binary -> Maybe (Integer, Integer, Integer)
binFun bin =
  if (bin.length == 32)
  then let <a{16,signed,big}, b{12,unsigned,little}, c{4}> = bin
       in Just (a,b,c)
  else None

# Other objects
class Foo
  matching : Self -> (Integer, String)
  matching : Self -> (String, Integer)
  matching : Self -> (Integer, Integer, Atom)

# Ambiguous
let (a, b) = Foo ()

# First
let (a,b) : (Integer, String) = Foo ()
let (a,b) : (Integer ,_) = Foo ()

# Second
let (a,b) : (String, Integer) = Foo ()
let (a,b) : (String, _) = Foo ()

# Third
let (a,b,c) = Foo ()

####################
# Pattern matching #
####################

numFn : Integer -> Atom
numFn n =
  case n of
    0              -> :zero
    1              -> :one
    n when (n < 0) -> :negg
    n              -> :other

poitnFn : Point -> Atom
pointFn p =
  case p of ## uses pattern matching defined for p
    (0,0) -> :origin
    (0,_) -> :vertical
    (_,0) -> :horizontal
    (a,a) -> :diagonal
    _     -> :other


handleRequest : Request -> Response
handleRequest r =
  case r of
    (:simple, data)  -> handle_simple(data)
    (:complex, data) -> seq ...

case getAnimal () of
  c@(:cat)       -> "cat"
  d@(:dog,breed) -> "dog" ++ (show breed)
  a@(_)          -> a.class.name # I guess

# Regular Expressions use a slightly different form
strFn : String -> Atom
strFn str =
	match str with
		/cat/                       -> :cat
		/\d+/                       -> :number
		/(\d+):num bottles of beer/ -> Atom (num ++ "bb")

tupleFn : (Integer, Integer, String) -> Atom
	case tup of
		(0, 0, "zero")                   -> :zero
		(1, 1, "one")                    -> :one
		(n, n, w) when w == n.to(String) -> :other_same
		_                                -> :not_same

def sum : (Numeric a) => Array a -> a -> a
sum arr (acc = 0) =
  case arr of
    []              -> acc
    (x :: xs)       -> sum xs (acc + x)

##############
# Exceptions #
##############

## Question: why isn't printing listed in the effects list, but exceptions are?
## Not sure I like this at all.
dangerousOp : () -> () {Exception1, Exception2}
	case rand() % 3 of
		0 -> 42
		1 -> Exception1 42
		2 -> Exception2 (42, 42)


# I don't like this, I don't feel like thinking up something better.
do
    dangeorusOp
    ...
handle e@(:Exception1, v)
  ...
handle e#(:Exception2, (v1, v2))
  ...

########################
# String interpolation #
########################

great : Person -> String
great p = "Hello ##(show p)"

###########################
# Return type overloading #
###########################

class Simulation
  run : () -> ()
  def run : () -> ()
    ...

  run : () -> Report
  def run : () -> Report
    ...

#################
# Synchronizers #
#################

# What a strange first-level feature.

# This synchronizer will process messages in the order they are received.
synchronizer FIFO
  receive : Mailbox -> PostOffice -> ()
  receive messages mailboxes = messages


synchronizer RoundRobin
  let lastSender : Object

  receive : Mailbox -> PostOffice -> ()
  receive = set lastSender (mailboxes.next lastSender)

## Cam: Having read this whole file, I still don't know what this is supposed
## to be doing.

##### # Implements two synchronizers that work together to lock access to an object.
##### interface Lockable
##### 	let lock_holder : Maybe{ref Object}
#####
##### 	require-i lock : void
##### 	require-i unlock : void
#####
##### 	default synchronizer Unlocked
##### 		on lock : void do (sender : ref Object)
##### 			$lock_holder = Maybe(sender)
##### 			sync Locked
##### 			accept
##### 		end
#####
##### 		default ->> accept
#####
##### 		receive := FIFO
##### 	end
#####
##### 	synchronizer Locked
##### 		on unlock : void do (sender : ref Object)
##### 			if sender == $lock_holder
##### 				$lock_holder = Maybe{ref Object}()
##### 				sync Unlocked
##### 				accept
##### 			else
##### 				reject
##### 			end
##### 		end
#####
##### 		default do (sender : Object)
##### 			if sender == $lock_holder then accept else reject end
##### 		end
#####
##### 		receive ->> (messages : Mailbox, mailboxes : PostOffice) mailboxes[$lock_holder]
##### 	end
##### end

###############
# Annotations #
###############

@O(arr.size)
myAlgorithm : Array a -> a
myAlgorithm arr = ...

class Point
	@reader
	let x , y : Integer

############################
# Implementation selectors #
############################

# These {} here are like an implementation selector
# (following Agda's implicit argument syntax)

shortestPath : {ImplSelector} -> Ref (Graph a b) -> a
shoortestPath {:Dijkstra} = ...
shoortestPath {:BellmanFord} = ...

# The compiler is free to select whichever version of the function it wishes.
shortestPath my_graph

# Selecting a specific implementation:
shortestPath {:Dijkstra} my_graph

# Curry-selecting it.
shortestPathDijsktra = shortestPath {:Dijkstra}

# Implementation selectors can also be used to describe other properties.
sort : {ImplSelector} -> Array Integer -> Array Integer
sort {:Stable} arr = ...

# I dont' like how this came out. I don't want Atom*, though. Maybe a List
# of atoms? Maybe it's a specific type, called
# ImplSelector
class Point
  #reader
  let x , y : Integer

  infix self + 10
  _+_ : {ImplSelector} -> Self -> Point -> Point
  {:Commutative, Associative} _ + p = Point (x + p.x) (y + p.y)

#######################
# Semantic versioning #
#######################

namespace LinearAlgebra
	@version(1.2.3)

namespace MyApplication
	@require(LinearAlgebra :>= 1.2..4) # Failure - generates a compiler warning.
	@require(LinearAlgebra :>= 1.2..2) # Success
	@require(LinearAlgebra :>= 1.2)    # Success
	@require(LinearAlgebra :>= 1)      # Success
