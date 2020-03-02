# SwiftIntegralRational
Generic Rationals in pure Swift

The idea is to have a rational-integer type which uses as many Int-like or Float-like APIs as possible, which conforms to all the appropriate Swift number protocols, or uses methods very much like them as possible, so that it can represent rationals of other integer types, such as arbitrary-precision integers.


There are two types in this package:

- The main generic type `struct IntegralRational`, which uses any `SignedNumeric` for its numerator & denominator.  All the functionality in the package is defined relative to this type.

- A convenience type, `Rat`, which is an `IntegralRational` with `Int`s as its numerator & denominator.  It really is just a type alias, but is far more convenient to type than `IntegralRational<Int>`.


## Creating an instance

Of the generic type:

`let value = IntegralRational<Int64>(numerator:6, denominator:4)`

`value.description` == "3/2"

As you can see, IntegralRational automatically reduces when you `init`, which helps avoid overflow in later math operations.

Of the Rat type

`let value = Rat(numerator:3, denominator:2)`

If your initial value is an integer, you can use just 

`let pureIntegralValue = Rat(3)`
and IntegralRational will assume a denominator of 1.
`pureIntegralValue.description` == "3/1"


## Working with instances

Basic math works just like built-in integer and floating point types, using standard operators like `+`, `-`, `*`, and `/`.

These operators have the same crash-your-app problems that standard Swift types would encounter for operations that overflow or divide by zero.  So watch out for operations that might end up dividing by zero or make products that overflow the max integer value.

When you want to risk loosing precision and convert to a floating point type, create one like so:

`let rationalValue = Rat(numerator:1, denominator:10)`

`let floatValue = Float(rationalValue)`

That's right, Float will never be able to perfectly represent 0.1, because 5 is relatively prime to 2.

Sometimes, you'll want to get a real improper fraction with a seriously integer integer part, call 

`let value = Rat(numerator:3, denominator:2)`

`let (integerPart, fractionalPart):(Int, Rat) = value.integerAndFractionalParts()`

`print(integerPart)	`// 1

`print(fractionalPart)`	// 1/2

which gives you an integer that's a legit integer, and a fractional part that's still an IntegralRational.

`.quotientAndRemainder(dividingBy:)` makes similar results but by dividing by values other than 1.



## Codable

IntegralRational always encodes as an array of integers, `[numerator, denominator]` for efficiency.

When decoding, it can support 3 formats:
- 1 integer `[numerator]`  it assumes the denominator is one.
- 2 integers `[numerator, denominator]`, matching the encoding format.
- 1 integer + an array of 2 integers `[i, [fn, fd]]` where `i` is the integer part, and `fn` and `fd` are the numerator and denominator (respectively) of the fractional part.  This is especially useful for humans manually encoding large numbers with fractional values.

Any other format throws a `IntegralRationalError.invalidJSON` error.



## Scope
All the basic arithmetic functions are implemented in this package, addition, subtraction, multiplication, division and remainder.  And few special values, one, zero, etc..   But trigonometic and more advanced calculations have not been written.  For that, please convert into floating point values.

## Performance
Many of the algorithms in this package are naïve, so performance might not be as fast for large (or small) numbers as you'd hoped.  If you'd like to contribute an optimized algorithm, or an algorithm that avoid overflows, feel free to make a Pull Request.  
