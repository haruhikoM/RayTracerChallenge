//
//  CanvasTests.swift
//  RayTracerChallengeTests
//
//  Created by Haruhiko Minamiguchi on 2020/09/17.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class CanvasTests: XCTestCase {
	var cts: Canvas!

    override func setUpWithError() throws {
		cts = Canvas(10, 20)
	}

    override func tearDownWithError() throws {
       cts = nil
    }
	
	func test_creating() throws {
		XCTAssertNotNil(cts.width)
		XCTAssertNotNil(cts.height)
	}
	
	func test_coordinateSystem() throws {
		cts = Canvas(5, 3)
		let c1 = Color(r: 1.5, g: 0, b: 0)
		let c2 = Color(r: 0, g: 0.5, b: 0)
		let c3 = Color(r: -0.5, g: 0, b: 1)
		cts.write(pixel: c1, at: (0, 0))
		cts.write(pixel: c2, at: (2, 1))
		cts.write(pixel: c3, at: (4, 2))
		
		XCTAssertEqual(c1, cts.pixels.first)
		XCTAssertEqual(c2, cts.pixels[7])
		XCTAssertEqual(c3, cts.pixels.last)
		
		XCTAssertEqual(c1, cts.pixel(at: (0, 0)))
		XCTAssertEqual(c2, cts.pixel(at: (2, 1)))
		XCTAssertEqual(c3, cts.pixel(at: (4, 2)))
	}
	
	func test_writingPixels() throws {
		//	Scenario: Writing pixels to a canvas
		//	Given c ← canvas(10, 20)
		//	And red ← color(1, 0, 0)
		//	When write_pixel(c, 2, 3, red)
		//	Then pixel_at(c, 2, 3) = red
		let red = Color(r: 1, g: 0, b: 0)
		cts.write(pixel: red, at: (2, 3))
		XCTAssertEqual(cts.pixel(at: (2, 3)), red)
	}
	
	func test_pixelCount() throws {
		XCTAssertEqual(200, cts.pixels.count)
	}
	
	func test_createBodyArray() throws {
		cts = Canvas(2, 2)
		var arr = cts.createBodyArray()
		XCTAssertEqual([
						"0", "0", "0", "0", "0", "0",
						"0", "0", "0", "0", "0", "0"
		], arr)
		var match = """
		P3
		2 2
		255
		0 0 0 0 0 0
		0 0 0 0 0 0

		"""
		XCTAssertEqual(match, cts.toPPM)
		
		cts.write(pixel: .white, at: (0, 0))
		cts.write(pixel: .white, at: (1, 1))
		arr = cts.createBodyArray()
		XCTAssertEqual([
						"255", "255", "255", "0", "0", "0",
						"0", "0", "0", "255", "255", "255",
		], arr)
		
		match = """
		P3
		2 2
		255
		255 255 255 0 0 0
		0 0 0 255 255 255

		"""
		XCTAssertEqual(match, cts.toPPM)
	}
	
	func test_createBodyArrayAccordingToCanvasSize() throws {
		let width = 20; let height = 4
		cts = Canvas(width, height)
		let arr = cts.createBodyArray()
		XCTAssertFalse(arr.isEmpty)
		XCTAssertEqual(Int(height*width)*3, arr.count)
		
		let bodyarr = cts.createBodyArrayAccordingToCanvasSize(base: arr)
		let flatArr: [String] = bodyarr.flatMap({ $0 })
		XCTAssertEqual(flatArr.count, arr.count)
		XCTAssertFalse(bodyarr.isEmpty)
		var counter = 0
		for el in bodyarr {
			XCTAssertEqual(20*3, el.count)
			counter += 1
		}
		
		XCTAssertEqual(Int(height), counter)
	}
	
	func test_constructPPMheader() throws {
		/*
		Scenario: Constructing the PPM header
		Given c ← canvas(5, 3)
		When ppm ← canvas_to_ppm(c)
		Then lines 1-3 of ppm are
		"""
		P3
		53
		255
		"""
		*/
		cts = Canvas(5, 3)
		let ppm = cts.toPPM
		let match = ["P3",
					 "5 3",
					 "255"]
		for (idx, line) in ppm.components(separatedBy: "\n").enumerated() {
			if idx < 3 {
				XCTAssertEqual(match[idx], line)
			}
		}
	}
	
	func test_constructPPMPixelData() throws {
		//	Scenario: Constructing the PPM pixel data
		//	Given c ← canvas(5, 3)
			//	And c1 ← color(1.5, 0, 0)
			//	And c2 ← color(0, 0.5, 0)
			//	And c3 ← color(-0.5, 0, 1)
		//	When write_pixel(c, 0, 0, c1)
			//	And write_pixel(c, 2, 1, c2)
			//	And write_pixel(c, 4, 2, c3)
			//	And ppm ← canvas_to_ppm(c)
		//	Then lines 4-6 of ppm are
		let match =
		"""
		P3
		5 3
		255
		255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
		0 0 0 0 0 0 0 0 0 0 0 0 0 0 255

		"""
		cts = Canvas(5, 3)
		let c1 = Color(r: 1.5, g: 0, b: 0)
		let c2 = Color(r: 0, g: 0.5, b: 0)
		let c3 = Color(r: -0.5, g: 0, b: 1)
		cts.write(pixel: c1, at: (0, 0))
		cts.write(pixel: c2, at: (2, 1))
		cts.write(pixel: c3, at: (4, 2))
//
//		print(cts.toPPM)
//		let ppmArray = cts.toPPM.components(separatedBy: "\n")
//
//		for (idx, matchLine) in match.components(separatedBy: "\n").enumerated() {
//			XCTAssertEqual(matchLine, ppmArray[idx+3])
//		}
		
		XCTAssertEqual(match, cts.toPPM)
	}
	
	func test_splittingLongLine() throws {
		//	Scenario: Splitting long lines in PPM files
		//	Given c ← canvas(10, 2)
		//	When every pixel of c is set to color(1, 0.8, 0.6)
		//	And ppm ← canvas_to_ppm(c)
		// Then lines 4-7 of ppm are
		let match =
			"""
			P3
			10 2
			255
			255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
			153 255 204 153 255 204 153 255 204 153 255 204 153
			255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
			153 255 204 153 255 204 153 255 204 153 255 204 153

			"""
		let c = Canvas(10, 2, initialColor: Color(r: 1, g: 0.8, b: 0.6))
		let ppm = c.toPPM
//		let ppmArray = ppm.components(separatedBy: "\n")
//		dump(ppmArray)
//		for (idx, matchLine) in match.components(separatedBy: "\n").enumerated() {
//			XCTAssertEqual(matchLine, ppmArray[idx+3])
//		}
		XCTAssertEqual(match, ppm)
	}
	
	func test_colorToString() throws {
		let black = Color(r: 0, g: 0, b: 0)
		let white = Color(r: 1, g: 1, b: 1)
		XCTAssertEqual("0 0 0", black.toString)
		XCTAssertEqual("255 255 255", white.toString)
		
		let c1 = Color(r: 1.5, g: 0, b: 0)
		let c2 = Color(r: 0, g: 0.5, b: 0)
		let c3 = Color(r: -0.5, g: 0, b: 1)
		XCTAssertEqual("255 0 0", c1.toString)
		XCTAssertEqual("0 128 0", c2.toString)
		XCTAssertEqual("0 0 255", c3.toString)
	}
	
	func test_PPMMustEndWithNewLine() throws {
		//	Scenario: PPM files are terminated by a newline character
		//	Given c ← canvas(5, 3)
		//	When ppm ← canvas_to_ppm(c)
		//	Then ppm ends with a newline character
		cts = Canvas(5, 3)
		let ppm = cts.toPPM
		let lastIndex = ppm.index(ppm.endIndex, offsetBy: -1)
		XCTAssertEqual("\n", ppm[lastIndex])
	}
	
	func _test_puttingItTogetherChap2() throws {
		Exercise().chap2()
//		Exercise().writeTest()
	}
	
}
