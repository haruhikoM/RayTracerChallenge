//
//  CameraTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/25.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class CameraTests: XCTestCase {
	var cts: Camera!

    override func setUpWithError() throws {
		let hSize = 160
		let vSize = 120
		let fieldOfView = Double.pi/2
		cts = Camera(hSize, vSize, fieldOfView)
    }

    override func tearDownWithError() throws {
		cts = nil
    }
	
	func test_constructing() throws {
		XCTAssertEqual(cts.hSize, 160)
		XCTAssertEqual(cts.vSize, 120)
		XCTAssertEqual(cts.fieldOfView, Double.pi/2)
		XCTAssertEqual(cts.transform, Matrix.identity)
	}
	
	func test_pixelSizeForHCanvas() throws {
		let hSize = 200
		let vSize = 125
		let fieldOfView = Double.pi/2
		cts = Camera(hSize, vSize, fieldOfView)
//		XCTAssertEqual(cts.pixelSize, 0.01)
		XCTAssertEqual(cts.pixelSize, 0.01, accuracy: Double.epsilon)
	}
	
	func test_pixelSizeForVCanvas() throws {
		let vSize = 125
		let hSize = 200
		let fieldOfView = Double.pi/2
		cts = Camera(hSize, vSize, fieldOfView)
		XCTAssertEqual(cts.pixelSize, 0.01, accuracy: Double.epsilon)
//		XCTAssertEqual(cts.pixelSize, 0.01)
	}
	
	///
	func test_constructingRayThroughCenterOfCanvas() throws {
		let c = Camera(201, 101, Double.pi/2)
		let r = c.rayForPixel(at: 100, 50)
		
		XCTAssertEqual(r.origin, Point(0,0,0))
		XCTAssertEqual(r.direction, Vector(0,0,-1))
	}
	
	func test_constructingRayThroughCornerOfCanvas() throws {
		cts = Camera(201, 101, Double.pi/2)
		let r = cts.rayForPixel(at: 0, 0)
		
		XCTAssertEqual(r.origin, Point(0,0,0))
		XCTAssertEqual(r.direction, Vector(0.66519,0.33259,-0.66851))
	}
	
	func test_constructingRayWhenCameraIsTransformed() throws {
		cts = Camera(201, 101, Double.pi/2)
		cts.transform = Matrix.rotation(by: .y, radians: Double.pi/4) * Matrix.translation(0, -2, 5)
		let r = cts.rayForPixel(at: 100, 50)
		XCTAssertEqual(r.origin, Point(0,2,-5))
		XCTAssertEqual(r.direction, Vector(sqrt(2)/2,0,-sqrt(2)/2))
	}
	///
	
	func test_renderingWorld() throws {
		let w = World._default
		var c = Camera(11, 11, Double.pi/2)
		let from = Point(0,0,-5)
		let to = Point(0,0,0)
		let up = Vector(0,1,0)
		c.transform = Transform.view(from, to, up)
		let image = c.render(w)
		XCTAssertEqual(image.pixel(at: (5 ,5)), Color(r: 0.38066, g: 0.47583, b: 0.2855))
	}
}
