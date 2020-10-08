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
	var underPoint: Tuple = .zero
	var reflectVector: Tuple?
	var n1: Double?
	var n2: Double?
	
	static func prepare(_ i: Intersection<Shape>, _ r: Ray, _ xs: Intersection<Shape>? = nil) -> Computation? {
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
			comps.underPoint = comps.point - comps.normalVector * Double.epsilon
			
			comps.reflectVector = r.direction.reflect(comps.normalVector)
			
			var container = [Shape]()
			let ixs: [Intersection<Shape>] // Maybe I should use AnyIteratable on Intersection enum.
			switch xs {
			case .multi(let _xs): ixs = _xs
			default:
				ixs = [i]
			}
			for ins in ixs {
				if i == ins {
					if container.isEmpty { comps.n1 = 1.0 }
					else {	comps.n1 = container.last!.material.refractiveIndex }
				}
				
				if  container.contains(ins.object!) {
					container = container.filter { $0 != ins.object! }
				}
				else {
					container.append(ins.object!)
				}
				
				if i == ins {
					if container.isEmpty { comps.n2 = 1.0 }
					else { comps.n2 = container.last!.material.refractiveIndex }
					break
				}
			}
		
			return comps
			
		case .multi(_):
			let hit = i.hit()
			let comps = prepare(hit, r)
			return comps
		default:
			return nil
		}
	}
	
//	static func prepare<A>(_ i: Intersection<A>, _ ray: Ray, _ xs: [Intersection<A>]) -> Computation? {
//		var containers = [Double]()
//		for int in xs {
//			if containers.isEmpty {
//
//			}
//		}
//		return nil
//	}
}
