//
//  RaysTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class RaysTests: XCTestCase {
	var cts: Ray!
	

    override func setUpWithError() throws {
		//	Scenario​: Creating and querying a ray
		//	​​Given​ origin ← point(1, 2, 3)
		//	​​And​ direction ← vector(4, 5, 6)
		//	​​When​ r ← ray(origin, direction)
		//	​​Then​ r.origin = origin
		//	​​And​ r.direction = direction
		let origin = Point(1, 2, 3)
		let direction = Vector(4, 5, 6)
		cts = Ray(origin, direction)
    }

	override func tearDownWithError() throws {
		cts = nil
	}

	func test_isNotNil() throws {
		XCTAssertNotNil(cts)
		
		let origin = Point(1, 2, 3)
		let direction = Vector(4, 5, 6)
		XCTAssertEqual(origin, cts.origin)
		XCTAssertEqual(direction, cts.direction)
	}
	
	func test_computeDistance() throws {
		//	Scenario​: Computing a point from a distance
		//	Given​ r ← ray(point(2, 3, 4), vector(1, 0, 0))
		//	Then​ position(r, 0) = point(2, 3, 4)
		//	And​ position(r, 1) = point(3, 3, 4)
		//	And​ position(r, -1) = point(1, 3, 4)
		//	And​ position(r, 2.5) = point(4.5, 3, 4)
		let r = Ray(Point(2,3,4), Vector(1,0,0))
		XCTAssertEqual(Point(2,3,4), r.position(0))
		XCTAssertEqual(Point(3,3,4), r.position(1))
		XCTAssertEqual(Point(1,3,4), r.position(-1))
		XCTAssertEqual(Point(4.5,3,4), r.position(2.5))
	}
	
	func test_translating() throws {
		cts = Ray(Point(1,2,3), Vector(0,1,0))
		let m = Matrix.translation(3, 4, 5)
		let r2 = cts.transform(m)
		XCTAssertEqual(Point(4, 6, 8),  r2.origin)
		XCTAssertEqual(Vector(0, 1, 0), r2.direction)
	}
	
	func test_scaling() throws {
		cts = Ray(Point(1,2,3), Vector(0,1,0))
		let m = Matrix.scaling(2, 3, 4)
		let r2 = cts.transform(m)
		XCTAssertEqual(Point(2, 6, 12),  r2.origin)
		XCTAssertEqual(Vector(0, 3, 0), r2.direction)
	}
}
