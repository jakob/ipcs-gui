//
//  UnixProcessInfo.swift
//  IPCS
//
//  Created by Jakob Egger on 11.02.22.
//

import Foundation

struct UnixProcessInfo {
	let pid: Int
	let path: String

	var name: String {
		String(path.split(separator: "/").last!)
	}

	init(runningProcessWithPid pid: pid_t) {
		self.pid = Int(pid)
		var path = [UInt8](repeating: 0, count: Int(PROC_PIDPATHINFO_SIZE))
		let status = proc_pidpath(pid, &path, UInt32(path.count))
		if status > 0 {
			self.path = String(cString: path)
		} else {
			self.path = "Error \(String(cString:strerror(errno)!))"
		}
	}
}
