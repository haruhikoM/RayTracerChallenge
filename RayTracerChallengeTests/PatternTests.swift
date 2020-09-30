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
	var cts: RayTracerChallenge.Pattern!

    override func setUpWithError() throws {
		cts = Pattern.stripe(.white, .black)
    }

    override func tearDownWithError() throws {
		cts = nil
    }
	
	func test_stripePattern() throws {
		// is constant in Y
		XCTAssertEqual(cts.stripe(at: Point(0,0,0)), .white)
		XCTAssertEqual(cts.stripe(at: Point(0,1,0)), .white)
		XCTAssertEqual(cts.stripe(at: Point(0,2,0)), .white)
		
		// is constant in Z
		XCTAssertEqual(cts.stripe(at: Point(0,0,0)), .white)
		XCTAssertEqual(cts.stripe(at: Point(0,0,1)), .white)
		XCTAssertEqual(cts.stripe(at: Point(0,0,2)), .white)
		
		// is alternates in X
		XCTAssertEqual(cts.stripe(at: Point(0,0,0)),   .white)
		XCTAssertEqual(cts.stripe(at: Point(0.9,0,0)), .white)
		XCTAssertEqual(cts.stripe(at: Point(1,0,0)),   .black)
		XCTAssertEqual(cts.stripe(at: Point(-0.1,0,0)),.black)
		XCTAssertEqual(cts.stripe(at: Point(-1,0,0)),  .black)
		XCTAssertEqual(cts.stripe(at: Point(-1.1,0,0)),.white)
	}
	
	func test_withTransformation() throws {
		// with object transformation
		var object = Sphere()
		object.transform = Matrix.scaling(2, 2, 2)
		var c = cts.stripe(of: object, at: Point(1.5, 0, 0))
		XCTAssertEqual(c, .white)
		
		// with pattern transformation
		object = Sphere()
		cts.transform = Matrix.scaling(2, 2, 2)
		c = cts.stripe(of: object, at: Point(1.5, 0, 0))
		XCTAssertEqual(c, .white)
		
		// both object and pattern transformation
		object = Sphere()
		object.transform = Matrix.scaling(2, 2, 2)
		cts.transform    = Matrix.translation(0.5, 0, 0)
		c = cts.stripe(of: object, at: Point(2.5, 0, 0))
		XCTAssertEqual(c, .white)
	}
	
	func test_defaultTransformation() throws {
		let pattern = Pattern._test
		XCTAssertEqual(pattern.transform, Matrix.identity)
	}
	
	func test_assignTransformation() throws {
		var pattern = Pattern._test
		pattern.transform = Matrix.translation(1, 2, 3)
		XCTAssertEqual(pattern.transform, Matrix.translation(1, 2, 3))
	}
	
	// pattern_at_shape
	func test_withAnObjectTransformation() throws {
		let s = Sphere()
		s.transform = Matrix.scaling(2, 2, 2)
		let testPattern = Pattern._test
		let c = s.pattern(of: testPattern, at: Point(2,3,4))
		XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
	}
	
	func test_withAnObjectTransformation() throws {
		let s = Sphere()
		var testPattern = Pattern._test
		testPattern.transform = Matrix.scaling(2, 2, 2)
		let c = s.pattern(of: testPattern, at: Point(2,3,4))
		XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
	}

}
