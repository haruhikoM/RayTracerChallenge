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
		let center = Point(Double(width)/2, Double(height)/2, 0)
		var canvas = Canvas(width, height)
		var points = Array(repeating: Point(0, 0, 1), count: 12)

		for (idx, p) in points.enumerated() {
			let t = Matrix.rotation(by: .y, radians: Double(idx) * Double.pi/6)
			let td = t * p
			let r = Double(height * 3/8)
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
//		let center = Point(Double(width)/2, Double(height)/2, 0)
		var c = Canvas(width, height)
		
		// hint:2, 3, 4
		let wallZ: Double = 10.0
		let wallSize: Double = 7.0
		let half = wallSize / 2
		
		let pixelSize = wallSize / Double(width)
		
		let rayOrigin = Point(0,0,-5)
		let s = Sphere()
		for y in 0..<height {
			let worldY = half - pixelSize * Double(y)
			for x in 0..<width {
				let worldX = -half + pixelSize * Double(x)
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
		
		let wallZ: Double = 10.0
		let wallSize: Double = 7.0
		let half = wallSize / 2
		
		let pixelSize = wallSize / Double(canvasSize)
		
		let rayOrigin = Point(0,0,-5)
		let s = Sphere(material: Material(color: Color(r: 1, g: 0.2, b: 1)))
		
		// Add light source
		let lightPosition = Point(-10, 10, -10)
		let lightColor = Color.white
		let light = PointLight(lightPosition, lightColor)
		
		for y in 0..<canvasSize {
			let worldY = half - pixelSize * Double(y)
			for x in 0..<canvasSize {
				let worldX = -half + pixelSize * Double(x)
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

//MARK: - Chapter 7
extension Exercise {
	var floor: Sphere {
		let floor = Sphere()
		floor.transform = Matrix.scaling(10, 0.01, 10)
		floor.material = Material()
		floor.material.color = Color(r: 1, g: 0.9, b: 0.9)
		floor.material.specular = 0
		return floor
	}
		
	var leftWall: Sphere {
		let leftWall = Sphere()
		leftWall.transform = Matrix.translation(0, 0, 5) *
			Matrix.rotation(by: .y, radians: -Double.pi/4) *
			Matrix.rotation(by: .x, radians: Double.pi/2) *
			Matrix.scaling(10, 0.01, 10)
		leftWall.material = floor.material
		return leftWall
	}
	
	var rightWall: Sphere {
		let rightWall = Sphere()
		rightWall.transform = Matrix.translation(0, 0, 5) *
			Matrix.rotation(by: .y, radians: Double.pi/4) *
			Matrix.rotation(by: .x, radians: Double.pi/2) *
			Matrix.scaling(10, 0.01, 10)
		rightWall.material = floor.material
		return rightWall
	}
	
	var middleSphere: Sphere {
		let middle = Sphere()
		middle.transform = Matrix.translation(-0.5, 1, 0.5)
		middle.material = Material()
		middle.material.color = Color(r: 0.1, g: 1, b: 0.5)
		middle.material.diffuse = 0.7
		middle.material.specular = 0.3
		return middle
	}
	
	var rightSphere: Sphere {
		let right = Sphere()
		right.transform = Matrix.translation(1.5, 0.5, -0.5) * Matrix.scaling(0.5, 0.5, 0.5)
		right.material = Material()
		right.material.color = Color(r: 0.5, g: 1, b: 0.1)
		right.material.diffuse = 0.7
		right.material.specular = 0.3
		return right
	}
	
	var leftSphere: Sphere {
		let left = Sphere()
		left.transform = Matrix.translation(-1.5, 0.33, -0.75) * Matrix.scaling(0.33, 0.33, 0.33)
		left.material = Material()
		left.material.color = Color(r: 1, g: 0.8, b: 0.1)
		left.material.diffuse = 0.7
		left.material.specular = 0.3
		return left
	}

	
	func chap7() {
		var world = World()
		world.light = PointLight(Point(-10,10,-10), .white)
		world.scene = [floor, leftWall, rightWall, middleSphere, leftSphere, rightSphere]
		
		var camera = Camera(400, 200, Double.pi/3)
		camera.transform = Transform.view(Point(0,1.5,-5), Point(0,1,0), Vector(0,1,0))
		
		let canvas = camera.render(world)
		save(text: canvas.toPPM, to: documentDirectory, named: fileName(chap: 7))
	}
}
