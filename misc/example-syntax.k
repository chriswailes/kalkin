# This is a line comment.
#* This is a block comment. *#

#~ This is a temporary comment.  Kalkin will refuse to merge code that has 
#~ these into a project's master.

# These are function definitions.
def fib(1) -> 1
def fib(2) -> 1
def fib(n : Integer) : Integer -> fib(n-1) + fib(n-2)

#*
 * This function takes four arguments: three integers and a float.  The
 * parameter `a` must always be provided; default values are specified for the
 * other parameters.
 *#
def math_function(a, b(2), c(3) : Integer, d(4.0) : Float) : Integer
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
	let x(get_int()), y(get_int()) : Integer

	# Creates a new copy of an integer and default initializes a new integer.
	new a(get_int()), b : Integer
end

# Takes x and y by reference and b and c by value.
def bar(x, y : Integer, new b, c : Float) : Integer
	# Does something
end

# Takes x and b by reference and y and c by value.
def baf(let x, new y : Integer, let b, new c : Float) : Integer
	# Does something
end

# Takes an instance of SomeClass by reference.
def bar(let x : SomeClass) : void
	...
end

# Calls bar with a new instance of SomeClass.
bar(new SomeClass())

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
		new Point(0, 0)
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
 * sometimes you just need to...
 *#
class CountingClass
	#*
	 * Defines an instance variable for the CountingClass.  This is an
	 * instantiated variable of an anonymous subclass of the class named
	 * Class; CountingClass is an instance of that anonymous subclass.
	 *#
	let-c count : Integer
	
	# Overload the new message.
	let-c new : CountingClass
		$count++
		CountingClass.allocate
	end
	
	# Returns the number of instantiations of this class.
	let-c count
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
	let-i new : CountingClass
		$count++
		CountingClass.allocate
	end
	
	# Returns the number of instantiations of this class.
	let-i count
		$count
	end
end

class(CountingClass) CountedAnimals
	#*
	 * Define the body of the CountedAnimals class.
	 *#
	let-c count_as_string : String
		# Borrowing Ruby's string interpolation syntax for now.
		"There are #{$count} animals."
	end
end
