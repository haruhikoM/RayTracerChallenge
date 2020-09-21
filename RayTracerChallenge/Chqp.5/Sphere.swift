//
//  Sphere.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/21.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Sphere: Identifiable {
	var id = UUID()
}

extension Sphere: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}
