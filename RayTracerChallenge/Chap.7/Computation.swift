//
//  Computation.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/24.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Computation {
	var t: Double
	var object: Shape
	var point: Tuple        // Point
	var eyeVector: Tuple    // Vector
	var normalVector: Tuple // Vector
	var inside = false
	var overPoint: Tuple = .zero // Point
	var reflectVector: Tuple?
	
	static func prepare(_ i: Intersection<Shape>, _ r: Ray) -> Computation? {
		switch i {
		case let .one(t, obj):
			var comps = Computation(
				t: t,
				object: obj,
				point: r.position(t),
				eyeVector: -r.direction,
				normalVector: obj.normal(at: r.position(t))
			)
			
			if comps.normalVector.dot(comps.eyeVector) < 0 {
				comps.inside = true
				comps.normalVector = -comps.normalVector
			}
			comps.overPoint = comps.point + comps.normalVector * Double.epsilon
			comps.reflectVector = r.direction.reflect(comps.normalVector)
			return comps
		case .multi(_):
			let hit = i.hit()
			let comps = prepare(hit, r)
			return comps
		default:
			return nil
		}
	}
}
