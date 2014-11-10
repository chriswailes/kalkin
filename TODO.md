# Bugs

# Features

* Add support for additional syntax:
  * semicolons to be used in place of newlines as a sequencing operator
  * tuple construction
  * array construction
  * paren-less method/function calls
  * method and operator calls for if-expressions
* Re-factor if_exprs to not allow multiple else clauses
* Convert rules to left-recursion if possible
* Write string membership tests for the parser
* Add a re-association transformation pass for operators
* Add tail-recursion detection pass
* Add support for additional literals
  * Regular expressions
  * Binary blobs
  * Hashes
  * Hex and octal numbers
* Add support for specifying the expression to be evaluated via the command line
* Add a verbose parsing option
* Implement postfix unary operators
