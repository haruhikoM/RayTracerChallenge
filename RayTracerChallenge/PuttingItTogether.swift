//
//  PuttingItTogether.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/17.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Projectile {
	var position: Tuple    // Point
	var velocity: Tuple // Vector
}

struct Environment {
	var gravity: Tuple // Vector
	var wind: Tuple    // Vector
}

struct Exercise {
	let canvasWidth  = 900
	let canvasHeight = 550
	
	func tick(env: Environment, proj: Projectile) -> Projectile {
		//	function tick(env, proj)
		//	  position ← proj.position + proj.velocity
		//	  velocity ← proj.velocity + env.gravity + env.wind
		//	  return projectile(position, velocity)
		//	end function
		//
		//	p ← projectile(point(0, 1, 0), normalize(vector(1, 1, 0)))
		//	e ← environment(vector(0, -0.1, 0), vector(-0.01, 0, 0))

		let position = proj.position + proj.velocity
		let velocity = proj.velocity + env.gravity + env.wind
		return Projectile(position: position, velocity: velocity)
	}

	func chap1() {
		var p = Projectile(position: Point(x: 0, y: 1, z: 0), velocity: Vector(x: 1, y: 1, z: 0).normalizing())
		let e = Environment(gravity: Vector(x: 0, y: -0.1, z: 0), wind: Vector(x: -0.01, y: 0, z: 0))
		
		while p.position.y >= 0.0 {
			p = tick(env: e, proj: p)
//			print(p.position)
		}
//		print("-----------------------------")
//		print(p.position)
	}
}

// Chap2

extension Exercise {
	var fmtr: DateFormatter {
		let fmt = DateFormatter()
		fmt.dateFormat = "yyyy-MM-dd(HH.mm.ss)"
		fmt.timeZone = TimeZone(identifier: "JST")
		return fmt
	}
	
	private var documentDirectory: URL {
//		let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,	.userDomainMask, true)
		let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return doc[0]
	}
	
	func chap2() {
		let start = Point(x: 0, y: 1, z: 0)
		
		let velocity = (Vector(x: 0.01, y: 0.018, z: 0)).normalizing() * 11.25
//		print(velocity)
		var p = Projectile(position: start, velocity: velocity)
		
		let gravity = Vector(x: 0, y: -0.1, z: 0)
		let wind = Vector(x: -0.01, y: 0, z: 0)
		let e = Environment(gravity: gravity, wind: wind)
		var c = Canvas(canvasWidth, canvasHeight)
		
		while p.position.y >= 0.0 {
//			print(p)
			c.write(pixel: Color(r: 1, g: 0, b: 0), at: (Int(p.position.x), canvasHeight-Int(p.position.y)))
			p = tick(env: e, proj: p)
		}
		save(text: c.toPPM, to: documentDirectory, named: "RTC-Chap2-"+fmtr.string(from: Date())+".ppm")
	}

	private func save(text: String, to directory: URL, named fileName: String) {
		let fileURL = directory.appendingPathComponent(fileName)
		do {
			try text.write(to: fileURL, atomically: true, encoding: .utf8)
		} catch {
			print("Error", error)
			return
		}
		
		print("\n ### Save successful to -> \(fileURL)\n")
	}
}

// Chapter 4
extension Exercise {
	func chap4() {
		let width  = 100
		let height = 100
		let center = Point(Float(width)/2, Float(height)/2, 0)
		var canvas = Canvas(width, height)
		var points = Array(repeating: Point(0, 0, 1), count: 12)

		for (idx, p) in points.enumerated() {
			let t = Matrix.rotation(by: .y, radians: Float(idx) * Float.pi/6)
			let td = t * p
			let r = Float(height * 3/8)
			points[idx] = Point(td.x * r+center.x, td.z * r+center.y, 0)
			
		}
		
		points.forEach { canvas.write(pixel: .red, at: (Int($0.x), Int($0.y))) }
		save(text: canvas.toPPM, to: documentDirectory, named: fileName(chap: 4))
	}
	
	func fileName(chap: Int) -> String {
		"RTC-Chap\(chap)-" + fmtr.string(from: Date()) + ".ppm"
	}
}

extension Exercise {
	// 1. casts ray at sphere
	// 2. and draw the picture to a canvas
	
	func chap5() {
		let width  = 100
		let height = 100
//		let center = Point(Float(width)/2, Float(height)/2, 0)
		var c = Canvas(width, height)
		
		// hint:2, 3, 4
		let wallZ: Float = 10.0
		let wallSize: Float = 7.0
		let half = wallSize / 2
		
		let pixelSize = wallSize / Float(width)
		
		let rayOrigin = Point(0,0,-5)
		let s = Sphere()
		for y in 0..<height {
			let worldY = half - pixelSize * Float(y)
			for x in 0..<width {
				let worldX = -half + pixelSize * Float(x)
				let pos = Point(worldX, worldY, wallZ)
				let d = pos - rayOrigin
				let r = Ray(rayOrigin, d.normalizing())
				let xs = r.intersects(s)
				
				switch xs.hit() {
//				case .multi(_):
//					c.write(pixel: .red, at: (x, y))
				case .one(_, _):
					c.write(pixel: .red, at: (x, y))
				default:
					continue
				}
				
			}
		}
		save(text: c.toPPM, to: documentDirectory, named: fileName(chap: 5))
	}
	
	func chap6() {
		let canvasSize = 300
		var c = Canvas(canvasSize, canvasSize)
		
		let wallZ: Float = 10.0
		let wallSize: Float = 7.0
		let half = wallSize / 2
		
		let pixelSize = wallSize / Float(canvasSize)
		
		let rayOrigin = Point(0,0,-5)
		let s = Sphere(material: Material(color: Color(r: 1, g: 0.2, b: 1)))
		
		// Add light source
		let lightPosition = Point(-10, 10, -10)
		let lightColor = Color.white
		let light = PointLight(lightPosition, lightColor)
		
		for y in 0..<canvasSize {
			let worldY = half - pixelSize * Float(y)
			for x in 0..<canvasSize {
				let worldX = -half + pixelSize * Float(x)
				let pos = Point(worldX, worldY, wallZ)
				let d = pos - rayOrigin
				let r = Ray(rayOrigin, d.normalizing())
				let xs = r.intersects(s)
				
				switch xs.hit() {
				//				case .multi(_):
				//					c.write(pixel: .red, at: (x, y))
				case let .one(t, obj):
					let point = r.position(t)
					let normal = obj.normal(at: point)
					let eye = -r.direction
					let color = obj.material.lighting(light: light, point: point, eyeVector: eye, normalVector: normal)
					c.write(pixel: color, at: (x, y))
				default:
					continue
				}
				
			}
		}
		save(text: c.toPPM, to: documentDirectory, named: fileName(chap: 5))
	}
}
