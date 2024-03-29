import Foundation

///Use this like a shorthand
public typealias Rat = IntegralRational<Int>


///Represents a pure rational number, expressed by the ratio of two signed integers
///the numerator & denominator conform to SignedInteger not because I'm glad that requires BinaryInteger conformance, but because mere SignedNumeric has no division operators, and that makes writing several of these methods harder than they need to be.  If someone can help eliminate the need for all / operators in these method implementations, I'm happy to release a version where the IntType does not require binary conformance.
public struct IntegralRational<IntType:SignedInteger> : Comparable, SignedNumeric {
	
	//MARK: - Instance vars
	public var numerator:IntType
	public var denominator:IntType
	
	//MARK: - Init's
	///really really bad things happen when denominator is zero
	public init(numerator:IntType, denominator:IntType) {
		self.numerator = numerator
		self.denominator = denominator
		reduce()
	}
	
	///Convenience init for integers
	public init(_ integerValue:IntType) {
		self.numerator = integerValue
		self.denominator = IntType(1)
	}
	
	//MARK: - reduction
	
	///init and == both reduce automatically, you should only need this if you have to set the properties explicitly, which should be very rare
	public func reduced()->IntegralRational<IntType> {
		var newValue = self
		newValue.reduce()
		return newValue
	}
	
	///init and == both reduce automatically, you should only need this if you have to set the properties explicitly, which should be very rare
	public mutating func reduce() {
		let gcd:IntType = GCD(num: numerator, denom: denominator)
		numerator /= gcd
		denominator /= gcd
	}
	
	
	//MARK: - Equatable
	
	public static func ==<IntType>(lhs:IntegralRational<IntType>, rhs:IntegralRational<IntType>)->Bool {
		return lhs.numerator * rhs.denominator == rhs.numerator * lhs.denominator
	}
	
	
	//MARK: - Comparable
	
	public static func < <IntType>(lhs:IntegralRational<IntType>, rhs:IntegralRational<IntType>)->Bool {
		return lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator
	}
	
	
	//MARK: - AdditiveArithmetic
	
	public static var zero: IntegralRational<IntType> {
		IntegralRational<IntType>(integerLiteral: 0)
	}
	
	public static func +(lhs: IntegralRational<IntType>, rhs: IntegralRational<IntType>) -> IntegralRational<IntType> {
		var newValue = lhs
		newValue += rhs	//for copy performance, implementation is in mutating operator
		return newValue
	}
	
	public static func +=(lhs: inout IntegralRational<IntType>, rhs: IntegralRational<IntType>) {
		lhs.numerator *= rhs.denominator
		lhs.numerator += rhs.numerator * lhs.denominator
		lhs.denominator *= rhs.denominator
		lhs.reduce()
	}
	
	public static func -(lhs: IntegralRational<IntType>, rhs: IntegralRational<IntType>) -> IntegralRational<IntType> {
		var newValue:IntegralRational<IntType> = lhs
		newValue -= rhs	//for copy performance, implementation is in mutating operator
		return newValue
	}
	
	public static func -=(lhs: inout IntegralRational<IntType>, rhs: IntegralRational<IntType>) {
		lhs.numerator *= rhs.denominator
		lhs.numerator -= rhs.numerator * lhs.denominator
		lhs.denominator *= rhs.denominator
		lhs.reduce()
	}
	
	
	//MARK: - Inspired by AdditiveArithmetic
	
	public static var one: IntegralRational<IntType> {
		IntegralRational<IntType>(integerLiteral: 1)
	}
	
	public static var negativeOne: IntegralRational<IntType> {
		IntegralRational<IntType>(integerLiteral: -1)
	}
	
	public static var half:IntegralRational<IntType> {
		IntegralRational(numerator:IntType(1), denominator:IntType(2))
	}
	
	
	//MARK: - ExpressibleByIntegerLiteral
	
	public typealias IntegerLiteralType = Int
	
