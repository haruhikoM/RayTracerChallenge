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
