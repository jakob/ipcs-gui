//
//  ContentView.swift
//  IPCS
//
//  Created by Jakob Egger on 11.02.22.
//

import SwiftUI

struct ContentView: View {
	
	@State var segments: [SharedMemorySegment]
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack() {
				Text("Shared Memory Segments")
					.font(.largeTitle)
				Spacer()
				Button(
					action: {
						segments = try! SharedMemorySegment.all()
					},
					label: {
						Image(systemName: "arrow.clockwise")
					}
				).controlSize(.large)
				
			}
			Table(segments) {
				TableColumn("Size") { segment in
					Text("\(segment.size) bytes").frame(minHeight: 50)
				}
				TableColumn("Created By") { segment in
					processCell(segment.createProcess!)
				}
				TableColumn("Last Operation") { segment in
					processCell(segment.lastOperationProcess!)
				}
				TableColumn("Last Attach") { segment in
					dateCell(segment.attachDate)
				}
				TableColumn("Last Detach") { segment in
					dateCell(segment.detachDate)
				}
				TableColumn("Last Ctl") { segment in
					dateCell(segment.controlDate)
				}
				TableColumn("Attaches") { segment in
					Text(String(segment.numAttaches)).frame(minHeight: 50)
				}.width(max: 60)
			}
			.monospacedDigit()
			.tableStyle(.bordered)
		}
		.padding()
	}
	
	
	func processCell(_ process: UnixProcessInfo) -> some View {
		HStack {
			if let icon = process.appIcon {
				Image(nsImage: icon)
			}
			VStack(alignment: .leading, spacing: 2) {
				Text("\(process.name) (\(String(process.pid)))")
				Text(process.path).font(Font.caption).foregroundColor(.secondary)
			}.lineLimit(1).textSelection(.enabled)
		}
	}
	
	func dateCell(_ date: Date) -> some View {
		VStack(alignment: .leading, spacing: 2) {
			Text("\(Self.dateFormatter.string(from: date))")
			Text("\(relativeFormat(date:date))").font(Font.caption).foregroundColor(.secondary)
		}.lineLimit(1).frame(minHeight: 50)
	}
	
	static let dateFormatter: DateFormatter = {
		let fmt = DateFormatter()
		fmt.dateFormat = "YYYY-MM-dd HH:mm:ss"
		fmt.timeZone = .autoupdatingCurrent
		return fmt
	}()
	
	func relativeFormat(date: Date) -> String {
		let interval = round(date.timeIntervalSinceNow);
		let seconds = Int(abs(interval))
		let minutes = Int(abs(interval) / 60)
		let hours = Int(round(abs(interval) / 3600))
		let days = Int(round(abs(interval) / 86400))
		let interval_string: String
		if hours > 23 && days > 1 {
			interval_string = "\(days) days"
		}
		else if hours > 23 && days == 1 {
			interval_string = "1 day"
		}
		else if minutes > 60 && hours > 1 {
			interval_string = "\(hours) hours"
		}
		else if minutes > 60 && hours == 1 {
			interval_string = "1 hour"
		}
		else if minutes > 1 {
			interval_string = "\(minutes) minutes"
		}
		else if minutes == 1 {
			interval_string = "1 minute"
		}
		else if seconds == 1 {
			interval_string = "1 second"
		}
		else {
			interval_string = "\(seconds) seconds"
		}
		if interval <= 0 {
			return "\(interval_string) ago"
		} else {
			return "in \(interval_string)"
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(segments: try! SharedMemorySegment.all())
    }
}
