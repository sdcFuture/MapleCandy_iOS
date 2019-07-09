//
//  MapleCandy.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class MapleCandy: BLETopLevelController{
    
    //MAPLECANDY LOCAL PARAMETER STRUCT
    private struct MaplecandyParameterValues{
        var acceleration                : (x: Int16, y: Int16, z: Int16) = (0,0,0)
        var gyroscope                   : (x: Int16, y: Int16, z: Int16) = (0,0,0)
        var prox                        : Int16                               = 0
        var ambientLightLevel           : UInt16                               = 0
        var temperature                 : Int16                            = 0
        var rpm                         : UInt16                               = 0
    }
    
    //PRIVATE VARIABLES 
    private var maplecandyParamtervalues   = MaplecandyParameterValues()
    private var maplecandyPeripheral       : CBPeripheral?
    private var maplecandyStatus           : MapleCandyStatus = .idle
    private var bleReady                : Bool = false
    private var startScanningFlag       = false
    
    //MAPLECANDY SERVICES DELEGATES
    private var motionDelegate: motionServiceDelegate?
    private var environmentDelegate: environmentalServiceDelegate?
    private var ledDelegate: ledServiceDelegate?
    private var maplecandyDeviceManager: MapleCandyDeviceManager?
    private var disconnectionDelegate: MapleCandyConnectionFailureDelegate?
    
    //INITIALIZE CLASS
    override init() {
        //INTIALIZE SUPER CLASS
        super.init()
        super.setDelegate(bleStatusDelegate: self)
    }
}

//MARK: MAPLECANDY API IMPLIMENTATION
extension MapleCandy: MapleCandyAPI{

    
    
    
    /**
     
     Get current maplecandy status
     
     - Author:
     SDC Future Electronics
     
     - returns:
     MapleCandyStatus Enum
     
     - throws:
     none
     
     - parmeters:
     none
     
     */
    func getMapleCandyStatus() -> MapleCandyStatus{
        return maplecandyStatus
    }
    
    /**
     
     Get current maplecandy status
     
     - Author:
     SDC Future Electronics
     
     - returns:
     MapleCandyStatus Enum
     
     - throws:
     none
     
     - parmeters:
     none
     
     */
    func setDisconnectionDelegate(delegate: MapleCandyConnectionFailureDelegate?){
        
        guard let Delegate = delegate else {
            self.disconnectionDelegate = nil
            return
        }
        disconnectionDelegate = Delegate
    }

    /**
     Set delegate to recieve maplecandy discovery and connection related updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func setDeviceManager(Manager: MapleCandyDeviceManager?){
        
        guard let manager = Manager else {
            self.maplecandyDeviceManager = nil
            return
        }
        print("Set device manager")
        self.maplecandyDeviceManager = manager
        
    }
    
    /**
     Set delegate to recieve motion updates and maplecandy connection changes
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func setMotionDelegate(Delegate: motionServiceDelegate?){
        
        guard let delegate = Delegate else {
            self.motionDelegate = nil
            return
        }
        self.motionDelegate = delegate
    }
    
    
    /**
     Set delegate to recieve environmental updates and connection changes
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func setEnvironmentalDelegate(Delegate: environmentalServiceDelegate?){
        
        guard let delegate = Delegate else {
            self.environmentDelegate = nil
            return
        }
        self.environmentDelegate = delegate
    }
    
    
    /**
     Set delegate to recieve led updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func setLedDelegate(Delegate: ledServiceDelegate?){
        
        guard let delegate = Delegate else {
            self.ledDelegate = nil
            return
        }
        self.ledDelegate = delegate
    }

    /**
     Discover the MapleCandy
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Initiates scanning for MapleCandy using MapleCandy UUIDS
     
    */
    func discover() {
        
        if bleReady{
            print("Start Scanning for MapleCandy")
            super.startScanningForPeripherals(withServices: nil)
            //super.startScanningForPeripherals(withServices: [MAPLECANDY_TEST_UUID])//[MAPLECANDY_PRIMARY_SERVICE_UUID])
            maplecandyStatus = .searching
        } else {
            startScanningFlag = true
            maplecandyStatus = .idle
        }
        
    }
    
