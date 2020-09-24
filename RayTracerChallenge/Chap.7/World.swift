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
	var scene = [SceneObject]()
}

extension World {
	func intersects(_ ray: Ray) -> Intersection<SceneObject> {
		let arr = scene.map { ray.intersects($0) }
		var result = Intersection<SceneObject>.none
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
	
	func shadeHit(_ comps: Computation) -> Color {
		return comps.object.material.lighting(
										light: light,
										point: comps.point,
										eyeVector: comps.eyeVector,
										normalVector: comps.normalVector
										)
	}
	
	
	func color(at r: Ray) -> Color {
		let intersect = intersects(r)
		let hit = intersect.hit()
		
		switch hit {
		case .none: return .black
		case .one(_, _):
			if let comps = Computation.prepare(intersect, r) {
				return shadeHit(comps)
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
	func contains(identicalTo s: SceneObject) -> Bool {
		scene.contains {
			$0.material == s.material && $0.transform == s.transform
		}
	}
	
	func contains(sameObject s: SceneObject) -> Bool {
		scene.contains { $0.id == s.id	}
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
