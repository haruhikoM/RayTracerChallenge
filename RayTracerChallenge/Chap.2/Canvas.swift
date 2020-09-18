//
//  Canvas.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/17.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Canvas {
	typealias Coordinate = (x: Int, y: Int)
	
	private(set) var width: Int
	private(set) var height: Int
	var pixels: [Color]
	
	var toPPM: String {
		let header = """
		P3
		\(width) \(height)
		255
		"""
		
		var body = "\n"
		let perLineColorComponentsCountLimit = 17
		
		let bodyArray = createBodyArray()
//		let perLineCount = bodyArray.count / Int(height)
		
		
		func _composeBody() {
			let perLineCount = bodyArray.count / Int(height)
			var iterateCounter = 0
			for component in bodyArray {
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
		
		

		func __composeBody() {
			var perLineCount = bodyArray.count / Int(height)
			
			var iterateCounter = 0
			var isProcessingRemainder = false
			let limitter = perLineCount > perLineColorComponentsCountLimit ? perLineColorComponentsCountLimit : perLineCount
			let remains = perLineCount % perLineColorComponentsCountLimit
			
			var lineOverflow = Int(perLineCount / perLineColorComponentsCountLimit)-1
			var lineFlag = perLineCount-1
			
			for component in bodyArray {
				body += String(component)
//
//				if lineOverflow > 0 {
					lineFlag = lineOverflow > 0 ? remains-1 : limitter-1
//				}
				if lineOverflow < 0 {
					lineOverflow = Int(perLineCount / perLineColorComponentsCountLimit)-1
				}
				
				if iterateCounter == lineFlag {
					body += "\n"
					iterateCounter = 0
					lineOverflow -= 1
//					if remains < perLineCount {
//						isProcessingRemainder = false
//						if perLineCount < 0 { perLineCount = bodyArray.count / Int(height); isProcessingRemainder = false }
//					}
//					else {
//						perLineCount -= limitter
//						if perLineCount < 0 { isProcessingRemainder = true }
//					}
				}
				else {
					body += " "
					iterateCounter += 1
				}
			}
		}
		
		let simpleArray = createBodyArrayAccordingToCanvasSize(base: bodyArray)
		
		if let firstElement = simpleArray.first, firstElement.count < perLineColorComponentsCountLimit {
			_composeBody()
		}
		else {
			for line in simpleArray {
				let perLineCount = perLineColorComponentsCountLimit
				var iterateCounter = 0
				for component in line {
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
				if body.last == " " { body.removeLast() }
				body += "\n"
			}
		}
//		
//		body.removeLast()
//		body += "\n"
		
		return header + body
	}
	
	func createBodyArrayAccordingToCanvasSize(base: [String]) -> [[String]] {
		var tempArray = [[String]]()
		var childArray = [String]()
		let perLineCount = base.count/Int(height)
//			var iterateCounter = 0
		for (idx,component) in base.enumerated() {
//			if idx + 1 == Int(width) { temp.append(childArry) }
			if Int(idx)>0, (Int(idx) % perLineCount) == 0 {
				tempArray.append(childArray)
				childArray.removeAll()
			}
			childArray.append(component)
		}
		if !childArray.isEmpty { tempArray.append(childArray) }
		return tempArray
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
	
	init(_ width: Int, _ height: Int, initialColor: Color = .black) {
		self.width = width
		self.height = height
		self.pixels = Array(repeating: initialColor, count: Int(width*height))
	}
	
	mutating func write(pixel: Color, at coord: Coordinate) {
		let index = Int((coord.y * width) + coord.x)
		guard index >= 0, index <= width*height-1 else { return }
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
