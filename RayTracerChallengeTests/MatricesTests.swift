//
//  Matrices.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/18.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class MatricesTests: XCTestCase {
	var cts: Matrix!
	var identityMatrix: Matrix!

    override func setUpWithError() throws {
        cts = Matrix(4, 4)
		cts[0, 0] = 1;    cts[0, 1] = 2;    cts[0, 2] = 3;    cts[0, 3] = 4
		cts[1, 0] = 5.5;  cts[1, 1] = 6.5;  cts[1, 2] = 7.5;  cts[1, 3] = 8.5
		cts[2, 0] = 9;    cts[2, 1] = 10;   cts[2, 2] = 11;   cts[2, 3] = 12
		cts[3, 0] = 13.5; cts[3, 1] = 14.5; cts[3, 2] = 15.5; cts[3, 3] = 16.5
		
		identityMatrix = Matrix(string: """
		|1|0|0|0|
		|0|1|0|0|
		|0|0|1|0|
		|0|0|0|1|
		"""
		)
    }

    override func tearDownWithError() throws {
        cts = nil
    }
	
	func test_canInitializeAndInspect() throws {
		XCTAssertNotNil(cts)
		XCTAssertEqual(4, cts.size.0)
		XCTAssertEqual(4, cts.size.1)
		
		//	Scenario: Constructing and inspecting a 4x4 matrix
		//	Given the following 4x4 matrix M:
		//	|1|2|3|4|
		//	| 5.5| 6.5| 7.5| 8.5|
		//	| 9 | 10 | 11 | 12 |
		//	| 13.5 | 14.5 | 15.5 | 16.5 |
		//	Then M[0,0] = 1
		//	And M[0,3] = 4
		//	And M[1,0] = 5.5
		//	And M[1,2] = 7.5
		//	And M[2,2] = 11
		//	And M[3,0] = 13.5
		//	And M[3,2] = 15.5
		
		XCTAssertEqual(1, cts[0, 0])
		XCTAssertEqual(cts[0,3], 4)
		XCTAssertEqual(cts[1,0], 5.5)
		XCTAssertEqual(cts[1,2], 7.5)
		XCTAssertEqual(cts[2,2], 11)
		XCTAssertEqual(cts[3,0], 13.5)
		XCTAssertEqual(cts[3,2], 15.5)
		
	}
	
	func test_2x2Matrix() throws {
		//	Scenario: A 2x2 matrix ought to be representable
		//	Given the following 2x2 matrix M:
		//	| -3 | 5 |
		//	| 1 | -2 |
		//	Then M[0,0] = -3
		//	And M[0,1] = 5
		//	And M[1,0] = 1
		//	And M[1,1] = -2
		
		cts = Matrix(2, 2)
		cts[0, 0] = -3;    cts[0, 1] = 5;
		cts[1, 0] = 1;  cts[1, 1] = -2;

		XCTAssertEqual(-3, cts[0, 0])
		XCTAssertEqual(5, cts[0, 1])
		XCTAssertEqual(1, cts[1, 0])
		XCTAssertEqual(-2, cts[1, 1])
	}

	
	
	
	func test_3x3Matrix() throws {
		//	Scenario: A 3x3 matrix ought to be representable
		//	Given the following 3x3 matrix M:
		let mText = """
		|-3| 5| 0|
		| 1|-2|-7|
		|0|1|1|
		"""
		//	Then M[0,0] = -3
		//	And M[1,1] = -2
		//	And M[2,2] = 1
		cts = Matrix(3, 3)
		cts[0, 0] = -3;    cts[0, 1] = 5;    cts[0, 2] = 0;
		cts[1, 0] = 1;  cts[1, 1] = -2;  cts[1, 2] = -7;
		cts[2, 0] = 0;    cts[2, 1] = 1;   cts[2, 2] = 1;
		
		let m = Matrix(string: mText)
		
		XCTAssertEqual(m, cts)
		
		XCTAssertEqual(-3, cts[0, 0])
		XCTAssertEqual(5, cts[0, 1])
		XCTAssertEqual(0, cts[0, 2])
		
		XCTAssertEqual(1, cts[1, 0])
		XCTAssertEqual(-2, cts[1, 1])
		XCTAssertEqual(-7, cts[1, 2])
		
		XCTAssertEqual(0, cts[2, 0])
		XCTAssertEqual(1, cts[2, 1])
		XCTAssertEqual(1, cts[2, 2])
	}
	
	func test_equatable() throws {
		// Scenario: Matrix equality with identical matrices
		var testSubject = Matrix(4, 4)
		testSubject[0, 0] = 1;    testSubject[0, 1] = 2;    testSubject[0, 2] = 3;    testSubject[0, 3] = 4
		testSubject[1, 0] = 5.5;  testSubject[1, 1] = 6.5;  testSubject[1, 2] = 7.5;  testSubject[1, 3] = 8.5
		testSubject[2, 0] = 9;    testSubject[2, 1] = 10;   testSubject[2, 2] = 11;   testSubject[2, 3] = 12
		testSubject[3, 0] = 13.5; testSubject[3, 1] = 14.5; testSubject[3, 2] = 15.5; testSubject[3, 3] = 16.5
		
		XCTAssertEqual(testSubject, cts)
		
		// Scenario: Matrix equality with different matrices
		testSubject = Matrix(4, 4)
		testSubject[0, 0] = 0;    testSubject[0, 1] = 2;    testSubject[0, 2] = 3;    testSubject[0, 3] = 4
		testSubject[1, 0] = 5.5;  testSubject[1, 1] = 6.5;  testSubject[1, 2] = 7.5;  testSubject[1, 3] = 8.5
		testSubject[2, 0] = 9;    testSubject[2, 1] = 10;   testSubject[2, 2] = 11;   testSubject[2, 3] = 12
		testSubject[3, 0] = 13.5; testSubject[3, 1] = 14.5; testSubject[3, 2] = 15.5; testSubject[3, 3] = 0
		
		XCTAssertNotEqual(testSubject, cts)
	}
	
	func test_multiply() throws {
		//	Scenario: Multiplying two matrices
		//
		//	Given the following matrix A:
		let aText = """
		|1|2|3|4|
		|5|6|7|8|
		|9|8|7|6|
		|5|4|3|2|
		"""
		//	And the following matrix B:
		let bText = """
		|-2|1|2| 3|
		| 3|2|1|-1|
		| 4|3|6| 5|
		| 1|2|7| 8|
		"""
		//
		//	Then A * B is the following 4x4 matrix:
		let cText = """
		|20| 22| 50| 48|
		|44| 54|114|108|
		|40| 58|110|102|
		|16| 26| 46| 42|
		"""
		
		let A = Matrix(string: aText)
		let B = Matrix(string: bText)
		let C = Matrix(string: cText)
		XCTAssertNotEqual(A, B)
		XCTAssertNotEqual(C, B)
		XCTAssertNotEqual(A, C)
		
		XCTAssertEqual(C, A*B)
	}
	
	func test_initializeWithString() throws {
		// Secnario: Initialize Matrix with text from the book
		// Given: t = "|1|2|\n|3|4|\n"
		// When: m = Matrix(string: t)
		// Then: returns m which is 2x2 matrix and
		//       it's values should be [[1, 2], [3 ,4]]
		
		let t = "|1|2|\n|3|4|\n"
		let arr = t.components(separatedBy: "\n").filter { !$0.isEmpty }
		XCTAssertEqual(2, arr.count)
		var newArray = [String]()
		for el in arr {
			var ch = el
			ch.removeFirst()
			ch.removeLast()
			ch = ch.replacingOccurrences(of: "|", with: ",")
			newArray.append(ch)
		}
		XCTAssertEqual(["1,2","3,4"], newArray)
		
		let m = Matrix(string: t)
		XCTAssertEqual(2, m.size.0)
		XCTAssertEqual(2, m.size.1)
		XCTAssertEqual(1, m[0, 0])
		XCTAssertEqual(2, m[0, 1])
		XCTAssertEqual(3, m[1, 0])
		XCTAssertEqual(4, m[1, 1])
	}
	
	func test_multiplayByTuple() throws {
		//	Scenario: A matrix multiplied by a tuple
		//	Given the following matrix A:
		let aText = """
		|1|2|3|4|
		|2|4|4|2|
		|8|6|4|1|
		|0|0|0|1|
		"""
		//	And b ← tuple(1, 2, 3, 1)
		//	Then A * b = tuple(18, 24, 33, 1)
		
		cts = Matrix(string: aText)
		let b = Tuple(x: 1, y: 2, z: 3, w: 1)
		XCTAssertEqual(Tuple(x: 18, y: 24, z: 33, w: 1), cts*b)
	}
	
	func test_identityMatrix() throws {
		//	Scenario: Multiplying a matrix by the identity matrix
		//	Given the following matrix A:
		let aText = """
		|0|1| 2| 4|
		|1|2| 4| 8|
		|2|4| 8|16|
		| 4 | 8 | 16 | 32 |
		"""
		//	Then A * identity_matrix = A
		let a = Matrix(string: aText)
		XCTAssertEqual(a, a*identityMatrix)
		
		//	Scenario: Multiplying the identity matrix by a tuple
		//	Given a ← tuple(1, 2, 3, 4)
		//	Then identity_matrix * a = a
		let t = Tuple(x: 1, y: 2, z: 3, w: 4)
		XCTAssertEqual(t, identityMatrix*t)
	}
	
	func test_transposing() throws {
		//	Scenario: Transposing a matrix
		//	Given the following matrix A:
		let aText = """
		|0|9|3|0|
		|9|8|0|8|
		|1|8|5|3|
		|0|0|5|8|
		"""
		//	Then transpose(A) is the following matrix:
		let aDashText = """
		|0|9|1|0|
		|9|8|8|0|
		|3|0|5|5|
		|0|8|3|8|
		"""
		cts = Matrix(string: aText)
		let transposedCTS = cts.transpose()
		let aDash = Matrix(string: aDashText)
		XCTAssertEqual(aDash, transposedCTS)
	}
	
	func test_determinat() throws {
		//	Scenario: Calculating the determinant of a 2x2 matrix
		//	Given the following 2x2 matrix A:
		let aText = """
		| 1|5|
		| -3 | 2 |
		"""
		// Then determinant(A) = 17
		cts = Matrix(string: aText)
		XCTAssertEqual(17, cts.determinant())
	}
	
	func test_submatrix() throws {
		// Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix
		// Given the following 3x3 matrix A:
		var aText = """
		| 1|5| 0|
		|-3|2| 7|
		| 0|6|-3|
		"""
		// Then submatrix(A, 0, 2) is the following 2x2 matrix:
		var subResultText = """
		| -3 | 2 |
		| 0|6|
		"""
		cts = Matrix(string: aText)
		var submatrix = Matrix(string: subResultText)
		XCTAssertEqual(submatrix, cts.submatrix(0, 2))
		
		//	Scenario: A submatrix of a 4x4 matrix is a 3x3 matrix
		//	Given the following 4x4 matrix A:
		aText = """
		|-6| 1| 1| 6|
		|-8| 5| 8| 6|
		|-1| 0| 8| 2|
		|-7| 1|-1| 1|
		"""
		// Then submatrix(A, 2, 1) is the following 3x3 matrix: |-6| 1|6|
		subResultText = """
		|-6| 1|6|
		|-8| 8|6|
		| -7 | -1 | 1 |
		"""
		cts = Matrix(string: aText)
		submatrix = Matrix(string: subResultText)
		XCTAssertEqual(submatrix, cts.submatrix(2, 1))
	}
	
	func test_CalculatingAminorof3x3Matrix() throws {
		//	Scenario: Calculating a minor of a 3x3 matrix
		//	Given the following 3x3 matrix A:
		let aText = """
		|3|5|0|
		| 2|-1|-7|
		| 6|-1| 5|
		"""
		//	And B ← submatrix(A, 1, 0)
		//	Then determinant(B) = 25
		//	And minor(A, 1, 0) = 25
		let aMat = Matrix(string: aText)
		let bMat = aMat.submatrix(1, 0)
		XCTAssertEqual(25, bMat.determinant())
		XCTAssertEqual(25, aMat.minor(1, 0))
	}
	
	func test_calcCofactorOf3x3Matrix() throws {
		// Scenario: Calculating a cofactor of a 3x3 matrix
		// Given the following 3x3 matrix A:
		let aText = """
		|3|5|0|
		| 2|-1|-7|
		| 6|-1| 5|
		"""
		//	Then minor(A, 0, 0) = -12
		//	And cofactor(A, 0, 0) = -12
		//	And minor(A, 1, 0) = 25
		//	And cofactor(A, 1, 0) = -25
		cts = Matrix(string: aText)
		XCTAssertEqual(-12, cts.minor(0, 0))
		XCTAssertEqual(-12, cts.cofactor(0, 0))
		XCTAssertEqual( 25, cts.minor(1, 0))
		XCTAssertEqual(-25, cts.cofactor(1, 0))
	}
	
	func test_determinants() throws {
		//	Scenario: Calculating the determinant of a 3x3 matrix
		//	Given the following 3x3 matrix A:
		var aText = """
		|1|2|6|
		|-5| 8|-4|
		|2|6|4|
		"""
		//	Then cofactor(A, 0, 0) = 56
		//	And cofactor(A, 0, 1) = 12
		//	And cofactor(A, 0, 2) = -46
		//	And determinant(A) = -196
		cts = Matrix(string: aText)
		XCTAssertEqual(12, cts.cofactor(0, 1))
		XCTAssertEqual(-46, cts.cofactor(0, 2))
		XCTAssertEqual(-196, cts.determinant())
		
		//	Scenario: Calculating the determinant of a 4x4 matrix
		//	Given the following 4x4 matrix A:
		aText = """
		|-2|-8| 3| 5|
		|-3| 1| 7| 3|
		| 1| 2|-9| 6|
		|-6| 7| 7|-9|
		"""
		//	Then cofactor(A, 0, 0) = 690
		//	And cofactor(A, 0, 1) = 447
		//	And cofactor(A, 0, 2) = 210
		//	And cofactor(A, 0, 3) = 51
		//	And determinant(A) = -4071
		cts = Matrix(string: aText)
		XCTAssertEqual(690, cts.cofactor(0, 0))
		XCTAssertEqual(447, cts.cofactor(0, 1))
		XCTAssertEqual(210, cts.cofactor(0, 2))
		XCTAssertEqual(51,  cts.cofactor(0, 3))
		XCTAssertEqual(-4071, cts.determinant())
	}
	
	func test_invertibility() throws {
		// Scenario: Testing an invertible matrix for invertibility
		// Given the following 4x4 matrix A:
		var aText = """
		|6|4|4|4|
		|5|5|7|6|
		| 4|-9| 3|-7|
		| 9| 1| 7|-6|
		"""
		// Then determinant(A) = -2120
		// And A is invertible
		cts = Matrix(string: aText)
		XCTAssertEqual(-2120, cts.determinant())
		XCTAssertTrue(cts.isInvertible)
		
		// Scenario: Testing a noninvertible matrix for invertibility
		// Given the following 4x4 matrix A:
		aText = """
		|-4| 2|-2|-3|
		|9|6|2|6|
		| 0|-5| 1|-5|
		|0|0|0|0|
		"""
		// Then determinant(A) = 0
		// And A is not invertible
		cts = Matrix(string: aText)
		XCTAssertEqual(0, cts.determinant())
		XCTAssertFalse(cts.isInvertible)
	}
	
	func test_inverse() throws {
		// Scenario: Calculating the inverse of a matrix
		// Given the following 4x4 matrix A:
		let aText = """
		|-5| 2| 6|-8|
		| 1|-5| 1| 8|
		| 7| 7|-6|-7|
		| 1|-3| 7| 4|
		"""
		let a = Matrix(string: aText)
		//	And B ← inverse(A)
		let b = a.inverse()
		//	Then determinant(A) = 532
		XCTAssertEqual(532, a.determinant())
		//	And cofactor(A, 2, 3) = -160
		XCTAssertEqual(-160, a.cofactor(2, 3))
		//	And B[3,2] = -160/532
		XCTAssertEqual(-160/532, b[3, 2])
		//	And cofactor(A, 3, 2) = 105
		XCTAssertEqual(105, a.cofactor(3, 2))
		//	And B[2,3] = 105/532
		XCTAssertEqual(105/532, b[2, 3])
		//	And B is the following 4x4 matrix:
		let bText = """
		| 0.21805 | 0.45113 | 0.24060 | -0.04511 |
		| -0.80827 | -1.45677 | -0.44361 | 0.52068 |
		| -0.07895 | -0.22368 | -0.05263 | 0.19737 |
		| -0.52256 | -0.81391 | -0.30075 | 0.30639 |
		"""
		XCTAssertEqual(Matrix(string: bText), b)
	}
	
	func test_inverseMoreExamples() throws {
		// Scenario: Calculating the inverse of another matrix
		// Given the following 4x4 matrix A:
		var aText = """
		| 8|-5| 9| 2|
		|7|5|6|1|
		|-6| 0| 9| 6|
		|-3| 0|-9|-4|
		"""
		// Then inverse(A) is the following 4x4 matrix:
		var aaText = """
		| -0.15385 | -0.15385 | -0.28205 | -0.53846 |
		| -0.07692 | 0.12308 | 0.02564 | 0.03077 |
		| 0.35897 | 0.35897 | 0.43590 | 0.92308 |
		| -0.69231 | -0.69231 | -0.76923 | -1.92308 |
		"""
		var a = Matrix(string: aText)
		var aa = Matrix(string: aaText)
		XCTAssertEqual(aa, a.inverse())
		// Scenario: Calculating the inverse of a third matrix
		// Given the following 4x4 matrix A:
		aText = """
		|9|3|0|9|
		| -5 | -2 | -6 | -3 |
		|-4| 9| 6| 4|
		|-7| 6| 6| 2|
		"""
		// Then inverse(A) is the following 4x4 matrix:
		aaText = """
		| -0.04074 | -0.07778 | 0.14444 | -0.22222 |
		| -0.07778 | 0.03333 | 0.36667 | -0.33333 |
		| -0.02901 | -0.14630 | -0.10926 | 0.12963 |
		| 0.17778 | 0.06667 | -0.26667 | 0.33333 |
		"""
		a = Matrix(string: aText)
		aa = Matrix(string: aaText)
		XCTAssertEqual(aa, a.inverse())
	}
	
	func test_multiplyingProductByItsInverse() throws {
		// Scenario: Multiplying a product by its inverse
		// Given the following 4x4 matrix A:
		let a = Matrix(string: """
		| 3|-9| 7| 3|
		| 3|-8| 2|-9|
		|-4| 4| 4| 1|
		|-6| 5|-1| 1|
		""")
		// And the following 4x4 matrix B: |
		let b = Matrix(string: """
		|8|2|2|2|
		| 3|-1| 7| 0|
		|7|0|5|4|
		| 6|-2| 0| 5|
		""")
		// And C ← A * B
		let c = a * b
		// Then C * inverse(B) = A
		XCTAssertEqual(a, c * b.inverse())
	}
	
	func test_identity() throws {
		XCTAssertNotNil(Matrix.identity)
		XCTAssertEqual(1, Matrix.identity[0,0])
		XCTAssertEqual(1, Matrix.identity[1,1])
		XCTAssertEqual(1, Matrix.identity[2,2])
		XCTAssertEqual(1, Matrix.identity[3,3])
		XCTAssertEqual(0, Matrix.identity[1,0])
		XCTAssertEqual(0, Matrix.identity[2,1])
		XCTAssertEqual(0, Matrix.identity[3,2])
		XCTAssertEqual(0, Matrix.identity[2,3])
	}

	// Not used
	func test_FloatFineCheck() throws {
		var shouldNotBeConsideredAsInt: Float = 1.0001
		var shouldBeConsideredAsInt: Float = 1.0000000000000001
		
		XCTAssertTrue(shouldBeConsideredAsInt.isInt)
		XCTAssertFalse(shouldNotBeConsideredAsInt.isInt)
		
		shouldNotBeConsideredAsInt = -1.0001
		shouldBeConsideredAsInt = -1.0000000000000001
		
		XCTAssertTrue(shouldBeConsideredAsInt.isInt)
		XCTAssertFalse(shouldNotBeConsideredAsInt.isInt)
		
		shouldNotBeConsideredAsInt = 3.9
		shouldBeConsideredAsInt = 4
		
		XCTAssertTrue(shouldBeConsideredAsInt.isInt)
		XCTAssertFalse(shouldNotBeConsideredAsInt.isInt)
		
		shouldNotBeConsideredAsInt = 3.1
		XCTAssertTrue(shouldBeConsideredAsInt.isInt)
	}
	
	
}
