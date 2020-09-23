//
//  LightTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/24.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class LightTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
	
	func test_pointLightHasPositionAndIntensity() throws {
		let intensity = Color(r: 1, g: 1, b: 1)
		let position = Point(0, 0, 0)
		let light = PointLight(position, intensity)
		XCTAssertEqual(position, light.position)
		XCTAssertEqual(intensity, light.intensity)
	}
}
