//
//  Transformation.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/20.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

extension Matrix {
	static func translation(_ x: Float, _ y: Float, _ z: Float) -> Self {
		return Matrix(string: """
		|1|0|0|\(x)|
		|0|1|0|\(y)|
		|0|0|1|\(z)|
		|0|0|0|1|
		""")
	}
	
	func translate(_ x: Float, _ y: Float, _ z: Float) -> Self {
		self * Matrix.translation(x, y, z)
	}
	
	static func scaling(_ x: Float, _ y: Float, _ z: Float) -> Self {
		return Matrix(string: """
		|\(x)|0|0|0|
		|0|\(y)|0|0|
		|0|0|\(z)|0|
		|0|0|0|1|
		""")
	}
	
	func scale(_ x: Float, _ y: Float, _ z: Float) -> Self {
		self * Matrix.scaling(x, y, z)
	}
	
	static func rotation(by axis: Axis, radians r: Float) -> Self {
		let str: String
		switch axis {
		case .x:
			str = """
		|1|0|0|0|
		|0|\(cos(r))|\(-sin(r))|0|
		|0|\(sin(r))|\(cos(r))|0|
		|0|0|0|1|
		"""
		case .y:
			str = """
		|\(cos(r))|0|\(sin(r))|0|
		|0|1|0|0|
		|\(-sin(r))|0|\(cos(r))|0|
		|0|0|0|1|
		"""
		case .z:
			str = """
		|\(cos(r))|\(-sin(r))|0|0|
		|\(sin(r))|\(cos(r))|0|0|
		|0|0|1|0|
		|0|0|0|1|
		"""
		}
		return Matrix(string: str)
	}
	
	func rotate(by axis: Axis, radians r: Float) -> Self {
		self * Matrix.rotation(by: axis, radians: r)
	}
	
	static func shearing(_ xy: Float, _ xz: Float,
						 _ yx: Float, _ yz: Float,
						 _ zx: Float, _ zy: Float) -> Self
	{
		return Matrix(string: """
		|1|\(xy)|\(xz)|0|
		|\(yx)|1|\(yz)|0|
		|\(zx)|\(zy)|1|0|
		|0|0|0|1|
		""")
	}
	
	enum Axis {
		case x, y, z
	}
}

