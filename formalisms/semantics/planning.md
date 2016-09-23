Stage 1
-------

* 'object
  * members (defined in semantic object) ~:~ 'name => 'object-address
  * methods (defined in semantic object) ~:~ 'name => 'object-address
* 'function
  * members (defined in semantic object) := \[type : Type] ~:~ 'name => 'object-address
  * methods (defined in semantic object) := \[] ~:~ 'name => 'object-address
  * body (defined in semantic object) ~:~ 'expression


* Object
  * instance_members := [<members, List{Tuple{Symbol, Class}}>, <methods, List{Tuple{Symbol, Function}}>, <type, Type>] : List{Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Void : Type
* Type
  * instance_members := [supertype : Type] : List {Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type
* Class
  * instance\_members := [instance\_members : List{Tuple{Symbol, Class}}, instance\_methods : List{Tuple{Symbol, Function}}, supertype : Type] : List{Tuple{Symbol, Class}}
  * instance\_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Type : Type
* Function{ArgumentTypes..., ReturnType}
  * instance\_members := [arguments : List{Type}, return_type : Type]
  * type := Class : Type
  * supertype := Object : Type
* Name
  * instance_members := [] : List {Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type
* Symbol
  * instance_members := [] : List {Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type
* List{ElementType : Type}
  * instance_members := [] : List {Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type
* Tuple{ElementTypes...}
  * instance_members := [] : List{Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type
* Void
  * instance_members := [] : List{Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Type : Type
* Boolean
  * instance_members := [] : List{Tuple{Symbol, Class}}
  * instance_methods := [] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type

* true
  * type := Boolean : Type
* false
  * type := Boolean : Type



###################################


* Maybe{ElementType : Type}
  * instance_members := \[] : List{Tuple{Symbol, Class}}
  * instance_methods := \[] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Object : Type
* Some{ElementType : Type}
  * instance_members := \[] : List{Tuple{Symbol, Class}}
  * instance_methods := \[] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Maybe{ElementType} : Type
  * val : ElementType
* None
  * instance_members := \[] : List{Tuple{Symbol, Class}}
  * instance_methods := \[] : List{Tuple{Symbol, Function}}
  * type := Class : Type
  * supertype := Maybe{ElementType} : Type
