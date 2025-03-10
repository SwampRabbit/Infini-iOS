//
//  WhatsNewBody090.swift
//  InfiniLink
//
//  Created by Alex Emry on 9/28/21.
//  
//
    

import SwiftUI

struct WhatsNewBody: View {
	
	var body: some View {
		ScrollView{
			Text("UI Changes:\n- Widened side menu to accommodate larger fonts for accessibility.\n- Added device renaming button to home page.\n- Removed 'status' area from side menu. This section has been redundant for a while, as the whole UI updates when a device is connected, and the whole app doesn't do anything if Bluetooth is turned off.\n- Moved giant disconnect/connect button from the Home screen to side menu. Between InfiniTime 1.6.0's Bluetooth fixes and autoconnect enabled, there are very few reasons to manually disconnect or connect anymore. Let me know if this is a problem or pain point and I can make adjustments.\n- Changed giant 'Select Firmware' button on DFU screen to a button where the selected firmware file goes.\n- Added a small pop-up text bubble if autoconnect is enabled to show when the device is scanning and when it connects.")
				.padding()
			Text("Debug mode:\n- I have been tinkering with a debug mode to see app logs for a while, but decided to leave it out a month or so ago. It ended up being instrumental in solving a tricky bug that occurred when setting the time on the PineTime (thanks again for helping me troubleshoot that @bhibb!). With that in mind, I decided to add it to the app for everyone. To access the logs, enable Debug Mode in the Settings view, and you'll see a link appear that will take you to the log pages.\n- The logs are not persistent, so if you experience a crash, please report it through TestFlight.\n- Bear in mind that the log entries you'll see under the 'App' log section are all for bugs I've found or error messages generated by Swift APIs, so it's not a complete list of every possible scenario.")
				.padding()
			Text("Behind the Scenes:\n- I refactored the whole bluetooth system behind InfiniLink. This has been a long time coming; the BLE implementation was the very first part of this app and was where I first started learning Swift, so it was a hot mess. I've tidied it up now, and optimized some of the more bloated functions that I had created.")
				.padding()

			Text("Bug Fixes:\n- Added some checks to the notification sending function to prevent that from crashing.\n- Established some functions to more accurately determine how buttons should appear and when they should be disabled. There were a couple of edge cases where you could create some unexpected button behavior.\n- Made some changes to the GitHub API calling mechanism in the app to drastically reduce the chances of anyone hitting GitHub's API request rate limit.")
				.padding()
		}
	}
}