    /**
     Connect to the MapleCandy
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Attempt to connect to the MapleCandy if it has already been found and the BLE radio
     is ready.  When the timeout expires, the connection attempt will be abandonded
     and the connectionFailed() method will be called on the maplecandyDelegate.
     
     */
    func connect() {
        //RETURN IF BLE IS NOT READY
        guard bleReady else { return }
        
        //CONNECT TO MAPLECANDY, TIMEOUT OUT AFTER 5 IF CONNECTION NO COMPLETE
        if let peripheral = maplecandyPeripheral{
            super.connect(toPeripheral: peripheral, withTimeout: 5)
        }
    }
    
    /**
     Set delegate to recieve motion updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func disconnect() {
        super.diconnect()
    }
    
    /**
     Set delegate to recieve motion updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func rpm() -> (UInt16) {
        
        if let characteristic = maplecandyGATT.maplecandyAccelRpmGyroCharacteristic{
            //super.read(valueFor: characteristic)
        }
        
        return maplecandyParamtervalues.rpm
    }
    
    /**
     Set delegate to recieve motion updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func temperature() -> (Int16) {
        
        if let characteristic = maplecandyGATT.maplecandyTemperatureCharacteristic{
            //super.read(valueFor: characteristic)
        }
        
        return maplecandyParamtervalues.temperature
    }
    
    /**
     Set delegate to recieve motion updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func acceleration() -> (x: Int16, y: Int16, z: Int16) {
        
        if let characteristic = maplecandyGATT.maplecandyAccelRpmGyroCharacteristic{
            super.read(valueFor: characteristic)
        }
        
        return maplecandyParamtervalues.acceleration as! (x: Int16, y: Int16, z: Int16)
    }
    
    /**
     Set delegate to recieve motion updates
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func gyroscope() -> (x: Int16, y: Int16, z: Int16) {
        
        if let characteristic = maplecandyGATT.maplecandyAccelRpmGyroCharacteristic{
            //super.read(valueFor: characteristic)
        }
        
        return maplecandyParamtervalues.gyroscope as! (x: Int16, y: Int16, z: Int16)
    }
    
    /**
     Reads local value for proximity and submits read request to update value
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func proximity() -> (Int16) {
        
        if let characteristic = maplecandyGATT.maplecandyAmbLightProxCharacteristic{
            //super.read(valueFor: characteristic)
        }
        
        return maplecandyParamtervalues.prox
    }
    
    /**
     Reads current local value for Ambient light and submits read request to update value
     
     - Author:
     SDC Future Electronics
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     */
    func ambientLightLevel() -> (UInt16) {
        
        if let characteristic = maplecandyGATT.maplecandyAmbLightProxCharacteristic{
            //super.read(valueFor: characteristic)
        }
        
        return maplecandyParamtervalues.ambientLightLevel
    }

    
    /**
     Set MapleCandy LED Color
     
     - Author:
     SDC Future Electronics
     
     - returns:
     True if command successful, false otherwise
     
     - throws:
     nothing
     
     - parmeters:
     New color of type UIColor to set the LED 
     
     */
    func setLedColor(red: UInt8, green: UInt8, blue: UInt8){
        //RGB LED: [Red uint8] [Green uint8] [Blue uint8]
        print("Red: \(red) Green: \(green) Blue: \(blue)")
        let byteArray = [red, green, blue]
        let data = Data(buffer: UnsafeBufferPointer(start: byteArray, count: byteArray.count))
        
        if let characteristic = maplecandyGATT.maplecandyRgbLedCharacteristic{
           //super.write(value: data, toCharacteristic: characteristic)
        }
    }
    
    /**
     Set DAC Value
     
     - Author:
     
     - returns:
     True if command successful, false otherwise
     
     - throws:
     nothing
     
     - parameters:
     DAC0, DAC1 in float
     
     */
    func setDAC(DAC0: Float, DAC1: Float){
        //RGB LED: [Red uint8] [Green uint8] [Blue uint8]
        //print("DAC0: \(DAC0) DAC1: \(DAC1)")
        
        //Convert float to string
        let DAC0String = String(format: "%.2f", DAC0)
        let DAC1String = String(format: "%.2f", DAC1)
        let DACStringToSend = DAC0String + "," + DAC1String + ","
        print("DAC: " + DACStringToSend)
        
        //Pad string at the end to 20 bytes
        //let DACStringToSendPad = DACStringToSend.padding(toLength: 20, withPad: ",", startingAt: 0)
        //print("DACPad: " + DACStringToSendPad)
        
        //For debug
        let DAC0IntString = String(format: "%d", UInt(DAC0 * 1240.909))
        let DAC1IntString = String(format: "%d", UInt(DAC1 * 409.5))
        print("DAC(Int): " + DAC0IntString + "," + DAC1IntString)
        
        //Convert string to byes
        var byteArray = [UInt8]()
        for char in DACStringToSend.utf8 {
            byteArray += [char]
        }
        
        let data = Data(buffer: UnsafeBufferPointer(start: byteArray, count: byteArray.count))
        
        if let characteristic = maplecandyGATT.maplecandyRgbLedCharacteristic{
            super.write(value: data, toCharacteristic: characteristic)
        }
        
    }
}

