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
	var rows: [[Double]]
	var size: (Int, Int) {
		(rows.count, rows.first!.count)
	}
	
	init(_ row: Int, _ column: Int, _ element: Double = 0.0) {
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
				self[rowIdx, columnIdx] = Double(val)!
			}
		}
	}

	subscript(_ rowIdx: Int, _ columnIdx: Int) -> Double {
		get {
			rows[rowIdx][columnIdx]
		}
		set {
			rows[rowIdx][columnIdx] = newValue
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
	
	static func / (lhs: Matrix, rhs: Double) -> Matrix {
		var mat = Matrix(lhs.size.0, lhs.size.1)
		for rowIdx in 0..<lhs.size.0 {
			for colIdx in 0..<lhs.size.1 {
				mat[colIdx, rowIdx] = lhs[rowIdx, colIdx] / rhs
			}
		}
		return mat
	}
}

extension Matrix {
	static var identity: Matrix {
		Matrix(string: """
		|1|0|0|0|
		|0|1|0|0|
		|0|0|1|0|
		|0|0|0|1|
		"""
		)
	}
	
	func transpose() -> Matrix {
		var tempMat = Matrix(size.1, size.0)
		for rowIdx in 0..<size.0 {
			for colIdx in 0..<size.1 {
				tempMat[colIdx, rowIdx] = self[rowIdx, colIdx]
			}
		}
		// self = tempMat
		return tempMat
	}
	
	func determinant() -> Double {
		if self.size == (2, 2) {
			return self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0]
		}
		else {
			let rowIdx = 0
			return rows[rowIdx].enumerated().map { $1 * cofactor(rowIdx, $0) }.reduce(0, +)
		}
	}
	
	func submatrix(_ row: Int, _ column: Int) -> Matrix {
		var copy = self
		copy.rows.remove(at: row)
		for (idx,row) in copy.rows.enumerated() {
			var rowCopy = row
			rowCopy.remove(at: column)
			copy.rows[idx] = rowCopy
		}
		return copy
	}
	
	func minor(_ row: Int, _ column: Int) -> Double {
		let sub = submatrix(row, column)
		return sub.determinant()
	}
	
	func cofactor(_ row: Int, _ column: Int) -> Double {
		let minor = self.minor(row, column)
		return (row+column).isEven ? -minor : minor
	}
	
	func inverse() /*throws*/ -> Matrix {
		// if !isInvertible { throw MatrixError.uninvertibleError }
		assert(isInvertible)
		
		var mat = Matrix(size.0, size.1)
		for rowIdx in 0..<size.0 {
			for colIdx in 0..<size.1 {
				 let cof = cofactor(rowIdx, colIdx)
				mat[colIdx, rowIdx] = cof / determinant()
			}
		}
		return mat
	}
	
	var isInvertible: Bool { !(determinant() == 0) }
	
	enum MatrixError: Error {
		case uninvertibleError
	}
}

extension Matrix: Equatable {
	static func == (lhs: Matrix, rhs: Matrix) -> Bool {
		guard
			lhs.size.0 == rhs.size.0,
			lhs.size.1 == rhs.size.1 else { return false }
		
		for (idx, lrow) in lhs.rows.enumerated() {
			if !(lrow == rhs.rows[idx]) { return false }
		}
		return true
	}
}
