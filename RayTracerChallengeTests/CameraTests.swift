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
		let fieldOfView = Float.pi/2
		cts = Camera(hSize, vSize, fieldOfView)
    }

    override func tearDownWithError() throws {
		cts = nil
    }
	
	func test_constructing() throws {
		XCTAssertEqual(cts.hSize, 160)
		XCTAssertEqual(cts.vSize, 120)
		XCTAssertEqual(cts.fieldOfView, Float.pi/2)
		XCTAssertEqual(cts.transform, Matrix.identity)
	}
	
	func test_pixelSizeForHCanvas() throws {
		let hSize = 200
		let vSize = 125
		let fieldOfView = Float.pi/2
		cts = Camera(hSize, vSize, fieldOfView)
		XCTAssertEqual(cts.pixelSize, 0.01)
	}
	
	func test_pixelSizeForVCanvas() throws {
		let vSize = 200
		let hSize = 125
		let fieldOfView = Float.pi/2
		cts = Camera(hSize, vSize, fieldOfView)
		XCTAssertEqual(cts.pixelSize, 0.01)
	}
}
