//
//  Light.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/24.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct PointLight {
	var position: Tuple
	var intensity: Color
	init(_ position: Tuple, _ intensity: Color) {
		self.position = position
		self.intensity = intensity
	}
}
