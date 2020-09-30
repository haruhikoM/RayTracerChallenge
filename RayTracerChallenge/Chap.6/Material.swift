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
	var ambient: Double = 0.1
	var diffuse: Double = 0.9
	var specular: Double = 0.9
	var shininess: Double = 200.0
	var pattern: Pattern?
	
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
	func lighting(object: Shape = Sphere(), light: PointLight, point: Tuple, eyeVector: Tuple, normalVector: Tuple, isInShadow: Bool = false) -> Color {
		let _color = pattern != nil ? pattern!.stripe(of: object, at: point) : self.color
		
		var _ambient, _diffuse, _specular: Color
		
		let effectiveColor = _color * light.intensity
		let lightV = (light.position - point).normalizing()
		_ambient = effectiveColor * self.ambient
		
		guard !isInShadow else { return _ambient }
		
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
