//
//  Sphere.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

class Sphere: SceneObject {
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

class SceneObject: Identifiable {
	let id: UUID = UUID()
	var transform: Matrix
	var material: Material
	
	init(_ transform: Matrix, _ material: Material) {
		self.transform = transform
		self.material = material
	}
}

extension SceneObject: Equatable {
	static func == (lhs: SceneObject, rhs: SceneObject) -> Bool {
		lhs.id == rhs.id
	}
}
