//
//  Sphere.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Sphere: Identifiable, Transformable {
	var id = UUID()
	var transform = Matrix.identity
	var material = Material()
}

extension Sphere {
	func normal(at worldPoint: Tuple) -> Tuple { /*Point, Vector*/
		assert(worldPoint.type == .point)
		
		let objectPoint = transform.inverse() * worldPoint
		let objectNormal = objectPoint - Point(0, 0, 0)
		var worldNormal = transform.inverse().transpose() * objectNormal
		worldNormal.w = 0
		return worldNormal.normalizing() //Vector(point.x, point.y, point.z)
	}
}

extension Sphere: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}

protocol Transformable {
	var transform: Matrix { get }
}
