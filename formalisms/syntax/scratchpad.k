#*
 * Delimiters
 *#

# Strings
"hello world"

# Vectors
[|1, 2, 3|]

# Hash
{| 42 :=> "hoopy frood", 21 :=> :beer |}

# Binary
<| 42 |>

# Tuples
(| 1, 2, 3 |)

# Blocks

do
end

# Args to polymorphic objects

let cars := Array{Car}

# Params to polymorphic objects

poly T : Type
class Array
end

class Array {T : Type}
end

# Binary format specifiers

<| 42{unsigned, 12}, 112{signed, 8} |>

# Implementation selectors

def sort[:stable, :inplace](ints : Array{Integer}) : ints ->> void

let sorted_ints := sort[:stable](my_ints)

#*
 * Namespace Qualifiers
 *
 * Operations:
 *  - Merge given namespace into current namespace (use / using)
 *  - Re-name (rename / renaming)
 *  - Hide name (hide / hiding)
 *  - Add an alias (alias / aliasing)
 *  - Provide for requirements with other name (meet / meeting)
 *
 * use <namespace>::[name_list][rename a as b]::[hide c, d]
 *#

# Requires some_funame to be in scope
alias some_funame as other_funame
rename some_funame as other_funame

import SomeNamespace::InnerNamespace

import SomeNamespace::PolymorphicNamespace{Arg1, Arg2, arg_3} as InstantiatedName

import SomeNamespace::namespace_name0
import SomeNamespace::[namespace_name0, namespace_name1]

# Maps a new name in the current scope to an existing name in another scope.
import SomeNamespace::namespace_name0 as local_name0
import SomeNamespace::[rename namespace_name0 as local_name0]
import SomeNamespace::[rename namespace_name0 as local_name0, namespace_name1 as local_name1]
import SomeNamespace::[rename namespace_name0 as local_name0]::[hide namespace_name1, namespace_name2]

namespace SomeNamespace
	def foo ->> void
	def bar ->> void
	def baz(x : Int, y : Int) ->> void
	def baz(x : Int, y : Float) ->> void
end

# Results in importing (foo :=> fud), bar, and baz : Int -> Float -> void
import SomeNamespace where
	# Hide specific instance of an overloaded funciton
	hide baz : Int -> Int -> void
	rename foo as fud
end

# Same as above: Results in importing (foo :=> fud), bar, and baz : Int -> Float -> void
import SomeNamespace where
	use ::
	hide baz : Int -> Int -> void
	rename foo as fud
end

# Results in importing (foo :=> fud) and baz
import SomeNamespace where
	use baz
	rename foo as fud
end

# Same as above: Results in importing (foo :=> fud) and baz
import SomeNamespace where
	hide ::
	use baz
	rename foo as fud
end

# Input renaming

include SomeModule::[meet local_name0 as module_name0]::[rename module_name1 as local_name1]

include SomeModule where
	meet required_name0 with local_name0
	meet-i required_instance_name1 with local_instance_name0
	meet-c required_class_name2 with local_class_name0

	rename module_name0 as local_name1
	rename-i module_instance_name0 as local_instance_name1
	rename-c module_class_name0 as local_class_name1

	hide module_name2
	hide-i module_instance_name2
	hide-c module_class_name2
end

#*
 * Lambdas
 *#

let addAnser :=
lambda (x : Integer) : Integer
	x + 42
end

lambda 42
lambda (x : Integer) : Integer ->> x + 42
lambda (x : Integer) ->> x + 42

#############
# Old Stuff #
#############

#* Option 1
 *
 * Pros:
 *  -
 * Cons:
 *  -
 *#

def map{ContainerType{ElType}, ResType}(collection : ContainerType{ElType}, fun : ElType -> ResType) : ContainerType{ResType} ->> void

def map{ContainerType{ElType}, ResType}
       (collection : ContainerType{ElType}, fun : ElType -> ResType) : ContainerType{ResType} ->> void

def integerMap{ContainerType, ResType}
              (collection : ContainerType{Integer}, fun : Integer -> ResType) : ContainerType{ResType} ->> void

#* Option 2
 *
 * Pros:
 *  -
 * Cons:
 *  -
 *#

def map{ContainerType, ElType, ResType}(collection : ContainerType{ElType}, fun : ElType -> ResType) : ContainerType{ResType} ->> void

def map{ContainerType, ElType, ResType}
       (collection : ContainerType{ElType}, fun : ElType -> ResType) : ContainerType{ResType} ->> void

def integerMap{ContainerType, ResType}
              (collection : ContainerType{Integer}, fun : Integer -> ResType) : ContainerType{ResType} ->> void

#* Option 3
 *
 * Pros:
 *  -
 * Cons:
 *  - Name binding depends on state of namespace
 *#

polyform
	let CollectionType, ElType, ResType : Type
def map(collection: CollectionType{ElType}, fun : ElType -> ResType) : Collection{ResType}
	let res_collection : Collection{ResType} in
		collection.each -> (el : ElType) ->> res_collection << fun(el)
end
