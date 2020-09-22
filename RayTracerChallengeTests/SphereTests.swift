//
//  SphereTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class SphereTests: XCTestCase {
	var cts: Sphere!
    override func setUpWithError() throws {
		cts = Sphere()
	}

    override func tearDownWithError() throws {
		cts = nil
	}
	
	func test_rayIntersectsAtTwoPoints() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		let xs = r.intersects(cts)
		XCTAssertEqual(2, xs.count)
//		XCTAssertNotEqual(xs[0], xs[1])
		XCTAssertEqual(4.0, xs[0].t)
		XCTAssertEqual(6.0, xs[1].t)
	}
	
	func test_shouldBeIdentifiable() throws {
		let s1 = Sphere()
		let s2 = Sphere()
		XCTAssertNotEqual(cts, s1)
		XCTAssertNotEqual(cts, s2)
		XCTAssertNotEqual(s1, s2)
	}
	
	func test_intersectSphereAtTangent() throws {
		let r = Ray(Point(0,1,-5), Vector(0,0,1))
		let xs = r.intersects(cts)
		XCTAssertEqual(2, xs.count)
		XCTAssertEqual(5.0, xs[0].t)
		XCTAssertEqual(5.0, xs[1].t)
	}
	
	func test_intersectSphereAtZeroPoint() throws {
		let r = Ray(Point(0,2,-5), Vector(0,0,1))
		let xs = r.intersects(cts)
		XCTAssertEqual(0, xs.count)
	}
	
	func test_rayOriginatesInsideSphere() throws {
		let r = Ray(Point(0,0,0), Vector(0,0,1))
		let xs = r.intersects(cts)
		XCTAssertEqual(2, xs.count)
		XCTAssertEqual(-1.0, xs[0].t)
		XCTAssertEqual( 1.0, xs[1].t)
	}
	
	func test_whenRayIsAhead() throws {
		let r = Ray(Point(0,0,5), Vector(0,0,1))
		let xs = r.intersects(cts)
		XCTAssertEqual(2, xs.count)
		XCTAssertEqual(-6.0, xs[0].t)
		XCTAssertEqual(-4.0, xs[1].t)
	}
	
	func test_interset_s_SetsObjectOnIntersection() throws {
		//	Scenario: Intersect sets the object on the intersection
		//	Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
		//	And s ← sphere()
		//	When xs ← intersect(s, r) Then xs.count = 2
		//	And xs[0].object = s And xs[1].object = s
		let r = Ray(Point(0, 0, -5), Vector(0, 0, 1))
		let xs = r.intersects(cts)
		XCTAssertEqual(2, xs.count)
		XCTAssertEqual(cts, xs[0].object)
		XCTAssertEqual(cts, xs[1].object)
	}
}
