//
//  Helpers.swift
//  RayTracerChallenge
//
//  Created by Minamiguchi Haruhiko on 2020/09/15.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

extension Float {
	static let epsilon: Float = 0.00001
	
	static func === (rhs: Self, lhs: Self) -> Bool {
		rhs.isEqual(to: lhs)
	}
	
	func isEqual(to rhs: Float) -> Bool {
		if abs(self-rhs) < Float.epsilon {
			return true
		}
		return false
	}
	
	var isInt: Bool {
		!(abs(self) - Float(abs(Int(self))) > Float.epsilon)
	}
}

extension Int {
	var isEven: Bool {
		!(self % 2 == 0)
	}
}

extension Array where Element == Float {
	static func == (lhs: Self, rhs: Self) -> Bool {
		!(lhs.enumerated().contains(where: { !$1.isEqual(to: rhs[$0]) }))
	}
}
