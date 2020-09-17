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
}

extension Color {
	var toString: String {
		return "\(r.to8bitInt) \(g.to8bitInt) \(b.to8bitInt)"
	}
}

extension Float {
	var to8bitInt: Int {
		let value = Int((255+1)*self)
		if value > 255 { return 255}
		if value < 0   { return 0 }
		return value
	}
}

extension Color {
	static let white = Color(r: 1, g: 1, b: 1)
	static let black = Color(r: 0, g: 0, b: 0)
}

extension Color {
	
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

