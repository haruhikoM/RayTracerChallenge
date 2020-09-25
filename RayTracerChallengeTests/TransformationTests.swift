//
//  TransformationTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/20.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class TransformationTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
	}
	
	func test_translation() throws {
		//	Scenario: Multiplying by a translation matrix
		//	Given transform ← translation(5, -3, 2)
		//	And p ← point(-3, 4, 5)
		//	Then transform * p = point(2, 1, 7)
		var transform = Matrix.translation(5, -3, 2)
		let p = Point(x: -3, y: 4, z: 5)
		XCTAssertEqual(Point(x: 2, y: 1, z: 7), transform*p)
		
		//	Scenario: Multiplying by the inverse of a translation matrix
		//	Given transform ← translation(5, -3, 2)
		//	And inv ← inverse(transform)
		//	And p ← point(-3, 4, 5)
		//	Then inv * p = point(-8, 7, 3)
		transform = Matrix.translation(5, -3, 2)
		let inverse = transform.inverse()
		XCTAssertEqual(Point(x: -8, y: 7, z: 3), inverse*p)
		
		//	Scenario: Translation does not affect vectors
		//	Given transform ← translation(5, -3, 2)
		//	And v ← vector(-3, 4, 5)
		//	Then transform * v = v
		let v = Vector(x: -3, y: 4, z: 5)
		XCTAssertEqual(v, transform*v)
	}
	
	func test_scaling() throws {
		//	Scenario: A scaling matrix applied to a point
		//	Given transform ← scaling(2, 3, 4)
		//	And p ← point(-4, 6, 8)
		//	Then transform * p = point(-8, 18, 32)
		let transform = Matrix.scaling(2, 3, 4)
		let p = Point(x: -4, y: 6, z: 8)
		XCTAssertEqual(Point(x: -8, y: 18, z: 32), transform*p)
		
		//	Scenario: A scaling matrix applied to a vector
		//	Given transform ← scaling(2, 3, 4)
		//	And v ← vector(-4, 6, 8)
		//	Then transform * v = vector(-8, 18, 32)
		let v = Vector(x: -4, y: 6, z: 8)
		XCTAssertEqual(Vector(x: -8, y: 18, z: 32), transform*v)
		
		//	Scenario: Multiplying by the inverse of a scaling matrix
		//	Given transform ← scaling(2, 3, 4)
		//	And inv ← inverse(transform)
		//	And v ← vector(-4, 6, 8)
		//	Then inv * v = vector(-2, 2, 2)
		let inverse = transform.inverse()
		XCTAssertEqual(Vector(x: -2, y: 2, z: 2), inverse*v)
	}
	
	func test_reflectionIsScalingByNegativeValue() throws {
		//	Scenario: Reflection is scaling by a negative value
		//	Given transform ← scaling(-1, 1, 1)
		//	And p ← point(2, 3, 4)
		//	Then transform * p = point(-2, 3, 4)
		let transform = Matrix.scaling(-1, 1, 1)
		let p = Point(x: 2, y: 3, z: 4)
		XCTAssertEqual(Point(x: -2, y: 3, z: 4), transform*p)
	}
	
	func test_rotationByXAxis() throws {
		//	​​Scenario​: Rotating a point around the x axis
		//	​Given​ p ← point(0, 1, 0)
		//	​And​ half_quarter ← rotation_x(π / 4)
		//	​And​ full_quarter ← rotation_x(π / 2)
		//	​Then​ half_quarter * p = point(0, √2/2, √2/2)
		//	​And​ full_quarter * p = point(0, 0, 1)
		let p = Point(x: 0, y: 1, z: 0)
		let halfQuarter = Matrix.rotation(by: .x, radians: Double.pi/4)
		let fullQuarter = Matrix.rotation(by: .x, radians: Double.pi/2)
		XCTAssertEqual(halfQuarter * p, Point(x: 0, y: sqrt(2)/2, z: sqrt(2)/2))
		XCTAssertEqual(fullQuarter * p, Point(x: 0, y: 0, z: 1))
	}
	
	func test_rotationByYAxis() throws {
		// P.49
		let p = Point(x: 0, y: 0, z: 1)
		let halfQuarter = Matrix.rotation(by: .y, radians: Double.pi/4)
		let fullQuarter = Matrix.rotation(by: .y, radians: Double.pi/2)
		XCTAssertEqual(halfQuarter * p, Point(x: sqrt(2)/2, y: 0, z: sqrt(2)/2))
		XCTAssertEqual(fullQuarter * p, Point(x: 1, y: 0, z: 0))
	}

	func test_rotationByZAxis() throws {
		// P.50
		let p = Point(x: 0, y: 1, z: 0)
		let halfQuarter = Matrix.rotation(by: .z, radians: Double.pi/4)
		let fullQuarter = Matrix.rotation(by: .z, radians: Double.pi/2)
		XCTAssertEqual(halfQuarter * p, Point(x: -sqrt(2)/2, y: sqrt(2)/2, z: 0))
		XCTAssertEqual(fullQuarter * p, Point(x: -1, y: 0, z: 0))
	}

	func test_shearing() throws {
		/*
		Scenario​: A shearing transformation moves x in proportion to y
		​ 	  ​Given​ transform ← shearing(1, 0, 0, 0, 0, 0)
		​ 	    ​And​ p ← point(2, 3, 4)
		​ 	  ​Then​ transform * p = point(5, 3, 4)
		The remaining tests work similarly, adding the two components together to get the new component value.*/
		var transform = Matrix.shearing(1, 0, 0, 0, 0, 0)
		let p = Point(x: 2, y: 3, z: 4)
		XCTAssertEqual(Point(x: 5, y: 3, z: 4), transform*p)
		/*
		features/transformations.feature
		​ 	​Scenario​: A shearing transformation moves x in proportion to z
		​ 	  ​Given​ transform ← shearing(0, 1, 0, 0, 0, 0)
		​ 	    ​And​ p ← point(2, 3, 4)
		​ 	  ​Then​ transform * p = point(6, 3, 4)*/
		transform = Matrix.shearing(0, 1, 0, 0, 0, 0)
		XCTAssertEqual(Point(x: 6, y: 3, z: 4), transform*p)
		/*
		​ 	​Scenario​: A shearing transformation moves y in proportion to x
		​ 	  ​Given​ transform ← shearing(0, 0, 1, 0, 0, 0)
		​ 	    ​And​ p ← point(2, 3, 4)
		​ 	  ​Then​ transform * p = point(2, 5, 4)
		​ 	
		​ 	​Scenario​: A shearing transformation moves y in proportion to z
		​ 	  ​Given​ transform ← shearing(0, 0, 0, 1, 0, 0)
		​ 	    ​And​ p ← point(2, 3, 4)
		​ 	  ​Then​ transform * p = point(2, 7, 4)
		​ 	
		​ 	​Scenario​: A shearing transformation moves z in proportion to x
		​ 	  ​Given​ transform ← shearing(0, 0, 0, 0, 1, 0)
		​ 	    ​And​ p ← point(2, 3, 4)
		​ 	  ​Then​ transform * p = point(2, 3, 6)
		​ 	​Scenario​: A shearing transformation moves z in proportion to y
		​ 	  ​Given​ transform ← shearing(0, 0, 0, 0, 0, 1)
		​ 	    ​And​ p[…]
		*/
		transform = Matrix.shearing(0, 0, 1, 0, 0, 0)
		XCTAssertEqual(Point(x: 2, y: 5, z: 4), transform*p)
		
		transform = Matrix.shearing(0, 0, 0, 1, 0, 0)
		XCTAssertEqual(Point(x: 2, y: 7, z: 4), transform*p)
		
		transform = Matrix.shearing(0, 0, 0, 0, 1, 0)
		XCTAssertEqual(Point(x: 2, y: 3, z: 6), transform*p)
		
		transform = Matrix.shearing(0, 0, 0, 0, 0, 1)
		XCTAssertEqual(Point(x: 2, y: 3, z: 7), transform*p)
	}
	
	func test_chaining() throws {
		/*“Scenario​: Individual transformations are applied in sequence
		​ 	  ​Given​ p ← point(1, 0, 1)
		​ 	    ​And​ A ← rotation_x(π / 2)
		​ 	    ​And​ B ← scaling(5, 5, 5)
		​ 	    ​And​ C ← translation(10, 5, 7)
		​ 	  ​# apply rotation first
		​ 	  ​When​ p2 ← A * p
		​ 	  ​Then​ p2 = point(1, -1, 0)
		​ 	  ​# then apply scaling
		​ 	  ​When​ p3 ← B * p2
		​ 	  ​Then​ p3 = point(5, -5, 0)
		​ 	  ​# then apply translation
		​ 	  ​When​ p4 ← C * p3
		​ 	  ​Then​ p4 = point(15, 0, 7)
		​ 	
		​ 	​Scenario​: Chained transformations must be applied in reverse order
		​ 	  ​Given​ p ← point(1, 0, 1)
		​ 	    ​And​ A ← rotation_x(π / 2)
		​ 	    ​And​ B ← scaling(5, 5, 5)
		​ 	    ​And​ C ← translation(10, 5, 7)
		​ 	  ​When​ T ← C * B * A
		​ 	  ​Then​ T * p = point(15, 0, 7)*/
		var p = Point(x: 1, y: 0, z:1)
		var A = Matrix.rotation(by: .x, radians: Double.pi/2)
		
		let B = Matrix.scaling(5, 5, 5)
		let C = Matrix.translation(10, 5, 7)
		
		let p2 = A * p
		XCTAssertEqual(p2, Point(x: 1, y: -1, z: 0))
		
		let p3 = B * p2
		XCTAssertEqual(p3, Point(x: 5, y: -5, z: 0))
		
		let p4 = C * p3
		XCTAssertEqual(p4, Point(x: 15, y: 0, z: 7))
		
		
		p = Point(x: 1, y: 0, z: 1)
		A = Matrix.rotation(by: .x, radians: Double.pi/2)
		
		let T = C * B * A
		XCTAssertEqual(T * p, Point(15, 0, 7))
	
		
		// FLUENT API TEST
		let transform = Matrix.identity
			.rotate(by: .x, radians: Double.pi/2)
			.scale(5, 5, 5)
			.translate(10, 5, 7)
		
		XCTAssertNotNil(transform)
	}
	
	//MARK: - Chapter 7 : ViewTransform
	func test_transformationMatrixForDefaultOrientation() throws {
		let from = Point(0,0,0)
		let to = Point(0,0,-1)
		let up = Vector(0,1,0)
		let t = Transform.view(from, to, up)
		XCTAssertEqual(t, Matrix.identity)
	}
	
	func test_transformationMatrixLookInPositiveZ() throws {
		let from = Point(0,0,0)
		let to = Point(0,0,1)
		let up = Vector(0,1,0)
		let t = Transform.view(from, to, up)
		XCTAssertEqual(t, Matrix.scaling(-1, 1, -1))
	}
	
	func test_ViewTransformMoveWorld() throws {
		let from = Point(0,0,8)
		let to = Point(0,0,0)
		let up = Vector(0,1,0)
		let t = Transform.view(from, to, up)
		XCTAssertEqual(t, Matrix.translation(0, 0, -8))
	}
	
	func test_arbitraryViewTransformation() throws {
		let from = Point(1,3,2)
		let to = Point(4,-2,8)
		let up = Vector(1,1,0)
		let t = Transform.view(from, to, up)
		
		let mat = Matrix(string: """
		| -0.50709 | 0.50709 |  0.67612 | -2.36643 |
		|  0.76772 | 0.60609 |  0.12122 | -2.82843 |
		| -0.35857 | 0.59761 | -0.71714 |  0.00000 |
		|  0.00000 | 0.00000 |  0.00000 |  1.00000 |
		""")
		
		XCTAssertEqual(mat, t)
	}
}
