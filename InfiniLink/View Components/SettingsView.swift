//
//  SettingsView.swift
//  InfiniLink
//
//  Created by Alex Emry on 8/15/21.
//  
//
    

import Foundation
import SwiftUI

struct Settings_Page: View {
	
	@ObservedObject var bleManager = BLEManager.shared
	@ObservedObject var deviceInfo = BLEDeviceInfo.shared
	@ObservedObject var pageSwitcher = PageSwitcher.shared
	@Environment(\.colorScheme) var colorScheme
	
	@AppStorage("watchNotifications") var watchNotifications: Bool = true
	@AppStorage("autoconnect") var autoconnect: Bool = false
	@AppStorage("batteryNotification") var batteryNotification: Bool = false
	@AppStorage("autoconnectUUID") var autoconnectUUID: String = ""
	@AppStorage("heartChartFill") var heartChartFill: Bool = true
	@AppStorage("batChartFill") var batChartFill: Bool = true
	@AppStorage("debugMode") var debugMode: Bool = false
	@AppStorage("showNewDownloadsOnly") var showNewDownloadsOnly: Bool = false
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ChartDataPoint.timestamp, ascending: true)])
	private var chartPoints: FetchedResults<ChartDataPoint>
	
	@State private var changedName: String = ""
	private var nameManager = DeviceNameManager()
	@State private var deviceName = ""
	
	var body: some View {
		VStack {
			Text("Settings")
				.font(.largeTitle)
				.padding()
				.frame(maxWidth: .infinity, alignment: .leading)
			List {
				Section(header: Text("Connect Options")) {
					Toggle("Autoconnect to PineTime", isOn: $autoconnect)
					Button {
						autoconnectUUID = bleManager.setAutoconnectUUID
						DebugLogManager.shared.debug(error: "Autoconnect Device UUID: \(autoconnectUUID)", log: .app, date: Date())
					} label: {
						Text("Use Current Device for Autoconnect")
					}.disabled(!bleManager.isConnectedToPinetime || (!autoconnect || (autoconnectUUID == bleManager.infiniTime.identifier.uuidString)))
					Button {
						autoconnectUUID = ""
						DebugLogManager.shared.debug(error: "Autoconnect Device Cleared", log: .app, date: Date())
					} label: {
						Text("Clear Autoconnect Device")
					}.disabled(!autoconnect || autoconnectUUID.isEmpty)
				}
				Section(header: Text("Device Name")) {
					Text("Current Device Name: " + deviceInfo.deviceName)
					TextField("Enter New Name", text: $changedName)
						.disabled(!bleManager.isConnectedToPinetime)
					Button {
						UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
						nameManager.updateName(deviceUUID: bleManager.infiniTime.identifier.uuidString, name: changedName)
						changedName = ""
					} label: {
						Text("Rename Device")
					}.disabled(!bleManager.isConnectedToPinetime)
				}
				
				Section(header: Text("Firmware Update Downloads")) {
					Toggle("Show Newer Versions Only", isOn: $showNewDownloadsOnly)
				}
				

				Section(header: Text("Notifications")) {
					Toggle("Enable Watch Notifications", isOn: $watchNotifications)
					Toggle("Notify about Low Battery", isOn: $batteryNotification)
					Button {
						SheetManager.shared.sheetSelection = .notification
						SheetManager.shared.showSheet = true
					} label: {
						Text("Send Notification to PineTime")
					}.disabled(!watchNotifications || !bleManager.isConnectedToPinetime)
				}
				Section(header: Text("Graph Styles")) {
					Toggle("Filled HRM Graph", isOn: $heartChartFill)
					Toggle("Filled Battery Graph", isOn: $batChartFill)
				}
				Section(header: Text("Graph Data")) {
					Button (action: {
						ChartManager.shared.deleteAll(dataSet: chartPoints, chart: ChartsAsInts.heart.rawValue)
					}) {
						(Text("Clear All HRM Chart Data"))
					}
					Button (action: {
						ChartManager.shared.deleteAll(dataSet: chartPoints, chart: ChartsAsInts.battery.rawValue)
					}) {
						(Text("Clear All Battery Chart Data"))
					}
				}
				
				Section(header: Text("Onboarding Information")) {
					
					Button {
						SheetManager.shared.sheetSelection = .onboarding
						SheetManager.shared.showSheet = true
					} label: {
						Text("Open Onboarding Page")
					}
					Button {
						SheetManager.shared.sheetSelection = .whatsNew
						SheetManager.shared.showSheet = true
					} label: {
						Text("Open 'What's New' Page for This Version")
					}
				}

				// MARK: logging
				Section(header: Text("Debug Mode")) {
					Toggle("Enable Debug Mode", isOn: $debugMode)
					if debugMode {
						Button {
							pageSwitcher.currentPage = Page.debug
						} label: {
							Text("Debug Logs")
						}
					}
				}
				Section(header: Text("Links")) {
					Link("InfiniLink GitHub", destination: URL(string: "https://github.com/xan-m/InfiniLink")!)
					Link("Matrix", destination: URL(string: "https://matrix.to/#/@xanm:matrix.org")!)
					Link("Mastodon", destination: URL(string: "https://fosstodon.org/@xanm")!)
					Link("InfiniTime Firmware Releases", destination: URL(string: "https://github.com/JF002/InfiniTime/releases")!)
				}
				Section(header: Text("Donations")) {
					Link("PayPal Donation", destination: URL(string: "https://paypal.me/alexemry")!)
				}
			}
			.listStyle(.insetGrouped)
		}
	}
}
