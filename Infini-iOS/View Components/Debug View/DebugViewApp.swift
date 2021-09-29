//
//  DebugViewApp.swift
//  Infini-iOS
//
//  Created by Alex Emry on 9/29/21.
//  
//
    

import SwiftUI

struct DebugViewApp: View {
	@ObservedObject var bleManager = BLEManager.shared
	@ObservedObject var logManager = DebugLogManager.shared
	
	var body: some View {
		VStack {
			Text("App Logs")
				.font(.title)
			List {
				ForEach(0..<logManager.logFiles.appLogEntries.count, id: \.self) { entry in
					Text(logManager.logFiles.appLogEntries[entry].date + " - " + logManager.logFiles.appLogEntries[entry].additionalInfo)
				}
			}
		}
	}
}
