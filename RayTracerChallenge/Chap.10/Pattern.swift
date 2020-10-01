//
//  Pattern.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/28.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

//
// Or, should I use enum instead?
// It feels more suited to me.
//
//enum PatternType {
//	case stripe(Color, Color)
//	case gradient(Color, Color)
//}
// struct Pattern {
//     struct Stripe {

protocol Pattern {
	var a: Color { get }
	var b: Color { get }
	var transform: Matrix { get set }
	
	init(_: Color, _:Color, _ transform: Matrix)
	func pattern(at point: Tuple) -> Color
}

struct Stripe: Pattern {
	var a: Color
	var b: Color
	var transform: Matrix
	
	init(_ colorA: Color, _ colorB: Color, _ transform: Matrix = Matrix.identity) {
		a = colorA
		b = colorB
		self.transform = transform
	}
	
	func pattern(at point: Tuple) -> Color {
		if point.x == 0 { return a }
		if point.x > 0 {
			return Int(floor(point.x)).isEven ? b : a
		}
		else {
			return Int(ceil(abs(point.x))).isEven ? b : a
		}
	}
	
	func pattern(of object: Shape, at worldPoint: Tuple) -> Color {
		let objectPoint = object.transform.inverse() *  worldPoint
		let patternPoint = self.transform.inverse() * objectPoint
		return pattern(at: patternPoint)
	}
}

struct Gradient: Pattern {
	var a: Color
	var b: Color
	var transform: Matrix
	
	init(_ colorA: Color, _ colorB: Color, _ transform: Matrix = Matrix.identity) {
		a = colorA
		b = colorB
		self.transform = transform
	}
	
	func pattern(at point: Tuple) -> Color {
		let distance = b - a
		let fraction = point.x - floor(point.x)
		
		return a + distance * fraction
	}
}

struct Ring: Pattern {
	var a: Color
	var b: Color
	var transform: Matrix
	
	init(_ colorA: Color, _ colorB: Color, _ transform: Matrix = Matrix.identity) {
		a = colorA
		b = colorB
		self.transform = transform
	}

	func pattern(at point: Tuple) -> Color {
		Int(floor(sqrt(pow(point.x, 2)+pow(point.z, 2)))) % 2 == 0 ? a : b
	}
}

struct Checker: Pattern {
	var a: Color
	var b: Color
	var transform: Matrix
	
	init(_ colorA: Color, _ colorB: Color, _ transform: Matrix = Matrix.identity) {
		a = colorA
		b = colorB
		self.transform = transform
	}

	func pattern(at point: Tuple) -> Color {
		Int(floor(point.x) + floor(point.y) + floor(point.z)) % 2 == 0 ? a : b
	}
}

struct TestPattern: Pattern {
	var a: Color
	var b: Color
	var transform: Matrix
	
	init(_ colorA: Color, _ colorB: Color, _ transform: Matrix = Matrix.identity) {
		a = colorA
		b = colorB
		self.transform = transform
	}

	func pattern(at point: Tuple) -> Color {
		return Color(r: point.x, g: point.y, b: point.z)
	}

	static var _test: TestPattern {
		var p = TestPattern(.white, .black)
		p.transform = Matrix.identity
		return p
	}
}

extension Pattern {
//	func pattern(at point: Tuple) -> Color {
//		// THIS NEEDS TO BE OVERRIDDEN!
//		return Color(r: point.x, g: point.y, b: point.z)
//	}
	
	func pattern(of object: Shape?, at point: Tuple /*Point*/) -> Color {
		let patternTransformInversed = self.transform.inverse()
		if let o = object {
			let objectTransformInversed = o.transform.inverse()
			return pattern(at: patternTransformInversed * objectTransformInversed * point)
		}
		return pattern(at: patternTransformInversed * point)
	}

}