	public init(integerLiteral value: IntegerLiteralType) {
		let num:IntType = IntType(value)
		let denom:IntType = IntType(1)
		self = IntegralRational(numerator: num, denominator: denom)
	}
	
	
	//MARK: - Numeric
	
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let newNumer = IntType(exactly:source) else { return nil }
		let newDenominator:IntType = 1
		self = IntegralRational<IntType>(numerator:newNumer, denominator:newDenominator)
	}
	
	
	public typealias Magnitude = IntegralRational<IntType>
	
	public var magnitude: IntegralRational<IntType> {
		if numerator < 0 {
			return IntegralRational(numerator: -numerator, denominator: denominator)
		}
		return self
	}
	
	
	public static func *(lhs: IntegralRational<IntType>, rhs: IntegralRational<IntType>) -> IntegralRational<IntType> {
		var newValue:IntegralRational<IntType> = lhs
		newValue *= rhs
		return newValue
	}
	
	public static func *=(lhs: inout IntegralRational<IntType>, rhs: IntegralRational<IntType>) {
		lhs.numerator *= rhs.numerator
		lhs.denominator *= rhs.denominator
	}
	
	
	//MARK: - SignedNumeric
	
	prefix public static func -(operand: IntegralRational<IntType>) -> IntegralRational<IntType> {
		var newValue:IntegralRational<IntType> = operand
		newValue.negate()
		return newValue
	}
	
	public mutating func negate() {
		numerator.negate()
	}
	
	
	//MARK: - Inspired by FloatingPoint
	
	public var sign: FloatingPointSign  {
		if numerator >= 0 {
			return .plus
		} else {
			return .minus
		}
	}
	
	public static func /(lhs: IntegralRational<IntType>, rhs: IntegralRational<IntType>) -> IntegralRational<IntType> {
		var newValue:IntegralRational<IntType> = lhs
		newValue /= rhs	//for copy performance, implementation is in mutating operator
		return newValue
	}
	
	
	public static func /=(lhs: inout IntegralRational<IntType>, rhs: IntegralRational<IntType>) {
		lhs.numerator *= rhs.denominator
		lhs.denominator *= rhs.numerator
		lhs.reduce()
	}
	
	
	public func remainder(dividingBy other: IntegralRational<IntType>) -> IntegralRational<IntType> {
		var remain = self
		remain.formRemainder(dividingBy:other)
		return remain
	}
	
	public mutating func formRemainder(dividingBy other: IntegralRational<IntType>) {
		if numerator == 0 {
			self = .zero
			return
		}
		if other.numerator == 0 {
			self = .zero
			return
		}
		let inverseOfDividend:IntegralRational = IntegralRational(numerator: other.denominator, denominator: other.numerator)
		let fullQuotient:IntegralRational = self * inverseOfDividend	//division is accomplished by multiplying by the inverse of the dividend
		let (_, leftOvers) = fullQuotient.mixedFraction
		self = leftOvers * other
	}
	
	public static func % (lhs: IntegralRational<IntType>, rhs: IntegralRational<IntType>) -> IntegralRational<IntType> {
		return lhs.remainder(dividingBy: rhs)
	}

	public static func %= (lhs: inout IntegralRational<IntType>, rhs: IntegralRational<IntType>) {
		return lhs.formRemainder(dividingBy: rhs)
	}
	
	///useful to get a pure integer quotient, but the remainder may still be an IntegralRational
	public func quotientAndRemainder(dividingBy rhs: IntegralRational<IntType>) -> (quotient: IntType, remainder: IntegralRational<IntType>) {
		if numerator == 0 {
			return (0, .zero)
		}
		if rhs.numerator == 0 {
			return (0, self)
		}
		let inverseOfDividend:IntegralRational = IntegralRational(numerator: rhs.denominator, denominator: rhs.numerator)
		let fullQuotient:IntegralRational = self * inverseOfDividend	//division is accomplished by multiplying by the inverse of the dividend
		let (integerPart, leftOvers) = fullQuotient.mixedFraction
		return (integerPart, leftOvers * rhs)
	}
	
	
	///such that Rat(result.0) + result.1 == self
	@available(*, deprecated, renamed: "mixedFraction")
	public func integerAndFractionalParts()->(IntType, IntegralRational<IntType>) {
		let (integerPart, fractionalPart) = mixedFraction
		return (integerPart, fractionalPart)
	}
	
	///such that Rat($0.mixedFraction.integerPart) + $0.mixedFraction.fractionalPart == $0
	public var mixedFraction:(integerPart:IntType, fractionalPart:IntegralRational<IntType>) {
		let (integerPart, leftOvers) = numerator.quotientAndRemainder(dividingBy:denominator)
		return (integerPart, IntegralRational(numerator: leftOvers, denominator: denominator))
	}
	
	
	public var isZero: Bool {
		return numerator == 0
	}
	
	public var isNaN: Bool {
		return denominator == 0
	}
	
	public var isInfinite: Bool {
		return denominator == 0
	}
	
	//TODO: isSignalingNaN
	//TODO: isFinite
	
	///default rule .toNearestOrAwayFromZero
	public mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
		if denominator == 1 {
			return	//it's already rounded
		}
		switch rule {
		case .down:
			if numerator < 0 {
				round(.awayFromZero)
			} else {
				round(.towardZero)
			}
		case .up:
			if numerator < 0 {
				round(.towardZero)
			} else {
				round(.awayFromZero)
			}
		case .towardZero:
			numerator = numerator/denominator
			denominator = IntType(1)
		case .awayFromZero:
			var newNum:IntType = numerator/denominator
			if newNum * denominator != numerator {
				if numerator < 0 {
					newNum += IntType(-1)
				} else {
					newNum += IntType(1)
				}
			}
			numerator = newNum
			denominator = IntType(1)
		case .toNearestOrAwayFromZero:
			var newNum:IntType = numerator/denominator
			let floor = newNum * denominator
			let towardsZeroDiff = abs(numerator - floor)
			let awayFromZeroDiff = denominator - towardsZeroDiff
			if  awayFromZeroDiff <= towardsZeroDiff {
				newNum += numerator.unitAwayFromZero
			}
			numerator = newNum
			denominator = IntType(1)
		case .toNearestOrEven:
			var newNum:IntType = numerator/denominator
			let floor = newNum * denominator
			let towardsZeroDiff = abs(numerator - floor)
			let awayFromZeroDiff = denominator - towardsZeroDiff
			if awayFromZeroDiff == towardsZeroDiff {
				//if the newNum isn't even, use the away from zero value
				let two:IntType = IntType(2)
				if newNum != (newNum / two) * two {
					newNum += numerator.unitAwayFromZero
				}
			} else if awayFromZeroDiff < towardsZeroDiff {
				newNum += numerator.unitAwayFromZero
			} // else towards zero, alreay accomplished
			numerator = newNum
			denominator = IntType(1)
		@unknown default:
			self.round(.toNearestOrAwayFromZero)
		}
	}
	
	///default rule .toNearestOrAwayFromZero
	public func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> IntegralRational<IntType> {
		var newValue:IntegralRational<IntType> = self
		newValue.round(rule)
		return newValue
	}
	
	
	//TODO: public func truncatingRemainder(dividingBy other: Self) -> Self
	//TODO: public mutating func formTruncatingRemainder(dividingBy other: Self)
	
	//MARK: - Inspired by BinaryInteger
	
	public func signum()->IntegralRational<IntType> {
		if isZero {
			return .zero
		}
		else if numerator.signum() == denominator.signum() {
			return .one
		}
		else {
			return .negativeOne
		}
	}
	
	
	//TODO: public init?(exactly other: FloatingPoint)
	//TODO: init<T>(clamping source: T) where T : BinaryInteger
	
}


