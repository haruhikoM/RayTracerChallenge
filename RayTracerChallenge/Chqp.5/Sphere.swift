//
//  Sphere.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

class Sphere: Shape {
//	var id = UUID()
//	var material = Material()
	init(material: Material) {
		super.init(Matrix.identity, material)
	}
	
	init(transform: Matrix) {
		super.init(transform, Material())
	}
	
	init() {
		super.init(Matrix.identity, Material())
	}
}

class Shape: Identifiable {
	let id: UUID = UUID()
	var transform: Matrix
	var material: Material
	
	fileprivate var localIntersect: (Shape, Ray) -> Intersection<Shape> = { s, r in
		// Need to override inside child objects.
		r.intersects(s)
	}
	
	fileprivate var localNormal: (Shape, Tuple) -> Tuple = { _, p in
		// Need to override inside child objects.
		Vector(p.x, p.y, p.z)
	}
	
	var savedRay: Ray?
	
	init(_ transform: Matrix, _ material: Material) {
		self.transform = transform
		self.material = material
	}
	
	func intersect(_ ray: Ray) -> Intersection<Shape>? {
		let localRay = ray.transform(transform.inverse())
		savedRay = localRay
		return  localIntersect(self, localRay)
	}
}

extension Shape {
	static var testShape: Shape {
		return Shape(Matrix.identity, Material())
	}
}

extension Shape: Equatable {
	static func == (lhs: Shape, rhs: Shape) -> Bool {
		lhs.id == rhs.id
	}
}

extension Shape {
	func normal(at worldPoint: Tuple) -> Tuple { /*Point, Vector*/
		assert(worldPoint.type == .point)
		
		let objectPoint = transform.inverse() * worldPoint
		let objectNormal = localNormal(self, objectPoint - Point(0, 0, 0))
		var worldNormal = transform.inverse().transpose() * objectNormal
		worldNormal.w = 0
		return worldNormal.normalizing() //Vector(point.x, point.y, point.z)
	}
}

