//
//  PatternTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/28.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class PatternTests: XCTestCase {
	var cts: TestPattern!

    override func setUpWithError() throws {
		cts = TestPattern(.white, .black)
    }

    override func tearDownWithError() throws {
		cts = nil
    }
	
	func test_StripePattern() throws {
		// is constant in Y
		let stripe = Stripe(.white, .black)
		XCTAssertEqual(stripe.pattern(at: Point(0,0,0)), .white)
		XCTAssertEqual(stripe.pattern(at: Point(0,1,0)), .white)
		XCTAssertEqual(stripe.pattern(at: Point(0,2,0)), .white)
		
		// is constant in Z
		XCTAssertEqual(stripe.pattern(at: Point(0,0,0)), .white)
		XCTAssertEqual(stripe.pattern(at: Point(0,0,1)), .white)
		XCTAssertEqual(stripe.pattern(at: Point(0,0,2)), .white)
		
		// is alternates in X
		XCTAssertEqual(stripe.pattern(at: Point(0,0,0)),   .white)
		XCTAssertEqual(stripe.pattern(at: Point(0.9,0,0)), .white)
		XCTAssertEqual(stripe.pattern(at: Point(1,0,0)),   .black)
		XCTAssertEqual(stripe.pattern(at: Point(-0.1,0,0)),.black)
		XCTAssertEqual(stripe.pattern(at: Point(-1,0,0)),  .black)
		XCTAssertEqual(stripe.pattern(at: Point(-1.1,0,0)),.white)
	}
	
	func test_withTransformation() throws {
		// with object transformation
		var object = Sphere()
		var stripe = Stripe(.white, .black)
		object.transform = Matrix.scaling(2, 2, 2)
		var c = stripe.pattern(of: object, at: Point(1.5, 0, 0))
		XCTAssertEqual(c, .white)
		
		// with pattern transformation
		object = Sphere()
		stripe.transform = Matrix.scaling(2, 2, 2)
		c = stripe.pattern(of: object, at: Point(1.5, 0, 0))
		XCTAssertEqual(c, .white)
		
		// both object and pattern transformation
		object = Sphere()
		object.transform = Matrix.scaling(2, 2, 2)
		stripe.transform    = Matrix.translation(0.5, 0, 0)
		c = stripe.pattern(of: object, at: Point(2.5, 0, 0))
		XCTAssertEqual(c, .white)
	}
	
	func test_defaultTransformation() throws {
		let pattern = TestPattern._test
		XCTAssertEqual(pattern.transform, Matrix.identity)
	}
	
	func test_assignTransformation() throws {
		var pattern = TestPattern._test
		pattern.transform = Matrix.translation(1, 2, 3)
		XCTAssertEqual(pattern.transform, Matrix.translation(1, 2, 3))
	}
	
	// pattern_at_shape
	func test_withAnObjectTransformation() throws {
		let s = Sphere()
		s.transform = Matrix.scaling(2, 2, 2)
		let testPattern = TestPattern._test
		let c = testPattern.pattern(of: s, at: Point(2,3,4))
		XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
	}
	
	func test_withAnPatternTransformation() throws {
		let s = Sphere()
		var testPattern = TestPattern._test
		testPattern.transform = Matrix.scaling(2, 2, 2)
		let c = testPattern.pattern(of: s, at: Point(2,3,4))
		XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
	}
	
	func test_withBothPatternAndObjectTransformation() throws {
		let s = Sphere()
		s.transform = Matrix.scaling(2, 2, 2)
		var testPattern = TestPattern._test
		testPattern.transform = Matrix.translation(0.5, 1, 1.5)
		let c = testPattern.pattern(of: s, at: Point(2.5,3,3.5))
		XCTAssertEqual(c, Color(r: 0.75, g: 0.5, b: 0.25))
	}
	
	// Gradient
	func test_gradientLinearlyInterpolatesBetweenColors() throws {
		let pattern = Gradient(.white, .black)
		XCTAssertEqual(pattern.pattern(at: Point(0,0,0)), .white)
	}
	
	// Ring
	func test_ringShouldExtendInBothXandZ() throws {
		let p = Ring(.white, .black)
		XCTAssertEqual(p.pattern(at: Point(0,0,0)), .white)
		XCTAssertEqual(p.pattern(at: Point(1,0,0)), .black)
		XCTAssertEqual(p.pattern(at: Point(0,0,1)), .black)
		XCTAssertEqual(p.pattern(at: Point(0.708,0,0.708)), .black)
	}
	
	// Checker
	func test_CheckersShouldRepatInX() throws {
		let p = Checker(.white, .black)
		XCTAssertEqual(p.pattern(at: Point(0,0,0)), .white)
		XCTAssertEqual(p.pattern(at: Point(0.99,0,0)), .white)
		XCTAssertEqual(p.pattern(at: Point(1.01,0,0)), .black)
	}
	
	func test_CheckersShouldRepatInY() throws {
		let p = Checker(.white, .black)
		XCTAssertEqual(p.pattern(at: Point(0,0,0)), .white)
		XCTAssertEqual(p.pattern(at: Point(0, 0.99,0)), .white)
		XCTAssertEqual(p.pattern(at: Point(0, 1.01,0)), .black)
	}
	
	func test_CheckersShouldRepatInZ() throws {
		let p = Checker(.white, .black)
		XCTAssertEqual(p.pattern(at: Point(0,0,0)), .white)
		XCTAssertEqual(p.pattern(at: Point(0,0,0.99)), .white)
		XCTAssertEqual(p.pattern(at: Point(0,0,1.01)), .black)
	}
}
