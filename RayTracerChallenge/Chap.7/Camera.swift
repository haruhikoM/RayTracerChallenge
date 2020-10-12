//
//  Camera.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/25.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Camera {
	var hSize: Int
	var vSize: Int
	
	var halfWidth: Double
	var halfHeight: Double
	
	var fieldOfView: Double
	var pixelSize: Double
	
	var transform = Matrix.identity
	
	init(_ hSize: Int, _ vSize: Int, _ fieldOfView: Double) {
		self.hSize = hSize
		self.vSize = vSize
		self.fieldOfView = fieldOfView
		
		let halfView = tan(fieldOfView / 2)
		let aspect = Double(hSize) / Double(vSize) // <= this line was the culprit...
		if aspect >= 1 {
			halfWidth  = halfView
			halfHeight = halfView / aspect
		}
		else {
			halfWidth  = halfView * aspect
			halfHeight = halfView
		}
		
		self.pixelSize = (halfWidth * 2) / Double(hSize)
	}
	
	func rayForPixel(at px: Int, _ py: Int) -> Ray {
		let xOffset = (Double(px) + 0.5) * pixelSize
		let yOffset = (Double(py) + 0.5) * pixelSize
		
		let worldX = halfWidth  - xOffset
		let worldY = halfHeight - yOffset
		
		let pixel  = transform.inverse() * Point(worldX, worldY, -1)
		let origin = transform.inverse() * Point(0,0,0)
		let direction = (pixel - origin).normalizing()
		
		return Ray(origin, direction)
	}
	
	func render(_ world: World) -> Canvas {
		let startTime = Date()
		var image = Canvas(hSize, vSize)
		
		for y in 0..<vSize {
			for x in 0..<hSize {
				let r = self.rayForPixel(at: x, y)
				let color = world.color(at: r)
				image.write(pixel: color, at: (x, y))
			}
		}
		
		print("\n🏁🏁🏁 Time To Render -> \(Date().timeIntervalSince(startTime)) sec.\n")
		return image
	}
	
	
	func render(_ world: World, completionHandler: @escaping (Canvas, TimeInterval?) -> Void) {
		let startTime = Date()
		var image = Canvas(hSize, vSize)
		
		let queue = OperationQueue()
		queue.name = "me.okono.render"
		queue.maxConcurrentOperationCount = 6
		var renderOperations = [Operation]()
		
		for y in 0..<vSize {
			for x in 0..<hSize {
				let op = BlockOperation {
					let r = self.rayForPixel(at: x, y)
					let color = world.color(at: r)
					image.write(pixel: color, at: (x, y))
				}
				renderOperations.append(op)
			}
		}
		
		queue.addOperations(renderOperations, waitUntilFinished: true)
		let interval = Date().timeIntervalSince(startTime)
		print("\n🏁🏁🏁 Time To Render -> \(interval) sec.\n")
		completionHandler(image, interval)
	
		/*
		Bench
		Nothing -> 45 sec.
		DispatchGroup -> 45 sec.
		OperationQueue (4 cores) -> 14.5 sec.
		OperationQueue (6 cores) -> 16.4 sec.
		OperationQueue (8 cores) -> 18 sec.
		*/
	}
	
//	mutating func _pixelSize() -> Double {
//		let halfView = tan(fieldOfView/2)
//		let aspect = hSize / vSize
//		if aspect >= 1 {
//			halfWidth = halfView
//			halfHeight = halfView / Double(aspect)
//		}
//		else {
//			halfWidth = halfView * Double(aspect)
//			halfHeight = halfView
//		}
//		return (halfWidth * 2) / Double(hSize)
//	}
}
