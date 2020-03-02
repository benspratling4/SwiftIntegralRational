import XCTest
@testable import SwiftIntegralRational

final class SwiftIntegralRationalTests: XCTestCase {
  
	func testReduce() {
		let whole = Rat(numerator: 2, denominator: 2)
		XCTAssertEqual(whole.numerator, 1)
		XCTAssertEqual(whole.denominator, 1)
		
		let half = Rat(numerator: 2, denominator: 4)
		XCTAssertEqual(half.numerator, 1)
		XCTAssertEqual(half.denominator, 2)
		
	}
	
	func testAddition() {
		let one = Rat(1)
		let two = Rat(2)
		XCTAssertEqual(two, one + one)
	}
	
	
	func testFractionalAddition() {
		
		let oneHalf = Rat(numerator: 1, denominator: 2)
		let oneThird = Rat(numerator: 1, denominator: 3)
		let fiveSixths = Rat(numerator: 5, denominator: 6)
		
		XCTAssertEqual(oneHalf + oneThird, fiveSixths)
		
	}
	
	
	func testFractionalSubtraction() {
		
		let oneHalf = Rat(numerator: 1, denominator: 2)
		let oneThird = Rat(numerator: 1, denominator: 3)
		let fiveSixths = Rat(numerator: 5, denominator: 6)
		
		XCTAssertEqual(fiveSixths - oneThird, oneHalf)
		
	}
	
	
	func testMultiplication() {
		
		let oneHalf = Rat(numerator: 1, denominator: 2)
		let oneThird = Rat(numerator: 1, denominator: 3)
		let oneSixth = Rat(numerator: 1, denominator: 6)
		
		XCTAssertEqual(oneHalf * oneThird, oneSixth)
		
		let threeFifths = Rat(numerator: 3, denominator: 5)
		let thirteenElevenths = Rat(numerator: 13, denominator: 11)
		let thirtyNineFiftyFifths = Rat(numerator: 39, denominator: 55)
		
		XCTAssertEqual(threeFifths * thirteenElevenths, thirtyNineFiftyFifths)
		
	}
	
	func testReducibleMultiplication() {
		let threeHalves = Rat(numerator: 3, denominator: 2)
		let twoNinsths = Rat(numerator: 9, denominator: 2)
		let oneThird = Rat(numerator: 1, denominator: 3)
		
		XCTAssertEqual(threeHalves / twoNinsths, oneThird)
	}
	
	
	
	func testEquatable() {
		let oneHalf = Rat(numerator: 1, denominator: 2)
		//explicitly dont allow reduction
		var twoFourths = Rat(numerator: 2, denominator: 4)
		twoFourths.numerator = 2
		twoFourths.denominator = 4
		
		XCTAssertEqual(oneHalf, twoFourths)
	}
	
	
	func testSigned() {
		let threeHalves = Rat(numerator: 3, denominator: 2)
		let negativeThreeHalves = Rat(numerator: -3, denominator: 2)
		
		XCTAssertEqual(-negativeThreeHalves, threeHalves)
		
	}
	
	func testDivision() {
		let ten = Rat(10)
		let five = Rat(5)
		let two = Rat(2)
		
		XCTAssertEqual(ten / five, two)
		
		
		let eightyFour = Rat(84)
		let sevenThirds = Rat(numerator: 7, denominator: 3)
		let thirtySix = Rat(36)
		
		XCTAssertEqual(eightyFour / sevenThirds, thirtySix)
	}
	
	func testIntegerPart() {
		let threeHalves = Rat(numerator: 3, denominator: 2)
		let (integerPart, fractionalPart) = threeHalves.mixedFraction
		XCTAssertEqual(integerPart, 1)
		XCTAssertEqual(fractionalPart, Rat(numerator: 1, denominator: 2))
		
		
		let negativeThreeHalves = Rat(numerator: -3, denominator: 2)
		let (integerPart2, fractionalPart2) = negativeThreeHalves.mixedFraction
		XCTAssertEqual(integerPart2, -1)
		XCTAssertEqual(fractionalPart2, Rat(numerator: -1, denominator: 2))
	}
	
	func testRemainders() {
		let twelve = Rat(12)
		let five = Rat(5)
		let two = Rat(2)
		
		let (quotient, remainder2) = twelve.quotientAndRemainder(dividingBy: five)
		XCTAssertEqual(quotient, 2)
		XCTAssertEqual(remainder2, two)
		
		let remainder = twelve.remainder(dividingBy: five)
		XCTAssertEqual(remainder, two)
	}
	
	
    static var allTests = [
        ("testReduce", testReduce),
		("testAddition", testAddition),
		("testFractionalAddition", testFractionalAddition),
		("testFractionalSubtraction", testFractionalSubtraction),
		("testMultiplication", testMultiplication),
		("testReducibleMultiplication", testMultiplication),
		("testEquatable", testEquatable),
		("testSigned", testSigned),
		("testDivision", testDivision),
		("testIntegerPart", testIntegerPart),
		("testRemainders", testRemainders),
    ]
}
