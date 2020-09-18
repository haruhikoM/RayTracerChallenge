//
//  Tuple.swift
//  RayTracerChallenge
//
//  Created by Minamiguchi Haruhiko on 2020/09/15.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

protocol Tuplize {
	var x: Float { get }
	var y: Float { get }
	var z: Float { get }
	var w: Float { get }
}

struct Tuple: CustomStringConvertible {
	var x, y, z, w: Float
	var type: Variant {
		Variant(rawValue: w) ?? .unknown
	}
	enum Variant: Float {
		case point  = 1.0
		case vector = 0.0
		case unknown = 99.9
		
		var toString: String {
			switch self {
			case .point:  return "Point"
			case .vector: return "Vector"
			default:
				return "unknwon"
				
			}
		}
	}
	
	var description: String {
		get {
			"[Tuple(\(type.toString))](x: \(x), y: \(y), z: \(z))"
		}
	}
	
	var toMatrix: Matrix {
		var m = Matrix(4, 1)
		m[0, 0] = x
		m[1, 0] = y
		m[2, 0] = z
		m[3, 0] = w
		return m
	}
}

extension Tuple {
	var magnitude: Float {
		assert(type == .vector)
		return sqrt(x*x + y*y + z*z + w*w)
	}
	
	func normalizing() -> Self {
		Tuple(x: x/magnitude, y: y/magnitude, z: z/magnitude, w: w/magnitude)
	}
	
	mutating func normalized() {
		self = self.normalizing()
		// # Should self be returned?
		// ... -> Self {
		//   ...
		//   return self
		// }
	}
	
	/// dot product; a.k.a. scalar product or inner product
	/// the smaller the dot product, the larger the angle between the vectors
	///
	func dot(_ other: Tuple) -> Float {
		x * other.x + y * other.y + z * other.z + w * other.w
	}
	
	func cross(_ other: Tuple) -> Tuple {
		assert(type == .vector)
		assert(other.type == .vector)
		return Vector(
			x: y*other.z - z*other.y,
			y: z*other.x - x*other.z,
			z: x*other.y - y*other.x
		)
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
	
	static func / (lhs: Self, rhs: Float) -> Self {
		return Tuple(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs)
	}
	
	static prefix func - (tuple: Self) -> Self {
		return Tuple(x: -tuple.x, y: -tuple.y, z: -tuple.z, w: -tuple.w)
	}
}

extension Tuple: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		if
			lhs.x.isEqual(to: rhs.x),
			lhs.y.isEqual(to: rhs.y),
			lhs.z.isEqual(to: rhs.z),
			lhs.w.isEqual(to: rhs.w)
		{
			return true
		}
		return false
	}
}

func Point(x: Float, y: Float, z: Float) -> Tuple {
	Tuple(x: x, y: y, z: z, w: 1.0)
}

/// Vector -> a value that encoded DIRECTION and DISTANCE.
/// The DISTANCE represented by a vector -> its MAGNITUDE or LENGTH
func Vector(x: Float, y: Float, z: Float) -> Tuple {
	Tuple(x: x, y: y, z: z, w: 0.0)
}