// MARK:
extension MapleCandy: BLERadioStatusDelegate{
    func bluetoothReady() {
        bleReady = true
        if startScanningFlag && maplecandyStatus == .idle{
            print("Start Scanning for MapleCandy")
            maplecandyStatus = .searching
            super.startScanningForPeripherals(withServices: nil)
        }
    }
}

//  MARK: HANDLE MESSAGES FROM LOWER LEVEL BLE LIBRARIES
extension MapleCandy: MapleCandyAPIDelegate{
    
    func disconnected() {
        maplecandyStatus = .idle
        maplecandyDeviceManager?.disconnected!()
        disconnectionDelegate?.maplecandyConnectionFailed()
    }
    
    func connectionFailed() {
        maplecandyStatus = .idle
        maplecandyDeviceManager?.connectionFailed!()
    }
    
    func connected() {
        print("Is this connected called?")
        maplecandyStatus = .connected
        
        if let deviceManager = maplecandyDeviceManager{
            deviceManager.connected!()
        }
        print("Start Service Discovery")
        super.discoverServices(withUUIDS: nil)
        //maplecandyDeviceManager?.connected()
    }
    
    func foundMapleCandyPeripheral(MaplecandyPeripheral: CBPeripheral) {
        maplecandyPeripheral = MaplecandyPeripheral
        maplecandyStatus = .found
        maplecandyDeviceManager?.foundMaplecandy()
        super.stopScanning()
        maplecandyStatus = .connecting
        print("ATTEMPTING TO CONNECT TO MAPLE CANDY")
    }
    
    func updatedParameter(for parameter: MapleCandyParameters, newValue: Any) {
        
        switch parameter {
        //======================
        case .ACCEL:
            let accelerometerUpdate = newValue as! (x: Int16, y: Int16, z: Int16)
            motionDelegate?.accelerometerUpdated(to: accelerometerUpdate.x, y: accelerometerUpdate.y, z: accelerometerUpdate.z)
            maplecandyParamtervalues.acceleration = accelerometerUpdate //as! (x: Int16, y: Int16, Z: Int16)
        
        //======================
        case .GYRO:
            let gyroscopeUpdate = newValue as! (x: Int16, y: Int16, z: Int16)
            motionDelegate?.gyroUpdated(to: gyroscopeUpdate.x, y: gyroscopeUpdate.y, z: gyroscopeUpdate.z)
            maplecandyParamtervalues.gyroscope = gyroscopeUpdate //as! (x: Int16, y: Int16, Z: Int16)
        
        //======================
        case .LED: print("No value to recieve currently")
        
        //======================
        case .LIGHT:
            let ambientLightLevelUpdate = newValue as! UInt16
            environmentDelegate?.lightLevelUpdated(to: ambientLightLevelUpdate)
            maplecandyParamtervalues.ambientLightLevel = ambientLightLevelUpdate//newValue as! (x: Double, y: Double, Z: Double)
        
        //======================
        case .PROX:
            let proximitUpdate = newValue as! Int16
            environmentDelegate?.proximityUpdated(to: proximitUpdate)
            maplecandyParamtervalues.prox  = proximitUpdate
        
        //======================
        case .RPM:
            let rpmUpdate = newValue as! UInt16
            motionDelegate?.rpmUpdated(to: rpmUpdate)
            maplecandyParamtervalues.rpm = rpmUpdate
            
        //======================
        case .TEMP:
            let temperatureUpdate = newValue as! Int16
            environmentDelegate?.temperatureUpdated(to: temperatureUpdate)
            maplecandyParamtervalues.temperature = temperatureUpdate
        }
    }
    

    
    
}














