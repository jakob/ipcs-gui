//
//  SharedMemorySegmentTests.swift
//  IPCSTests
//
//  Created by Jakob Egger on 11.02.22.
//

import XCTest
@testable import IPCS

class SharedMemorySegmentTests: XCTestCase {
	
	func testExample() throws {
		let segs = try SharedMemorySegment.all()
		print(segs)
	}
	
}
