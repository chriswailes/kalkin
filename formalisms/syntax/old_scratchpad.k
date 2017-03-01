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