extension SignedInteger {
	/// gets the towards-zero rounded value, round first if desiring other methods
	public init(_ value:IntegralRational<Self>) {
		self = value.rounded(.towardZero).numerator
	}
	
}


//MARK: - Conditional Conformances

extension IntegralRational where IntType : BinaryInteger {
	
	@available(*, deprecated, message: "To be more Swifty, use FloatingPoint(self) instead.")
	///succeeds if FloatType(exactly:numerator) and FloatType(exactly:denominator) succeed
	public func floatingPoint<FloatType:FloatingPoint>()->FloatType? {
		guard let numer:FloatType = FloatType(exactly:numerator) else { return nil }
		guard let denom:FloatType = FloatType(exactly:denominator) else { return nil }
		return numer / denom
	}
	
	public var doubleValue:Double {
		return Double(numerator)/Double(denominator)
	}
}


//MARK: - Hashable

extension IntegralRational : Hashable where IntType : Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(numerator)
		hasher.combine(denominator)
	}
}


//MARK: - Encodable & Decodable

extension IntegralRational : Encodable where IntType : Encodable {
	///the exported format is always an array of two integers, the numerator then denominator
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(numerator)
		try container.encode(denominator)
	}
}


extension IntegralRational : Decodable where IntType : Decodable {
	///To make it easy for humans to craft values manually, decoding suports 3 formats:
	///	[n] array with single integer - the integer becomes the numerator, the denominator is assumed to be 1
	/// [n, d]	array with two integers - the first integer becomes the numerator, 2nd the denominator
	///	[i, [fn, fd]]	array with an integer followed by an array of 2 integers, this is a "mixed fraction" where the i is the whole part, and the fn and fd are the fractional part, the final number is n = i * fd + fn, d = fd
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		guard let count:Int = container.count
			,count > 0
			else {
				throw IntegralRationalError.invalidJSON
		}
		numerator = try container.decode(IntType.self)
		if count < 2 {
			denominator = 1
			return
		}
		do {
			denominator = try container.decode(IntType.self)
		} catch {
			//if the denominator is instead an array of ints, then we have a mixed fraction
			let fractionParts:[IntType] = try container.decode([IntType].self)
			if fractionParts.count != 2 {
				throw IntegralRationalError.invalidJSON
			}
			denominator = fractionParts[1]
			let newNumerator = numerator * denominator + fractionParts[0]
			numerator = newNumerator
			reduce()
		}
	}
}


