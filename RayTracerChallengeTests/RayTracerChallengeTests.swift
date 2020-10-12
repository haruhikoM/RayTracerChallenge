//
//  RayTracerChallengeTests.swift
//  RayTracerChallengeTests
//
//  Created by Minamiguchi Haruhiko on 2020/09/15.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import XCTest
@testable import RayTracerChallenge

class RayTracerChallengeTests: XCTestCase {
	var e = Exercise()
	
	func _test_chap1() throws {	e.chap1() }
	func _test_chap2() throws {	e.chap2() }
//	func _test_chap3() throws {	e.chap3() }
	func _test_chap4() throws {	e.chap4() }
	func _test_chap5() throws {	e.chap5() }
	func _test_chap6() throws {	e.chap6() }
	func _test_chap7() throws {	e.chap7() }
	func _test_chap8() throws {	e.chap7() }
	func _test_chap9() throws {	e.chap9() }
	func _test_chap10_mid() throws {	e.chap10_stripeTrial() }
	func _test_chap10() throws {	e.chap10() }
	func _test_chap11_1() throws { e.chap11_1() }
	func _test_pit() throws {
		e.chap_10_blendedPatterns()
	}
}
