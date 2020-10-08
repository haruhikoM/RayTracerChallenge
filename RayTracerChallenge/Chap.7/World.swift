//
//  World.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/24.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct World {
	var light = PointLight(Point(0,0,0), .white)
	var scene = [Shape]()

	mutating func addToScene(objects: Shape...) {
		scene += objects.map { $0 }
	}
}

extension World {
	func isShadowed(_ point: Tuple) -> Bool {
		let v = light.position - point
		let distance = v.magnitude
		let ray = Ray(point, v.normalizing())
		let intersections = intersects(ray)
		let h = intersections.hit()
		
		if case let .one(t, _) = h, t < distance {
			return true
		}
		return false
	}
	
	func intersects(_ ray: Ray) -> Intersection<Shape> {
		let arr = scene.map { ray.intersects($0) }
		var result = Intersection<Shape>.none
		for ix in arr {
			switch ix {
			case .one(_,_): result.add(ix)
			case let .multi(xs):
				xs.forEach { result.add($0) }
			default:
				continue
			}
		}
		return result.sort()
	}
	
	func shadeHit(_ comps: Computation, _ remaining: Int = 4) -> Color {
		let shadowed = isShadowed(comps.overPoint)
		
		let surface = comps.object.material.lighting(
										object: comps.object,
										light: light,
										point: comps.point,
										eyeVector: comps.eyeVector,
										normalVector: comps.normalVector,
										isInShadow: shadowed
										)
		let reflected = reflectedColor(comps, remaining)
		return surface + reflected
	}
	
	
	func color(at r: Ray, _ remaining: Int = 4) -> Color {
		let intersect = intersects(r)
		let hit = intersect.hit()
		
		switch hit {
		case .none: return .black
		case .one(_, _):
			if let comps = Computation.prepare(intersect, r) {
				return shadeHit(comps, remaining)
			}
			fatalError()
		case .multi(_):
			fatalError()
		}
	}
	
	//
	// It looks like this can't be done simply searching
	// same identity object but doing it so on same properties.
	//
	func contains(identicalTo s: Shape) -> Bool {
		scene.contains {
			$0.material == s.material && $0.transform == s.transform
		}
	}
	
	func contains(sameObject s: Shape) -> Bool {
		scene.contains { $0.id == s.id	}
	}
	
	func reflectedColor(_ comps: Computation?, _ remaining: Int = 4) -> Color {
		guard
			let comps = comps,
			let reflectV = comps.reflectVector
		else {
			fatalError("comps should not be nil")
		}
		
		if
			comps.object.material.reflective == 0 || remaining <= 0
		{
			return .black
		}

		let reflectRay = Ray(comps.overPoint, reflectV)
		let color = self.color(at: reflectRay, remaining - 1)
		
		return color * comps.object.material.reflective
	}
	
	func refractedColor(_ comps: Computation?, _ remaining: Int = 4) -> Color? {
		guard let comps = comps else { fatalError() }
		let nRatio = comps.n1! / comps.n2!
		let cosI = comps.eyeVector.dot(comps.normalVector)
		let sin2T = pow(nRatio, 2) * (1 - pow(cosI, 2))
		
		let cosT = sqrt(1.0 - sin2T)
		let direction = comps.normalVector * (nRatio * cosI - cosT) - comps.eyeVector * nRatio
		let refractRay = Ray(comps.underPoint, direction)
		let color = self.color(at: refractRay, remaining - 1) * comps.object.material.transparency
		
		return color
	}
}

extension World {
	static var _default: World {
		var w = World()
		w.light = PointLight(Point(-10,10,-10), .white)
		
		let material = Material(color: Color(r: 0.8, g: 1.0, b: 0.6), diffuse: 0.7, specular: 0.2)
		let s1 = Sphere(material: material)
		
		let scaling = Matrix.scaling(0.5, 0.5, 0.5)
		let s2 = Sphere(transform: scaling)
		
		w.scene.append(s1)
		w.scene.append(s2)
		return w
	}
}
