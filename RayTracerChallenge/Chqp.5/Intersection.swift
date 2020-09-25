//
//  Intersection.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/22.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

enum Intersection<U: Identifiable>: Equatable {
	case none
	case one(_ t: Double, _ object: U)
	indirect case multi([Intersection])

	init(_ t: Double, _ object: U) {
		self = .one(t, object)
	}

	init(_ intersections: Intersection...) {
		self = .multi(intersections)
	}
	
	init(_ intersectionArray: [Intersection]) {
		self = .multi(intersectionArray)
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
		case (.multi, .multi):
			fatalError("Have not implemented yet")
		default:
			return false
		}
	}
	
	mutating func add(_ intersection: Intersection) {
		switch self {
		case .none: self = intersection
		case .one(_,_): self = .multi([self, intersection])
		case let .multi(xs):
			var muteXS = xs
			muteXS.append(intersection)
			self = .multi(muteXS)
		}
	}
	
	func sort() -> Intersection {
		switch self {
		case .one(_,_): return self
		case let .multi(xs): return Intersection(xs.sorted(by: { $0.t! < $1.t! }))
		case .none: return self
		}
	}
}

extension Intersection {
	var t: Double? {
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
		case .one(_, _): return self
		case let .multi(xs):
			return xs.filter { $0.t! > 0 }.sorted(by: { $0.t! < $1.t! } ).first ?? .none
		default:
			return .none
		}
	}
}
