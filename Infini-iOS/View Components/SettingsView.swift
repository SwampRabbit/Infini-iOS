//
//  SettingsView.swift
//  Infini-iOS
//
//  Created by Alex Emry on 8/15/21.
//  
//
    

import Foundation
import SwiftUI

struct Settings_Page: View {
	
	@EnvironmentObject var bleManager: BLEManager
	@EnvironmentObject var pageSwitcher: PageSwitcher
	@Environment(\.colorScheme) var colorScheme
	
	@AppStorage("watchNotifications") var watchNotifications: Bool = true
	@AppStorage("autoconnect") var autoconnect: Bool = false
	@AppStorage("batteryNotification") var batteryNotification: Bool = false
	@AppStorage("autoconnectUUID") var autoconnectUUID: String = "empty"
	@AppStorage("heartChartFill") var heartChartFill: Bool = true
	@AppStorage("batChartFill") var batChartFill: Bool = true
	@AppStorage("debugMode") var debugMode: Bool = false
	
	var body: some View {
		VStack (alignment: .leading){
			Text("Settings")
				.font(.largeTitle)
				.padding()
			Form {
				Section(header: Text("Connection")) {
					Toggle("Autoconnect to PineTime", isOn: $autoconnect)
					if autoconnect {
						Button {
							autoconnectUUID = bleManager.setAutoconnectUUID
							print(autoconnectUUID)
						} label: {
							Text("Use Current Device for Autoconnect")
								.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
						}
						Button {
							autoconnectUUID = ""
							print(autoconnectUUID)
						} label: {
							Text("Clear Autoconnect Device")
								.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
						}
					}


				}
				Section(header: Text("Notifications")) {
					Toggle("Enable Watch Notifications", isOn: $watchNotifications)
					Toggle("Notify about Low Battery", isOn: $batteryNotification)
				}
				Section(header: Text("Graph Styles")) {
					Toggle("Filled HRM Graph", isOn: $heartChartFill)
					Toggle("Filled Battery Graph", isOn: $batChartFill)
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
					Link("Infini-iOS GitHub", destination: URL(string: "https://github.com/xan-m/Infini-iOS")!)
					Link("Matrix", destination: URL(string: "https://matrix.to/#/@xanm:matrix.org")!)
					Link("Mastodon", destination: URL(string: "https://fosstodon.org/@xanm")!)
				}
				Section(header: Text("Donations")) {
					Link("PayPal Donation", destination: URL(string: "https://paypal.me/alexemry")!)
				}
			}
		}

	}
}
