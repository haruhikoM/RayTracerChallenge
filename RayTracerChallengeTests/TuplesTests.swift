//
//  TuplesTests.swift
//  RayTracerChallengeTests
//
//  Created by Minamiguchi Haruhiko on 2020/09/15.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class TuplesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func test_Point_Tuple() throws {
		/*
		Scenario: A tuple with w=1.0 is a point
		Given a ← tuple(4.3, -4.2, 3.1, 1.0)
		Then a.x = 4.3
		And a.y = -4.2
		And a.z = 3.1
		And a.w = 1.0
		And a is a point
		And a is not a vector
		*/
		
		let a = Tuple(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
		XCTAssertEqual(4.3, a.x)
		XCTAssertEqual(-4.2, a.y)
		XCTAssertEqual(3.1, a.z)
		XCTAssertEqual(1.0, a.w)
		XCTAssertTrue(a.type == .point)
		XCTAssertFalse(a.type == .vector)
	}
	
	func test_Vector_Tuple() throws {
		/*
		Scenario: A tuple with w=0 is a vector
		Given a ← tuple(4.3, -4.2, 3.1, 0.0)
		Then a.x = 4.3
		And a.y = -4.2
		And a.z = 3.1
		And a.w = 0.0
		And a is not a point And a is a vector
		*/
		let a = Tuple(x: 4.3, y: -4.2, z: 3.1, w: 0.0)
		XCTAssertEqual(4.3, a.x)
		XCTAssertEqual(-4.2, a.y)
		XCTAssertEqual(3.1, a.z)
		XCTAssertEqual(0.0, a.w)
		XCTAssertFalse(a.type == .point)
		XCTAssertTrue(a.type == .vector)
	}
	
	
	func test_initializePoint_FactoryMethod() throws {
		//	Scenario: point() creates tuples with w=1
		//  Given p ← point(4, -4, 3)
		//	Then p = tuple(4, -4, 3, 1)
		
		let p = Point(x: 4, y: -4, z: 3)
		let t = Tuple(x: 4, y: -4, z: 3, w: 1.0)
		XCTAssertTrue(t.type == .point)
		XCTAssertEqual(t, p)
	}
	
	func test_initializeVector_FactoryMethod() throws {
		//	Scenario: vector() creates tuples with w=0
		//  Given v ← vector(4, -4, 3)
		//	Then v = tuple(4, -4, 3, 0)
		let p = Vector(x: 4, y: -4, z: 3)
		let t = Tuple(x: 4, y: -4, z: 3, w: 0.0)
		XCTAssertTrue(t.type == .vector)
		XCTAssertEqual(t, p)
	}
	
	/// Float comaprison
	func test_ComparingFloat() throws {
		let EPSILON: Float = 0.00001
		
		func equal(a: Float, b: Float) -> Bool {
			if abs(a-b) < EPSILON {
				return true
			}
			return false
		}
		
		let f1: Float = 33
		let f2: Float = 7
		let v1 = f1/f2
		let v2 = f1/f2
		
		XCTAssertTrue(equal(a: v1, b: v2))
	}
	
	func test_addingTwoTuples() throws {
		// Scenario: Adding two tuples
		// Given a1 ← tuple(3, -2, 5, 1)
		// And a2 ← tuple(-2, 3, 1, 0)
		// Then a1 + a2 = tuple(1, 1, 6, 1)
		let a1 = Tuple(x: 3, y: -2, z: 5, w: 1)
		let a2 = Tuple(x: -2, y: 3, z: 1, w: 0)
		let a3 = Tuple(x: 1, y: 1, z: 6, w: 1)
		XCTAssertEqual(a3, a1 + a2)
	}
	
	func test_subtractingPointFromPoint() throws {
		// Scenario: Subtracting two points
		// Given p1 ← point(3, 2, 1)
		// And p2 ← point(5, 6, 7)
		// Then p1 - p2 = vector(-2, -4, -6)
		let p1 = Point(x: 3, y: 2, z: 1)
		let p2 = Point(x: 5, y: 6, z: 7)
		let exp = Vector(x: -2, y: -4, z: -6)
		XCTAssertEqual(exp, p1 - p2)
	}
	
	func test_subtractingVectorFromPoint() throws {
		// Scenario: Subtracting a vector from a point
		// Given p ← point(3, 2, 1)
		// And v ← vector(5, 6, 7)
		// Then p - v = point(-2, -4, -6)
		let p = Point(x: 3, y: 2, z: 1)
		let v = Vector(x: 5, y: 6, z: 7)
		let exp = Point(x: -2, y: -4, z: -6)
		XCTAssertEqual(exp, p - v)
	}
	
	func test_subtractingTwoVectors() throws {
		//	Scenario: Subtracting two vectors
		//	Given v1 ← vector(3, 2, 1)
		//	And v2 ← vector(5, 6, 7)
		//	Then v1 - v2 = vector(-2, -4, -6)
		let v1 = Vector(x: 3, y: 2, z: 1)
		let v2 = Vector(x: 5, y: 6, z: 7)
		let exp = Vector(x: -2, y: -4, z: -6)
		XCTAssertEqual(exp, v1 - v2)
	}
	
	func test_subtractingVectorFromZeroVectorGivenZero() throws {
		//	Scenario: Subtracting a vector from the zero vector
		//	Given zero ← vector(0, 0, 0)
		//	And v ← vector(1, -2, 3)
		//	Then zero - v = vector(-1, 2, -3)
		let zero = Vector(x: 0, y: 0, z: 0)
		let v = Vector(x: 1, y: -2, z: 3)
		let exp = Vector(x: -1, y: 2, z: -3)
		XCTAssertEqual(exp, zero - v)
	}
	
	func test_negatingTuple() throws {
		//	Scenario: Negating a tuple
		//	Given a ← tuple(1, -2, 3, -4)
		//	Then -a = tuple(-1, 2, -3, 4)
		let a = Tuple(x: 1, y: -2, z: 3, w: -4)
		XCTAssertEqual(Tuple(x: -1, y: 2, z: -3, w: 4), -a)
	}
	
	func test_multiplying() throws {
		//	Scenario: Multiplying a tuple by a scalar
		//	Given a ← tuple(1, -2, 3, -4)
		//	Then a * 3.5 = tuple(3.5, -7, 10.5, -14)
		let a = Tuple(x: 1, y: -2, z: 3, w: -4)
		XCTAssertEqual(Tuple(x: 3.5, y: -7, z: 10.5, w: -14), a * 3.5)
		
		//	Scenario: Multiplying a tuple by a fraction
		//	Given a ← tuple(1, -2, 3, -4)
		//	Then a * 0.5 = tuple(0.5, -1, 1.5, -2)
		XCTAssertEqual(Tuple(x: 0.5, y: -1, z: 1.5, w: -2), a * 0.5)
	}
	
	func test_DividedByScalar() throws {
		//	Scenario: Dividing a tuple by a scalar
		//	Given a ← tuple(1, -2, 3, -4)
		//	Then a / 2 = tuple(0.5, -1, 1.5, -2)
		let a = Tuple(x: 1, y: -2, z: 3, w: -4)
		XCTAssertEqual(Tuple(x: 0.5, y: -1, z: 1.5, w: -2), a / 2)
	}
	
	func test_computingMagnitudeOfVector() throws {
		//	Scenario: Computing the magnitude of vector(1, 0, 0)
		//	Given v ← vector(1, 0, 0)
		//	Then magnitude(v) = 1
		var v = Vector(x: 1, y: 0, z: 0)
		XCTAssertEqual(1, v.magnitude)
		
		//	Scenario: Computing the magnitude of vector(0, 1, 0)
		//	Given v ← vector(0, 1, 0)
		//	Then magnitude(v) = 1
		v = Vector(x: 0, y: 1, z: 0)
		XCTAssertEqual(1, v.magnitude)
		
		//	Scenario: Computing the magnitude of vector(0, 0, 1)
		//	Given v ← vector(0, 0, 1)
		//	Then magnitude(v) = 1
		v = Vector(x: 0, y: 0, z: 1)
		XCTAssertEqual(1, v.magnitude)
		
		//	Scenario: Computing the magnitude of vector(1, 2, 3)
		//	Given v ← vector(1, 2, 3)
		//	Then magnitude(v) = √14
		v = Vector(x: 1, y: 2, z: 3)
		XCTAssertEqual(sqrt(14), v.magnitude)
		
		//	Scenario: Computing the magnitude of vector(-1, -2, -3)
		//	Given v ← vector(-1, -2, -3)
		//	Then magnitude(v) = √14
		v = Vector(x: -1, y: -2, z: -3)
		XCTAssertEqual(sqrt(14), v.magnitude)
	}
	
	func test_normalizing() throws {
		//	Scenario: Normalizing vector(4, 0, 0) gives (1, 0, 0)
		//	Given v ← vector(4, 0, 0)
		//	Then normalize(v) = vector(1, 0, 0)
		var v = Vector(x: 4, y: 0, z: 0)
		v.normalized()
		XCTAssertEqual(Vector(x: 1, y: 0, z: 0), v)
		
		//	Scenario: Normalizing vector(1, 2, 3)
		//	Given v ← vector(1, 2, 3)
		//	Then normalize(v) = approximately vector(0.26726, 0.53452, 0.80178)
		v = Vector(x: 1, y: 2, z: 3)
		v.normalized()
		XCTAssertEqual(Vector(x: 0.26726, y: 0.53452, z: 0.80178), v)
		
		//	Scenario: The magnitude of a normalized vector
		// Given v ← vector(1, 2, 3)
		//	When norm ← normalize(v)
		//	Then magnitude(norm) = 1
		v = Vector(x: 1, y: 2, z: 3)
		v.normalized()
		XCTAssertTrue(Float(1).isEqual(to: v.magnitude))
		XCTAssertTrue(1 === v.magnitude)
	}
}