public enum IntegralRationalError : Error {
	case invalidJSON
}


extension FloatingPoint {
	///succeeds if Self(exactly:numerator) and Self(exactly:denominator) succeed
	public init?<IntType>(_ integralRational:IntegralRational<IntType>) where IntType : BinaryInteger {
		guard let numer:Self = Self(exactly:integralRational.numerator) else { return nil }
		guard let denom:Self = Self(exactly:integralRational.denominator) else { return nil }
		self = numer / denom
	}
	
}


extension IntegralRational : CustomStringConvertible where IntType : CustomStringConvertible {
	public var description: String {
		return numerator.description + "/" + denominator.description
	}
}


extension IntegralRational : CustomDebugStringConvertible where IntType : CustomDebugStringConvertible {
	public var debugDescription: String {
		return numerator.debugDescription + "/" + denominator.debugDescription
	}
}


//TODO: when INT : FixedWidthInteger, implement arithmetic functions using overflow-reporting methods

extension SignedInteger {
	
	@inlinable public init?(exactly source: IntegralRational<Self>) {
		let (integerPart, fractionalPart) = source.mixedFraction
		if fractionalPart != .zero { return nil }
		self = integerPart
	}
	
}


extension SignedInteger {
	fileprivate var unitAwayFromZero:Self {
		if self < 0 {
			return Self(-1)
		} else {
			return Self(1)
		}
	}
}


//MARK: - utilities

private func GCD<IntType:SignedInteger>(num: IntType,  denom:IntType) -> IntType {
	//this is a naïve implementation, could use a faster method for larger numbers.
	var A = num
	var B = denom
	var r:IntType
	while (abs(B) > 0) {
		r = A % B
		A = B
		B = r
	}
	if (A >= 0) {
		return A
	} else {
		return -A
	}
}
