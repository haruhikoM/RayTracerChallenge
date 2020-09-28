//
//  PlaneTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/28.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class PlaneTests: XCTestCase {
	var cts: Plane!

    override func setUpWithError() throws {
		cts = Plane()
    }

    override func tearDownWithError() throws {
		cts = nil
    }
	
	func test_normalIsConstantEverywhere() throws {
		//
		// The ray is coplanar with the plane,
		// which is to say *that the ray’s origin is on the plane*,
		//
		let n1 = cts.localNormal(cts, Point(0,0,0))
		let n2 = cts.localNormal(cts, Point(10,0,-10))
		let n3 = cts.localNormal(cts, Point(-5,0,150))
		XCTAssertEqual(n1, Vector(0,1,0))
		XCTAssertEqual(n2, Vector(0,1,0))
		XCTAssertEqual(n3, Vector(0,1,0))
	}
	
	func test_intersectWithARayParallelToThePlane() throws {
		// Scenario: Intersect with a ray parallel to the plane
		//	Given p ← plane()
		//	And r ← ray(point(0, 10, 0), vector(0, 0, 1))
		//	When xs ← local_intersect(p, r)
		//	Then xs is empty
		let r = Ray(Point(0,10,0), Vector(0, 0, 1))
		let xs = cts.localIntersect(cts, r)
		XCTAssertTrue(xs == .none)
	}
	
	func test_intersectWithACoplanarRay() throws {
		// Scenario: Intersect with a coplanar ray
		//	Given p ← plane()
		//	And r ← ray(point(0, 0, 0), vector(0, 0, 1))
		//	When xs ← local_intersect(p, r)
		//	Then xs is empty
		let r = Ray(Point(0,0,0), Vector(0, 0, 1))
		let xs = cts.localIntersect(cts, r)
		XCTAssertTrue(xs == .none)
	}
	
	func test_rayIntersecting() throws {
		// from above
		var r = Ray(Point(0,1,0), Vector(0, -1, 0))
		var xs = cts.localIntersect(cts, r)
		XCTAssertEqual(xs.count, 1)
		XCTAssertEqual(xs[0].t, 1)
		XCTAssertEqual(xs[0].object, cts)
		
		// from below
		r = Ray(Point(0, -1, 0), Vector(0, 1, 0))
		xs = cts.localIntersect(cts, r)
		XCTAssertEqual(xs.count, 1)
		XCTAssertEqual(xs[0].t, 1)
		XCTAssertEqual(xs[0].object, cts)
	}
}
