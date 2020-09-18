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
		print(velocity)
		var p = Projectile(position: start, velocity: velocity)
		
		let gravity = Vector(x: 0, y: -0.1, z: 0)
		let wind = Vector(x: -0.01, y: 0, z: 0)
		let e = Environment(gravity: gravity, wind: wind)
		var c = Canvas(canvasWidth, canvasHeight)
		
		while p.position.y >= 0.0 {
			print(p)
			c.write(pixel: Color(r: 1, g: 0, b: 0), at: (Int(p.position.x), canvasHeight-Int(p.position.y)))
			p = tick(env: e, proj: p)
		}
		save(text: c.toPPM, to: documentDirectory, withFileName: "RTC-Chap2-"+fmtr.string(from: Date())+".ppm")
	}

	private func save(text: String, to directory: URL, withFileName fileName: String) {
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
