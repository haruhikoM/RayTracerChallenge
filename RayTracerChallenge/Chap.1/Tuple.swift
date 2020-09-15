//
//  Tuple.swift
//  RayTracerChallenge
//
//  Created by Minamiguchi Haruhiko on 2020/09/15.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Tuple {
	var x, y, z, w: Float
	var type: Variant {
		Variant(rawValue: w) ?? .unknown
	}
	enum Variant: Float {
		case point  = 1.0
		case vector = 0.0
		case unknown = 99.9
	}
}

extension Tuple {
	static func + (lhs: Self, rhs: Self) -> Self {
		return Tuple(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
	}
	
	static func - (lhs: Self, rhs: Self) -> Self {
		return Tuple(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
	}
	
	static func * (lhs: Self, rhs: Float) -> Self {
		return Tuple(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs)
	}
	
	static prefix func - (tuple: Self) -> Self {
		return Tuple(x: -tuple.x, y: -tuple.y, z: -tuple.z, w: -tuple.w)
	}
}

extension Tuple: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		if
			lhs.x == rhs.x,
			lhs.y == rhs.y,
			lhs.z == rhs.z,
			lhs.w == rhs.w
		{
			return true
		}
		return false
	}
}

func Point(x: Float, y: Float, z: Float) -> Tuple {
	Tuple(x: x, y: y, z: z, w: 1.0)
}

func Vector(x: Float, y: Float, z: Float) -> Tuple {
	Tuple(x: x, y: y, z: z, w: 0.0)
}
