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
	
	var toPPM: String {
		let header = """
		P3
		53
		255
		"""
		
		var body = "\n"
		let perLineColorComponentsCountLimit = 17
		
		let bodyArray = createBodyArray()
		let perLineCount = bodyArray.count / Int(height)

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
		body.removeLast()
		
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
