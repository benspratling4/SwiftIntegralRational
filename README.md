# SwiftIntegralRational
Generic Rationals in pure Swift

The idea is to have a rational-integer type which uses as many Int-like or Float-like APIs as possible, which conforms to all the appropriate Swift number protocols, or uses methods very much like them as possible, so that it can represent rationals of other integer types, such as arbitrary-precision integers.


There are two types in this package:

- The main generic type `struct IntegralRational`, which uses any `SignedNumeric` for its numerator & denominator.  All the functionality in the package is defined relative to this type.

- A convenience type, `Rat`, which is an `IntegralRational` with `Int`s as its numerator & denominator.  It really is just a type alias, but is far more convenient tp type than `IntegralRational<Int>`.


Scope
All the basic arithmetic functions are implemented in this package, addition, subtraction, multiplication, division and remainder.  And few special values, one, zero, etc..   But trigonometic and more advanced calculations have not been written.  For that, please convert into floating point values.


Watch out
Many of the algorithms in this package are naïve.   This has implications for large values blowing out the available width of the integer types, and also for performance.  If you'd like to contribute algorithms which do a better job handling large values or optimize performance, feel free to make a pull request.
