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
}
