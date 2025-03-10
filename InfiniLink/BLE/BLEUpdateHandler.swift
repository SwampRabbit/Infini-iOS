//
//  BLEUpdateHandler.swift
//  InfiniLink
//
//  Created by Alex Emry on 10/1/21.
//  
//
    

import CoreBluetooth

struct BLEUpdatedCharacteristicHandler {
	
	let bleManager = BLEManager.shared
	
	// function to translate heart rate to decimal, copied straight up from this tut: https://www.raywenderlich.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor#toc-anchor-014
	func heartRate(from characteristic: CBCharacteristic) -> Int {
		guard let characteristicData = characteristic.value else { return -1 }
		let byteArray = [UInt8](characteristicData)

		let firstBitValue = byteArray[0] & 0x01
		if firstBitValue == 0 {
			// Heart Rate Value Format is in the 2nd byte
			return Int(byteArray[1])
		} else {
			// Heart Rate Value Format is in the 2nd and 3rd bytes
			return (Int(byteArray[1]) << 8) + Int(byteArray[2])
		}
	}
	
	func handleUpdates(characteristic: CBCharacteristic, peripheral: CBPeripheral) {
		switch characteristic.uuid {
		case bleManager.cbuuidList.musicControl:
			let musicControl = [UInt8](characteristic.value!)
			MusicController().controlMusic(controlNumber: Int(musicControl[0]))
		case bleManager.cbuuidList.hrm:
			let bpm = heartRate(from: characteristic)
			bleManager.heartBPM = Double(bpm)
			if bpm != 0{
				ChartManager.shared.addItem(dataPoint: DataPoint(date: Date(), value: Double(bpm), chart: ChartsAsInts.heart.rawValue))
			}
		case bleManager.cbuuidList.bat:
			let batData = [UInt8](characteristic.value!)
			DebugLogManager.shared.debug(error: "battery level report: \(String(batData[0]))", log: .ble, date: Date())
			ChartManager.shared.addItem(dataPoint: DataPoint(date: Date(), value: Double(batData[0]), chart: ChartsAsInts.battery.rawValue))
			bleManager.batteryLevel = Double(batData[0])
		default:
			break
		}
	}
}
