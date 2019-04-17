//
//  MapleCandyAPI.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 11/30/17.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

//MAPLECANDY PARAMETER ENUMERATION
enum MapleCandyParameters {
    case RPM
    case TEMP
    case ACCEL
    case GYRO
    case PROX
    case LIGHT
    case LED
}

//MAPLECANDY STATUS'S ENUM
enum MapleCandyStatus {
    case searching
    case found
    case idle
    case unknown
    case connecting
    case connected
}

//TOP LEVEL MAPLECANDY DELEGATE PROTOCOL
@objc protocol maplecandyDelegate{
    @objc optional func connected()
    @objc optional func disconnected()
    @objc optional func connectionFailed()
}

protocol MapleCandyDeviceManager: maplecandyDelegate{
    func foundMaplecandy()
}

//LED DELEGATE PROTOCOL
protocol ledServiceDelegate: maplecandyDelegate{
    func ledColorUpdated()
}

//USED BY DATA MODELS TO INFORM VIEW CONTROLLERS OF DISCONNECTIONS
protocol MapleCandyConnectionFailureDelegate{
    func maplecandyConnectionFailed()
}

//ENVIRONMENTAL SERVICE DELEGATE PROTOCOL
protocol environmentalServiceDelegate: maplecandyDelegate {
    func temperatureUpdated(to temp: Int16)
    func lightLevelUpdated(to lightLevel: UInt16)
    func proximityUpdated(to distance: Int16)
}

//MOTION SERVICE DELEGATE PROTOCOL
protocol motionServiceDelegate: maplecandyDelegate {
    func rpmUpdated(to rpm: UInt16)
    func accelerometerUpdated(to x: Int16, y: Int16, z: Int16)
    func gyroUpdated(to x: Int16, y: Int16, z: Int16)
}

//DEFINE PROTOCOL FOR EXPOSING MAPLECANDY API METHODS
protocol MapleCandyAPI {
    
    func getMapleCandyStatus() -> MapleCandyStatus
    func setLedDelegate(Delegate: ledServiceDelegate?)
    func setEnvironmentalDelegate(Delegate: environmentalServiceDelegate?)
    func setDisconnectionDelegate(delegate: MapleCandyConnectionFailureDelegate?)
    func discover()
    func connect()
    func disconnect()
    func rpm() -> (UInt16)
    func temperature() -> (Int16)
    func acceleration() -> (x: Int16, y: Int16, z: Int16)
    func gyroscope() -> (x: Int16, y: Int16, z: Int16)
    func proximity() -> (Int16)
    func ambientLightLevel() -> (UInt16)
    func setLedColor(red: UInt8, green: UInt8, blue: UInt8)
    func setDAC(DAC0: Float, DAC1: Float)
}

//CONNECTION TO LOWER LEVEL BLE
protocol MapleCandyAPIDelegate: maplecandyDelegate {
    func foundMapleCandyPeripheral(MaplecandyPeripheral: CBPeripheral)
    func updatedParameter(for parameter: MapleCandyParameters, newValue: Any)
}


