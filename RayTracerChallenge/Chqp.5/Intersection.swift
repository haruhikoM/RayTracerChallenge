//
//  Intersection.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/22.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

//func intersection(_ t: Float, _ s: Sphere) -> IntersectionType {
//
//}

enum Intersection<U: Identifiable>: Equatable {
	case none
	case one(_ t: Float, _ object: U)
//	indirect case two(_ i1: Intersection, _ i2: Intersection)
	indirect case multi([Intersection])

	init(_ t: Float, _ object: U) {
		self = .one(t, object)
	}
//	init(_ i1: Intersection, _ i2: Intersection) {
//		self = .multi([i1, i2])
//	}
	init(_ intersections: Intersection...) {
		self = .multi(intersections)
	}

	subscript(_ idx: Int) -> Intersection {
		switch self {
		case let .multi(xs): return xs[idx]
		default:
			return .none
		}
	}
	
	static func == (lhs: Intersection<U>, rhs: Intersection<U>) -> Bool {
		switch (lhs, rhs) {
		case (.none, .none): return true
		case let (.one(t1, o1), .one(t2, o2)):
			return t1 == t2 && o1.id == o2.id
//		case let (.two(i1, i2), .two(i3, i4)):
//			return i1 == i3 && i2 == i4
		case (.multi, .multi):
			fatalError("Have not implemented yet")
		default:
			return false
		}
	}
}

extension Intersection {
	var t: Float? {
		switch self {
		case let .one(t, _): return t
		default:
			return nil
		}
	}
	
	var object: U? {
		switch self {
		case let .one(_, o): return o
		default:
			return nil
		}
	}
	
	var count: Int {
		switch self {
		case let .multi(xs): return xs.count
		default:
			return 0
		}
	}
}

extension Intersection {
	func hit() -> Intersection {
		switch self {
//		case let .two(i1, i2):
//			guard i1.t! > 0 || i2.t! > 0 else { return .none }
//			return i1.t! > i2.t! ? i1 : i2
		case let .multi(xs):
			return xs.filter { $0.t! > 0 }.sorted(by: { $0.t! < $1.t! } ).first ?? .none
		default:
			return .none
		}
	}
}


//
//
//enum _Tuple {
//	case point
//	case vector
//	case tuple
//}

//enum Intersection<T, U> {
//	case none
//	case single(T, U)
//	indirect case multi(Intersection<T, U>, Intersection<T, U>)
//}
