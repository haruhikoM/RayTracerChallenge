//
//  Material.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/24.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Material: Equatable {
	var color = Color.white
	var ambient: Float = 0.1
	var diffuse: Float = 0.9
	var specular: Float = 0.9
	var shininess: Float = 200.0
	
	static func == (lhs: Material, rhs: Material) -> Bool {
		guard
			lhs.color == rhs.color,
			lhs.ambient == rhs.ambient,
			lhs.diffuse == rhs.diffuse,
			lhs.specular == rhs.specular,
			lhs.shininess == rhs.shininess
		else { return false }
		
		return true
	}
}

extension Material {
	func lighting(light: PointLight, point: Tuple, eyeVector: Tuple, normalVector: Tuple) -> Color {
		var _ambient, _diffuse, _specular: Color
		
		let effectiveColor = color * light.intensity
		let lightV = (light.position - point).normalizing()
		_ambient = effectiveColor * self.ambient
		
		let lightDotNormal = lightV.dot(normalVector)
		if lightDotNormal < 0 {
			_diffuse = Color.black
			_specular = Color.black
		}
		else {
			_diffuse = effectiveColor * self.diffuse * lightDotNormal
			let reflectV = -lightV.reflect(normalVector)
			let reflectDotEye = reflectV.dot(eyeVector)
			if reflectDotEye <= 0 {
				_specular = Color.black
			}
			else {
				let factor = pow(reflectDotEye, shininess)
				_specular = light.intensity * self.specular * factor
			}
		}
		return _ambient + _diffuse + _specular
	}
}