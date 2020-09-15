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
		let EPSILON: Float = 0.00001
		
		if abs(self-rhs) < EPSILON {
			return true
		}
		return false
	}
}
