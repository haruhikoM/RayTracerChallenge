//
//  Color.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/16.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Color: Equatable {
	var r, g, b: Float
	
	var red: Float { return r }
	var green: Float { return g }
	var blue: Float { return b }
	
	static func + (lhs: Color, rhs: Color) -> Color {
		return Color(r: lhs.r + rhs.r, g: lhs.g + rhs.g, b: lhs.b + rhs.b)
	}
	
	static func - (lhs: Color, rhs: Color) -> Color {
		return Color(r: lhs.r - rhs.r, g: lhs.g - rhs.g, b: lhs.b - rhs.b)
	}
	
	static func * (lhs: Color, rhs: Float) -> Color {
		return Color(r: lhs.r * rhs, g: lhs.g * rhs, b: lhs.b * rhs)
	}
	
	//
	// This creates the thing called: Hadamard product (or Schur product).
	//
	static func * (lhs: Color, rhs: Color) -> Color {
		return Color(r: lhs.r * rhs.r, g: lhs.g * rhs.g, b: lhs.b * rhs.b)
	}
	
	static func == (lhs: Color, rhs: Color) -> Bool {
		return lhs.r === rhs.r && lhs.g === rhs.g && lhs.b === rhs.b
	}
}


