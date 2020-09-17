//
//  Canvas.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/17.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Canvas {
	typealias Coordinate = (x: Float, y: Float)
	
	private(set) var width: Float
	private(set) var height: Float
	var pixels: [Color]
	
	private let header = """
	P3
	53
	255
	"""
	
	var toPPM: String {
		var body = "\n"
		
		var counter = 0
		var pixelCounter = 0
		let perLineColorComponentsCountLimit = 17 // Int((width-1) * 3)
		let tempLineLength = pixels.count / Int(height)
		
		let bodyArray = createBodyArray()
		let perLineCount = bodyArray.count / Int(height)
		
		/*
		if perLineCount < perLineColorComponentsCountLimit {
			var iterateCounter = 0
			for (_, component) in bodyArray.enumerated() {
				body += String(component)
				
				if iterateCounter == perLineCount-1 {
					body += "\n"
					iterateCounter = 0
				}
				else {
					body += " "
					iterateCounter += 1
				}
			}
		}
		else {
			var iterateCounter = 0
			for (_, component) in bodyArray.enumerated() {
				body += String(component)
				
				if iterateCounter == perLineColorComponentsCountLimit-1 {
					body += "\n"
					iterateCounter = 0
				}
				else {
					body += " "
					iterateCounter += 1
				}
			}
		}
		*/
		
		func composeBody(perLine: Int) {
			var iterateCounter = 0
			var isProcessingRemainder = false
			let limitter = perLine > perLineColorComponentsCountLimit ? perLineColorComponentsCountLimit : perLine
			let remains = perLine - perLineColorComponentsCountLimit
			
			let lineOverflow = perLine > perLineColorComponentsCountLimit
			var lineFlag = perLine-1
			
			for component in bodyArray {
				body += String(component)
				
				if lineOverflow {
					lineFlag = isProcessingRemainder ? remains-1 : limitter-1
				}
				
				if iterateCounter == lineFlag {
					body += "\n"
					iterateCounter = 0
					isProcessingRemainder.toggle()
				}
				else {
					body += " "
					iterateCounter += 1
				}
			}
		}
		
		composeBody(perLine: perLineCount)
		
//		for (idx, colorComponent) in createBodyArray().enumerated() {
//
//		}
//
//		for pixel in pixels {
//			body += pixel.toString
//			pixelCounter += 1
//
//			if counter == tempLineLength {
//				body += "\n"
//				counter = 0
//			}
//			else {
//				body += " "
//				counter += 3
//			}
//		}
//		if body.last == " " {
			body.removeLast()
//		}
		
		return header + body
	}
	
	func createBodyArray() -> [String] {
		var temp = [String]()
		for pixel in pixels {
			for comp in pixel.toString.split(separator: " ") {
				temp.append(String(comp))
			}
		}
		return temp
	}
	
	init(_ width: Float, _ height: Float, initialColor: Color = .black) {
		self.width = width
		self.height = height
		self.pixels = Array(repeating: initialColor, count: Int(width*height))
	}
	
	mutating func write(pixel: Color, at coord: Coordinate) {
		let index = Int((coord.y * width) + coord.x)
		pixels[index] = pixel
	}
	
	func pixel(at coord: Coordinate) -> Color {
		let index = Int((coord.y * width) + coord.x)
		return pixels[index]
	}
}

extension Array where Element == String {
	mutating func format(with limit: Int) {
		for var element in self {
			if element.count > limit {
				let index = element.index(element.startIndex, offsetBy: limit)
				element.insert("\n", at: index)
			}
		}
	}
}
