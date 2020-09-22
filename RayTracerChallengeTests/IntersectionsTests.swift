//
//  IntersectionsTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/22.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class IntersectionsTests: XCTestCase {
	let s = Sphere()
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func test_itEncapsulatesTandObject() throws {
		let s = Sphere()
		let i = Intersection<Sphere>(3.5, s)
		XCTAssertEqual(3.5, i.t)
		XCTAssertEqual(s, i.object)
	}
	
	func test_itAggregates() throws {
		let s = Sphere()
		let i1 = Intersection<Sphere>(1, s)
		let i2 = Intersection<Sphere>(2, s)
		let xs = Intersection(i1, i2)
		XCTAssertEqual(2, xs.count)
		XCTAssertEqual(1, xs[0].t)
		XCTAssertEqual(2, xs[1].t)
	}
	
	func test_hit() throws {
		// Scenario: The hit, when all intersections have positive t
		var i1 = Intersection(1, s)
		var i2 = Intersection(1, s)
		var xs = Intersection(i2, i1)
		var i = xs.hit()
		XCTAssertEqual(i1, i)
		
		// Scenario: The hit, when some intersections have negative t
		i1 = Intersection(-1, s)
		i2 = Intersection(1, s)
		xs = Intersection(i2, i1)
		i = xs.hit()
		XCTAssertEqual(i2, i)
		
		// Scenario: The hit, when all intersections have negative t
		i1 = Intersection(-2, s)
		i2 = Intersection(-1, s)
		xs = Intersection(i2, i1)
		i = xs.hit()
		XCTAssertEqual(.none, i)
		
		// Scenario: The hit is always the lowest nonnegative intersection
		i1 = Intersection(5, s)
		i2 = Intersection(7, s)
		let i3 = Intersection(-3, s)
		let i4 = Intersection(2, s)
		xs = Intersection([i1, i2, i3, i4])
		i = xs.hit()
		XCTAssertEqual(i4, i)
	}
}
