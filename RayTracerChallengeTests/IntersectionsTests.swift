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
		xs = Intersection(i1, i2, i3, i4)
		i = xs.hit()
		XCTAssertEqual(i4, i)
	}
	
	// Chap7
	func test_precomputingTheState() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		let shape = Sphere()
		let i = Intersection<Shape>(4, shape)
		guard let comps = Computation.prepare(i,r) else { XCTFail(); return }
		XCTAssertEqual(comps.t, i.t)
		XCTAssertEqual(comps.object, i.object)
		XCTAssertEqual(comps.point , Point(0, 0, -1))
		XCTAssertEqual(comps.eyeVector, Vector(0, 0, -1))
		XCTAssertEqual(comps.normalVector, Vector(0, 0, -1))
	}
	
	func test_hitOccursOnTheOutside() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		let shape = Sphere()
		let i = Intersection<Shape>(4, shape)
		guard let comps = Computation.prepare(i,r) else { XCTFail(); return }
		XCTAssertEqual(comps.inside, false)
	}
	
	func test_hitOccursOnTheInside() throws {
		let r = Ray(Point(0,0,0), Vector(0,0,1))
		let shape = Sphere()
		let i = Intersection<Shape>(1, shape)
		guard let comps = Computation.prepare(i,r) else { XCTFail(); return }
		XCTAssertEqual(comps.inside, true)
		XCTAssertEqual(comps.point , Point(0, 0, 1))
		XCTAssertEqual(comps.eyeVector, Vector(0, 0, -1))
		XCTAssertEqual(comps.normalVector, Vector(0, 0, -1))
	}
	
	// Chapter 8
	func test_hitShouldOffsetPoint() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		let shape = Sphere()
		shape.transform = Matrix.translation(0, 0, 1)
		let i = Intersection<Shape>(5, shape)
		guard let comps = Computation.prepare(i, r) else { XCTFail(); return }
		XCTAssertTrue(comps.overPoint.z < -Double.epsilon/2)
		XCTAssertTrue(comps.point.z > comps.overPoint.z)
	}
	
	// Chapter 11 - Transparency & Refraction
	func test_findingN1andN2atVariousIntersections() throws {
		let A = Sphere.glassy
		A.transform = Matrix.scaling(2, 2, 2)
		A.material.refractiveIndex = 1.5
		
		let B = Sphere.glassy
		B.transform = Matrix.translation(0, 0, -0.25)
		B.material.refractiveIndex = 2.0
		
		let C = Sphere.glassy
		C.transform = Matrix.translation(0, 0, 0.25)
		C.material.refractiveIndex = 2.5
		
		let r = Ray(Point(0,0,-4), Vector(0,0,1))
		let xs = Intersection<Shape>(Intersection(2, A), Intersection(2.75, B), Intersection(3.25, C), Intersection(4.75, B), Intersection(5.25, C), Intersection(6, A))
		let expects = [(1.0, 1.5), (1.5, 2.0), (2.0, 2.5), (2.5, 2.5), (2.5, 1.5), (1.5, 1.0)]
		
		for idx in 0..<xs.count {
			//
			// It really takes time to get this test right.
			// This discussion helps me a lot:
			// https://forum.raytracerchallenge.com/thread/24/stuck-on-n1-various-intersections
			//
			let comps = Computation.prepare(xs[idx], r, xs)
			XCTAssertEqual(comps?.n1, expects[idx].0, "INDEX->: \(idx)")
			XCTAssertEqual(comps?.n2, expects[idx].1, "INDEX->: \(idx)")
		}
	}
	
	// Chpater 11 test #3
	func test_underPointIsOffsetBelowTheSurface() throws {
		// Scenario​: The under point is offset below the surface
		//​   ​Given​ r ← ray(point(0, 0, -5), vector(0, 0, 1))
		//​     ​And​ shape ← glass_sphere() with:
		//​       | transform | translation(0, 0, 1) |
		//​     ​And​ i ← intersection(5, shape)
		//​     ​And​ xs ← intersections(i)
		//​   ​When​ comps ← prepare_computations(i, r, xs)
		//​   ​Then​ comps.under_point.z > EPSILON/2
		//​     ​And​ comps.point.z < comps.under_point.z”
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		let shape = Sphere.glassy
		shape.transform = Matrix.translation(0, 0, 1)
		let i = Intersection<Shape>(5, shape)
		let xs = Intersection<Shape>(i)
		guard let comps = Computation.prepare(i, r, xs) else { XCTFail(); return }
		XCTAssertTrue(comps.underPoint.z > Double.epsilon/2)
		XCTAssertTrue(comps.point.z < comps.underPoint.z)
	}
}
