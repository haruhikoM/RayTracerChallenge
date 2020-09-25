//
//  Helpers.swift
//  RayTracerChallenge
//
//  Created by Minamiguchi Haruhiko on 2020/09/15.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

extension Double {
	static let epsilon: Double = 0.00001
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.isAlmostEqual(to: rhs)
	}
	
	static func === (lhs: Self, rhs: Self) -> Bool {
		lhs.isAlmostEqual(to: rhs)
	}
	
	func isAlmostEqual(to rhs: Double) -> Bool {
		return self-rhs < Double.epsilon && self-rhs > -Double.epsilon
	}
	
	var isInt: Bool {
		!(abs(self) - Double(abs(Int(self))) > Double.epsilon)
	}
}

extension Int {
	var isEven: Bool {
		!(self % 2 == 0)
	}
}

extension Array where Element == Double {
	static func == (lhs: Self, rhs: Self) -> Bool {
		assert(lhs.count == rhs.count)
		return !(lhs.enumerated().contains { !$1.isAlmostEqual(to: rhs[$0]) })
	}
}
