//
//  SharedMemorySegment.swift
//  IPCS
//
//  Created by Jakob Egger on 11.02.22.
//

import Foundation

struct SharedMemorySegment {
	let size: Int
	let createProcess: UnixProcessInfo?
	let lastOperationProcess: UnixProcessInfo?
	let numAttaches: Int
	let attachDate: Date
	let detachDate: Date
	let controlDate: Date
	
	init(shmid_ds: __shmid_ds_new) {
		self.size = shmid_ds.shm_segsz
		self.createProcess = UnixProcessInfo(runningProcessWithPid: shmid_ds.shm_cpid)
		self.lastOperationProcess = UnixProcessInfo(runningProcessWithPid: shmid_ds.shm_lpid)
		self.numAttaches = Int(shmid_ds.shm_nattch)
		self.attachDate = Date(timeIntervalSince1970: TimeInterval(shmid_ds.shm_atime))
		self.detachDate = Date(timeIntervalSince1970: TimeInterval(shmid_ds.shm_dtime))
		self.controlDate = Date(timeIntervalSince1970: TimeInterval(shmid_ds.shm_ctime))
	}
	
	static func all() throws -> [SharedMemorySegment] {
		var result = [SharedMemorySegment]()
		var cursor: Int32 = 0
		var sysres: Int32 = 0
		while (sysres == 0) {
			var ds = __shmid_ds_new()
			withUnsafeMutablePointer(to: &ds) { shmptr in
				var ic = IPCS_command(
					ipcs_magic: IPCS_MAGIC,
					ipcs_op: IPCS_SHM_ITER,
					ipcs_cursor: cursor,
					ipcs_datalen: Int32(MemoryLayout<__shmid_ds_new>.size),
					ipcs_data: shmptr
				);
				var ic_out = IPCS_command()
				var ic_size: Int = MemoryLayout<IPCS_command>.size
				sysres = sysctlbyname(IPCS_SHM_SYSCTL, &ic_out, &ic_size, &ic, ic_size)
				cursor = ic_out.ipcs_cursor
			}
			if (sysres == 0) {
				result.append(SharedMemorySegment(shmid_ds: ds))
			}
		}
		if (errno == ENOENT || errno == ERANGE) {
			return result
		} else {
			throw POSIXError(POSIXError.Code(rawValue: errno)!)
		}
	}
}
