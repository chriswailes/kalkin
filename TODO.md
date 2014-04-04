# Bugs

# Features

* Add support for additional syntax:
  * semicolons to be used in place of newlines as a sequencing operator
  * tuple construction
  * array construction
  * paren-less method/function calls
  * method and operator calls for if-expressions
* Change expr_core to be right-recursive
* Write string membership tests for the parser
* Add a re-association transformation pass for operators
* Add tail-recursion detection pass
* Add support for additional literals
  * Regular expressions
  * Binary blobs
  * Hashes
  * Hex and octal numbers
