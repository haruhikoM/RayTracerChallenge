//
//  Camera.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/25.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Camera {
	var hSize: Int
	var vSize: Int
	var fieldOfView: Float
	var transform = Matrix.identity
	var pixelSize: Float {
		return 0.01
	}
	
	init(_ hSize: Int, _ vSize: Int, _ fieldOfView: Float) {
		self.hSize = hSize
		self.vSize = vSize
		self.fieldOfView = fieldOfView
	}
}
