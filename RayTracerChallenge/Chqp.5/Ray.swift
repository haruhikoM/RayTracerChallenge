//
//  Ray.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Ray {
	var origin: Tuple
	var direction: Tuple // speed
	init(_ origin: Tuple, _ direction: Tuple) {
		self.origin = origin
		self.direction = direction
	}
}

//typealias IntersectionType = [Float]
extension Ray {
	func intersects<T: Transformable>(_ object: T) -> Intersection<T> {
		let ray2 = transform(Matrix.inverse(object.transform)())
		let sphereToRay = ray2.origin - Point(0, 0, 0)//<-sphere's origin
		let a = ray2.direction.dot(ray2.direction)
		let b = 2 * ray2.direction.dot(sphereToRay)
		let c = sphereToRay.dot(sphereToRay) - 1
		let discriminant = pow(b, 2) - 4 * a * c
		if discriminant < 0 {
			return .none
		}
		else {
			let t1 = (-b - sqrt(discriminant)) / (2 * a)
			let t2 = (-b + sqrt(discriminant)) / (2 * a)
			return .multi([.one(t1, object), .one(t2, object)])
		}
	}
	
	func transform(_ m: Matrix) -> Ray {
		let p = m * origin
		let d = m * direction
		return Ray(p, d)
	}
}

extension Ray {
	func position(_ time: Float) -> Tuple {
		origin + (direction * time)
		/* d = s * t */
	}
}
