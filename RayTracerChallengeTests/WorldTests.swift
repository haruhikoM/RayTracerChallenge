//
//  WorldTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/24.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class WorldTests: XCTestCase {
	var cts: World!
	
    override func setUpWithError() throws {
		cts = World._default
	}

    override func tearDownWithError() throws {
        cts = nil
    }
	
	func test_creating() throws {
		XCTAssertNotNil(cts)
	}
	
	func test_default() throws {
		let light = PointLight(Point(-10,10,-10), .white)
		let material = Material(color: Color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2)
		let s1 = Sphere(material: material)
		let scaling = Matrix.scaling(0.5, 0.5, 0.5)
		let s2 = Sphere(transform: scaling)
		let w = World._default
		XCTAssertEqual(light, w.light)
		XCTAssertEqual(2, w.scene.count)
		XCTAssertTrue(w.contains(identicalTo: s1))
		XCTAssertTrue(w.contains(identicalTo: s2))
	}
	
	func test_intersectWithRay() throws {
		let r = Ray(Point(0,0,-5), Vector(0, 0, 1))
		let xs = cts.intersects(r)
		XCTAssertEqual(4, xs.count)
		XCTAssertEqual(4, xs[0].t)
		XCTAssertEqual(xs[1].t, 4.5)
		XCTAssertEqual(xs[2].t, 5.5)
		XCTAssertEqual(xs[3].t, 6)
	}
	
	func test_shadingAnIntersection() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		let shape = cts.scene.first!
		let i = Intersection(4, shape)
		guard let comps = Computation.prepare(i, r) else { XCTFail(); return }
		let c = cts.shadeHit(comps)
		XCTAssertEqual(Color(r: 0.38066, g: 0.47583, b: 0.2855), c)
	}
	
	func test_shadingAnIntersectionFromInside() throws {
		cts.light = PointLight(Point(0,0.25,0), .white)
		let r = Ray(Point(0,0,0), Vector(0,0,1))
		let shape = cts.scene[1]
		let i = Intersection(0.5, shape)
		guard let comps = Computation.prepare(i, r) else { XCTFail(); return }
		let c = cts.shadeHit(comps)
		XCTAssertEqual(Color(r: 0.90498, g: 0.90498, b: 0.90498), c)
	}
	
	func test_theColorWhenRayMisses() throws {
		let r = Ray(Point(0,0,-5), Vector(0, 1, 0))
		let c = cts.color(at: r)
		XCTAssertEqual(c, Color.black)
	}
	
	func test_theColorWhenRayHits() throws {
		let r = Ray(Point(0,0,-5), Vector(0, 0, 1))
		let c = cts.color(at: r)
		XCTAssertEqual(c, Color(r: 0.38066, g: 0.47583, b: 0.2855))
	}
	
	func test_theColorWithIntresectionBehindTheRay() throws {
		let outer = cts.scene.first!
		outer.material.ambient = 1
		
		let inner = cts.scene[1]
		inner.material.ambient = 1
		
		let r =	Ray(Point(0,0,0.75), Vector(0,0,-1))
		let c = cts.color(at: r)
		XCTAssertEqual(c, inner.material.color)
	}
	
	// Chapter 8
	func test_noShadowWhenNothigIsCollinearWtihPointAndLight() throws {
		let p = Point(0,10,0)
		XCTAssertFalse(cts.isShadowed(p))
	}
	
	func test_shadowWhenObjectisBetweenPointAndLight() throws {
		let p = Point(10,-10,10)
		XCTAssertTrue(cts.isShadowed(p))
	}
	
	func test_noShadowWhenObjectisBehindLight() throws {
		let p = Point(-20,20,-20)
		XCTAssertFalse(cts.isShadowed(p))
	}
	
	func test_noShadowWhenObjectisBehindPoint() throws {
		let p = Point(-2,2,-2)
		XCTAssertFalse(cts.isShadowed(p))
	}
	
	func _test_shadeHitIsGivenAnIntersectionInShadow() throws {
		var w = World()
		w.light = PointLight(Point(0,0,-10), Color(r: 1, g: 1, b: 1))
		let s1 = Sphere()
		let s2 = Sphere()
		s2.transform = Matrix.translation(0, 0, 10)
		w.addToScene(objects: s1, s2)
		let r = Ray(Point(0,0,5), Vector(0,0,1))
		let i = Intersection<SceneObject>(4, s2)
		guard let comps = Computation.prepare(i, r) else { XCTFail(); return }
		let c = w.shadeHit(comps)
		XCTAssertEqual(c, Color(r: 0.1, g: 0.1, b: 0.1))
	}
}
