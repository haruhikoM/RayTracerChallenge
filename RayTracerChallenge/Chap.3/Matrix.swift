//
//  Matrix.swift
//  RayTracerChallenge
//
//  Created by Haruhiko Minamiguchi on 2020/09/18.
//  Copyright © 2020 Minamiguchi Haruhiko. All rights reserved.
//

import Foundation

struct Matrix {
	typealias Coordinate = (rows: Int, colums: Int)
	var rows: [[Float]]
	var size: (Int, Int) {
		(rows.count, rows.first!.count)
	}
	
	init(_ row: Int, _ column: Int, _ element: Float = 0.0) {
		rows = Array(repeating: Array(repeating: element, count: column), count: row)
	}
	
	init(string: String) {
		let arr = string.components(separatedBy: "\n").filter { !$0.isEmpty }
		var newArray = [String]()
		for el in arr {
			var ch = el
			ch.removeFirst()
			ch.removeLast()
			ch = ch.replacingOccurrences(of: "|", with: ",")
			ch = ch.replacingOccurrences(of: " ", with: "")
			ch = ch.replacingOccurrences(of: "\t", with: "")
			newArray.append(ch)
		}
		
		self.init(newArray.count, newArray.first!.components(separatedBy: ",").filter({!$0.isEmpty}).count)
		
		for rowIdx in 0..<size.0 {
			let row = newArray[rowIdx].components(separatedBy: ",")
			for columnIdx in 0..<size.1 {
				let val = row[columnIdx]
				print(val)
				self[rowIdx, columnIdx] = Float(val)!
			}
		}
	}

	subscript(_ rowIndex: Int, _ columnIndex: Int) -> Float {
		get {
			rows[rowIndex][columnIndex]
		}
		set {
			rows[rowIndex][columnIndex] = newValue
		}
	}
}

extension Matrix {
	static func * (lhs: Matrix, rhs: Matrix) -> Matrix {
		var mat = Matrix(lhs.size.0, lhs.size.1)
		
		for row in 0..<lhs.size.0 {
			for col in 0..<lhs.size.1 {
				let sum = (0..<lhs.size.0).map { lhs[row, $0] * rhs[$0, col] }.reduce(0, +)
				mat[row, col] = sum
			}
		}
		
		return mat
	}
	
	static func * (lhs: Matrix, rhs: Tuple) -> Tuple {
		let mat = rhs.toMatrix
		var tempMatrix = Matrix(4, 1)
		for row in 0..<lhs.size.0 {
			let sum = (0..<lhs.size.0).map { lhs[row, $0] * mat[$0, 0] }.reduce(0, +)
			tempMatrix[row, 0] = sum
		}
		return Tuple(x: tempMatrix[0,0], y: tempMatrix[1,0], z: tempMatrix[2,0], w: tempMatrix[3,0])
	}
	
	func transpose() -> Matrix {
		var tempMat = Matrix(size.1, size.0)
		for rowIdx in 0..<size.0 {
			for colIdx in 0..<size.1 {
				tempMat[colIdx, rowIdx] = self[rowIdx, colIdx]
			}
		}
		return tempMat
	}
}

extension Matrix: Equatable {
	static func == (lhs: Matrix, rhs: Matrix) -> Bool {
		guard
			lhs.size.0 == rhs.size.0,
			lhs.size.1 == rhs.size.1 else { return false }
		
		for (idx, lrow) in lhs.rows.enumerated() {
			if lrow != rhs.rows[idx] { return false }
		}
		
		return true
	}
}

extension Float {
	var isInt: Bool {
		!(abs(self) - Float(abs(Int(self))) > Float.epsilon)
	}
}

 
