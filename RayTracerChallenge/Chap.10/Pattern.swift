//
//  Pattern.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/28.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Pattern {
	var a: Color
	var b: Color
	var transform = Matrix.identity
	
	init(_ colorA: Color, _ colorB: Color) {
		self.a = colorA
		self.b = colorB
	}
	
	static func stripe(_ color1: Color, _ color2: Color) -> Pattern {
		Pattern(color1, color2)
	}
	
	static func gradient(_ color1: Color, _ color2: Color) -> Pattern {
		
	}
}

struct Stripe: Pattern {
	
}

extension Pattern {
	func pattern(at point: Tuple) -> Color {
		return Color(r: point.x, g: point.y, b: point.z)
	}
	
	func pattern(of object: Shape, at point: Tuple /*Point*/) -> Color {
		let patternTransformInversed = self.transform.inverse()
		let objectTransformInversed = object.transform.inverse()
		return pattern(at: patternTransformInversed * objectTransformInversed * point)
	}
	
	func stripe(at point: Tuple) -> Color {
		if point.x == 0 { return a }
		if point.x > 0 {
			return Int(floor(point.x)).isEven ? b : a
		}
		else {
			return Int(ceil(abs(point.x))).isEven ? b : a
		}
	}
	
	func stripe(of object: Shape, at worldPoint: Tuple) -> Color {
		let objectPoint = object.transform.inverse() *  worldPoint
		let patternPoint = self.transform.inverse() * objectPoint
		return stripe(at: patternPoint)
	}
}


extension Pattern {
	static var _test: Pattern {
		var p = Pattern(.white, .black)
		p.transform = Matrix.identity
		return p
	}
}
