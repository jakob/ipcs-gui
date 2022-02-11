//
//  UnixProcessInfoTests.swift
//  IPCSTests
//
//  Created by Jakob Egger on 11.02.22.
//

import XCTest
@testable import IPCS

class UnixProcessInfoTests: XCTestCase {
	
	func testProcessName() throws {
		let pid = getpid()
		let processInfo = UnixProcessInfo(runningProcessWithPid: pid)
		XCTAssertEqual(processInfo.name, ProcessInfo.processInfo.processName)
	}
	
}
