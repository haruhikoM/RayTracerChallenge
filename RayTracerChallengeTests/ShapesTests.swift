//
//  ShapesTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/28.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class ShapesTests: XCTestCase {
	var cts: Shape!

    override func setUpWithError() throws {
		cts = Shape.testShape
    }

    override func tearDownWithError() throws {
		cts = nil
    }
	
	func test_defaultTransformation() throws {
		XCTAssertEqual(cts.transform, Matrix.identity)
	}
	
	func tesst_assignTransformation() throws {
		cts.transform = Matrix.translation(2, 3, 4)
		XCTAssertEqual(cts.transform, Matrix.translation(2, 3, 4))
	}
	
	func test_defaultMaterial() throws {
		XCTAssertEqual(cts.material, Material())
	}
	
	func tesst_assignMaterial() throws {
		var m = Material()
		m.ambient = 1
		cts.material = m
		XCTAssertEqual(cts.material, m)
	}
	
	func test_IntersectingScaledShapeWithRay() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		cts.transform = Matrix.scaling(2, 2, 2)
		let _ = cts.intersect(r)
		XCTAssertEqual(cts.savedRay?.origin, Point(0,0,-2.5))
		XCTAssertEqual(cts.savedRay?.direction, Vector(0,0,0.5))
	}
	
	func test_IntersectingTranslatedShapeWithRay() throws {
		let r = Ray(Point(0,0,-5), Vector(0,0,1))
		cts.transform = Matrix.translation(5, 0, 0)
		let _ = cts.intersect(r)
		XCTAssertEqual(cts.savedRay?.origin, Point(-5,0,-5))
		XCTAssertEqual(cts.savedRay?.direction, Vector(0,0,1))
	}
	
	func test_computingNormalOnTranslatedShape() throws {
		cts.transform = Matrix.translation(0, 1, 0)
		let normal = cts.normal(at: Point(0, 1.70711, -0.70711))
		XCTAssertEqual(normal, Vector(0, 0.70711, -0.70711))
		
		// On a transformed shape
		cts = Shape.testShape
		let m = Matrix.scaling(1, 0.5, 1) * Matrix.rotation(by: .z, radians: Double.pi/5)
		cts.transform = m
		let n = cts.normal(at: Point(0, sqrt(2)/2, -sqrt(2)/2))
		XCTAssertEqual(n, Vector(0, 0.97014, -0.24254))
	}
}
