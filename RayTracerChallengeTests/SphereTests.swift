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
	
	func test_defaultTransformation() throws {
		XCTAssertEqual(Matrix.identity, cts.transform)
	}
	
	func test_changingTransformation() throws {
		let t = Matrix.translation(2, 3, 4)
		cts.transform = t
		XCTAssertEqual(t, cts.transform)
	}
	
	func RETIRED_test_intersectingAScaledSphereWithRay() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		cts.transform = Matrix.scaling(2, 2, 2)
		var xs = r.intersects(cts)
		XCTAssertEqual(2, xs.count)
		XCTAssertEqual(3, xs[0].t)
		XCTAssertEqual(7, xs[1].t)
		
		// Intersecting a translated sphere with a ray
		cts.transform = Matrix.translation(5, 0, 0)
		xs = r.intersects(cts)
		XCTAssertEqual(0, xs.count)
	}
	
	//MARK: - Chapter 6
	func test_normalPointsToXYZAxes() throws {
		// x axis
		var n = cts.normal(at: Point(1,0,0))
		XCTAssertEqual(Vector(1,0,0), n)
		
		// y axis
		n = cts.normal(at: Point(0,1,0))
		XCTAssertEqual(Vector(0,1,0), n)
		
		// z axis
		n = cts.normal(at: Point(0,0,1))
		XCTAssertEqual(Vector(0,0,1), n)
		
		// nonaxial point
		n = cts.normal(at: Point(sqrt(3)/3,sqrt(3)/3,sqrt(3)/3))
		XCTAssertEqual(Vector(sqrt(3)/3,sqrt(3)/3,sqrt(3)/3), n)
		
		// normal is always normalized
		n = cts.normal(at: Point(sqrt(3)/3,sqrt(3)/3,sqrt(3)/3))
		XCTAssertEqual(n.normalizing(), n)
	}
	
	func test_computingNormalOnTranslatedSphere() throws {
		cts.transform = Matrix.translation(0, 1, 0	)
		var n = cts.normal(at: Point(0, 1.70711, -0.70711))
		XCTAssertEqual(Vector(0, 0.70711, -0.70711), n)
		
		let m = Matrix.scaling(1, 0.5, 1) * Matrix.rotation(by: .z, radians: Double.pi/5)
		cts.transform = m
		n = cts.normal(at: Point(0,	sqrt(2)/2, -sqrt(2)/2))
		XCTAssertEqual(Vector(0, 0.97014, -0.24254), n)
	}
	
	func RETIRED_test_hasDefaultMaterial() throws {
		let m = cts.material
		XCTAssertEqual(m, Material())
	}
	
	func RETIRED_test_mayBeAssignedMaterial() throws {
		var m = Material()
		m.ambient = 1
		cts.material = m
		XCTAssertEqual(m, cts.material)
	}
	
	// Chapter 9
	func test_itsAShape() throws {
		// XCTAssertTrue(cts is Shape) <- no need to test...
	}
	
	// Chapter 11 - Transparency & Refraction
	// #1
	func test_helperForGlassySphere() throws {
		let s = Sphere.glassy
		XCTAssertEqual(s.transform, Matrix.identity)
		XCTAssertEqual(s.material.transparency, 1.0)
		XCTAssertEqual(s.material.refractiveIndex, 1.5)
	}
	
	
}
