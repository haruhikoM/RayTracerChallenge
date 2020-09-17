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
	func tick(env: Environment, proj: Projectile) -> Projectile {
		let position = proj.position + proj.velocity
		let velocity = proj.velocity + env.gravity + env.wind
		return Projectile(position: position, velocity: velocity)
	}

	func chap1() {
		var p = Projectile(position: Point(x: 0, y: 1, z: 0), velocity: Vector(x: 1, y: 1, z: 0).normalizing())
		let e = Environment(gravity: Vector(x: 0, y: -0.1, z: 0), wind: Vector(x: -0.01, y: 0, z: 0))
		
		while p.position.y > 0.0 {
			p = tick(env: e, proj: p)
			print(p.position)
		}
		print("-----------------------------")
		print(p.position)
	}
}
