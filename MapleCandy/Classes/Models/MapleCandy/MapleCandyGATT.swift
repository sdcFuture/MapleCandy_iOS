//
//  MapleCandyGATT.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import Foundation
import CoreBluetooth

//DEFINE MAPLECANDY SERVICE AND CHARACTERISTIC UUIDS

//let MAPLECANDY_PRIMARY_SERVICE_UUID = CBUUID(string: "f79b4eb3-1b6e-41f2-8d65-d346b4ef5685")
let MAPLECANDY_PRIMARY_SERVICE_UUID = CBUUID(string: "D68C0001-A21B-11E5-8CB8-0002A5D5C51B")

//let MAPLECANDY_RGB_LED_CHARACTERISTIC_UUID = CBUUID(string: "f79b4eb4-1b6e-41f2-8d65-d346b4ef5685")
let MAPLECANDY_RGB_LED_CHARACTERISTIC_UUID = CBUUID(string: "D68C0003-A21B-11E5-8CB8-0002A5D5C51B")

//let MAPLECANDY_ACCEL_RPM_GYRO_CHARACTERISTIC_UUID = CBUUID(string: "f79b4eb5-1b6e-41f2-8d65-d346b4ef5685")
let MAPLECANDY_ACCEL_RPM_GYRO_CHARACTERISTIC_UUID = CBUUID(string: "D68C0002-A21B-11E5-8CB8-0002A5D5C51B")

let MAPLECANDY_TEMP_CHARACTERISTIC_UUID = CBUUID(string: "2A6E")
let MAPLECANDY_AMB_LIGHT_PROX_CHARACTERISTIC_UUID = CBUUID(string: "f79b4eb6-1b6e-41f2-8d65-d346b4ef5685")
let MAPLECANDY_TEST_UUID = CBUUID(string: "EF680100-9B35-4933-9B10-52FFA9740042")

class MapleCandyGATT: NSObject{
    
    struct characteristic{
        var characteristic: CBCharacteristic?
        var uuid: CBUUID
    }
    
    struct service{
        var service: CBService?
        var uuid: CBUUID
    }

    //DEFINE PUBLIC ACCESS VARIABLE TO MAPLECANDY PRIMARY SERVICE
    public var maplecandyPrimaryService: CBService?{
        get{
            return self.MaplecandyPrimaryService?.service
        }
    }
    
    //DEFINE PUBLIC ACCESS VARIABLE TO CHARACTERISTIC
    public var maplecandyRgbLedCharacteristic: CBCharacteristic?{
        get{
            return self.MaplecandyRgbLedCharacteristic?.characteristic
        }
    }
    
    //DEFINE PUBLIC ACCESS VARIABLE TO CHARACTERISTIC
    public var maplecandyAccelRpmGyroCharacteristic: CBCharacteristic?{
        get{
            return self.MaplecandyAccelRpmGyroCharacteristic?.characteristic
        }
    }
    
    //DEFINE PUBLIC ACCESS VARIABLE TO CHARACTERISTIC
    public var maplecandyTemperatureCharacteristic: CBCharacteristic?{
        get{
            return self.MaplecandyTemperatureCharacteristic?.characteristic
        }
    }
    
    //DEFINE PUBLIC ACCESS VARIABLE TO CHARACTERISTIC
    public var maplecandyAmbLightProxCharacteristic: CBCharacteristic?{
        get{
            return self.MaplecandyAmbLightProxCharacteristic?.characteristic
        }
    }
    
    //CREAT PRIVATE VARIABLES TO STORE MAPLECANDY SERVICE AND CHARACTERISTIC REFERENCES
    private var MaplecandyPrimaryService: service?  = service(service: nil, uuid: MAPLECANDY_PRIMARY_SERVICE_UUID)//: CBService?
    private var MaplecandyRgbLedCharacteristic: characteristic? = characteristic(characteristic: nil, uuid: MAPLECANDY_RGB_LED_CHARACTERISTIC_UUID)//: CBCharacteristic?
    private var MaplecandyAccelRpmGyroCharacteristic: characteristic? = characteristic(characteristic: nil, uuid: MAPLECANDY_ACCEL_RPM_GYRO_CHARACTERISTIC_UUID)//: CBCharacteristic?
    private var MaplecandyTemperatureCharacteristic: characteristic? = characteristic(characteristic: nil, uuid: MAPLECANDY_TEMP_CHARACTERISTIC_UUID)//: CBCharacteristic?
    private var MaplecandyAmbLightProxCharacteristic: characteristic? = characteristic(characteristic: nil, uuid: MAPLECANDY_AMB_LIGHT_PROX_CHARACTERISTIC_UUID)//: CBCharacteristic?

    //CALLED FROM SUPER, LOOK THROUGH SERVICES FOR STIDIGET SERVICE
    func foundServices(services: [CBService]){
        print("MapleCandyGATT: Found Service called by super")
        for Service in services{
            switch Service.uuid{
            case MaplecandyPrimaryService!.uuid:
                
                print("MapleCandyGATT: FOUND MAPLE CANDY VUART_HDL_SVC PRIMARY SERVICE")
                MaplecandyPrimaryService?.service = Service
                maplecandy.discoverCharacteristics(forService: maplecandyPrimaryService!, withUUIDS: nil)
                
            default:
                maplecandy.discoverCharacteristics(forService: Service, withUUIDS: nil)
                print("Unknown Service")
            }
        }
        
    }
    
    //ASSIGN FOUND CHARACTERISTICS TO INTERNAL REFERENCES BASED ON UUID
    func foundCharacteristics(characteristics: [CBCharacteristic]){
        for Characteristic in characteristics{
            switch Characteristic.uuid{
            case MaplecandyRgbLedCharacteristic!.uuid:
                
                print("MapleCandyGATT: FOUND MAPLE CANDY UART_HDL_WRITE_CHAR CHARACTERISTIC")
                MaplecandyRgbLedCharacteristic?.characteristic = Characteristic
                //maplecandy.enableNotifications(forCharacteristic: maplecandyRgbLedCharacteristic!)
                
            case MaplecandyAccelRpmGyroCharacteristic!.uuid:
                
                print("MapleCandyGATT: FOUND MAPLE CANDY VUART_HDL_INDICATION_CHAR CHARACTERISTIC")
                MaplecandyAccelRpmGyroCharacteristic?.characteristic = Characteristic
                maplecandy.enableNotifications(forCharacteristic: maplecandyAccelRpmGyroCharacteristic!)
                
            case MaplecandyTemperatureCharacteristic!.uuid:
                
                print("MapleCandyGATT: FOUND TEMP CHARACTERISTIC")
                MaplecandyTemperatureCharacteristic?.characteristic = Characteristic
                maplecandy.enableNotifications(forCharacteristic: maplecandyTemperatureCharacteristic!)
                
            case MaplecandyAmbLightProxCharacteristic!.uuid:
                
                print("MapleCandyGATT: FOUND AMB LIGHT PROX CHARACTERISTIC")
                MaplecandyAmbLightProxCharacteristic?.characteristic = Characteristic
                maplecandy.enableNotifications(forCharacteristic: maplecandyAmbLightProxCharacteristic!)
                
            default:
                print("Unknown Characteristic")
            }
        }
    }
    
    //PROCESS CHARACTERISTIC UPDATES
    func valueUpdatedFor(characteristic: CBCharacteristic){
        
        ///print("MapleCandyGATT: VALUE UPDATED FOR CHARACTERISTIC")
        switch characteristic.uuid{
        case MaplecandyRgbLedCharacteristic!.uuid:

            maplecandy.updatedParameter(for: .LED, newValue: 0)
                
        case MaplecandyAccelRpmGyroCharacteristic!.uuid:
            
            let parsedData = parseAccelRpmGyroData(characteristic: characteristic)
            
            maplecandy.updatedParameter(for: .ACCEL, newValue: parsedData.accelData)
            maplecandy.updatedParameter(for: .GYRO, newValue: parsedData.gyroData)
            maplecandy.updatedParameter(for: .RPM, newValue: parsedData.rpmData)
                
        case MaplecandyTemperatureCharacteristic!.uuid:

            let parsedData = parseTempData(characteristic: characteristic)
            
            maplecandy.updatedParameter(for: .TEMP, newValue: parsedData)
                
        case MaplecandyAmbLightProxCharacteristic!.uuid:
            
            let parsedData = parseLightProxData(characteristic: characteristic)
            
            maplecandy.updatedParameter(for: .LIGHT, newValue: parsedData.light)
            maplecandy.updatedParameter(for: .PROX, newValue: parsedData.prox)
                
        default:
            print("Unknown Characteristic Data Updated")
        }
        
    }
    
}


//MARK: DATA PARSING FUNCTIONS
extension MapleCandyGATT{
    
    struct AccelRpmGyroData{
        var accelData: (x: Int16 , y: Int16, z: Int16) = (0,0,0)
        var gyroData: (x: Int16, y: Int16, z: Int16) = (0,0,0)
        var rpmData: UInt16 = 0
    }
    
    private func parseAccelRpmGyroData(characteristic: CBCharacteristic) -> AccelRpmGyroData{
        
        var accelRpmGyroData = AccelRpmGyroData()
        var dataBytes: [UInt8] = []
        if characteristic.value != nil{
            dataBytes = getDataBytes(characteristic: characteristic)
        }
        
        let accelX: Int16 = (Int16(dataBytes[1]) << 8) | Int16(dataBytes[0])
        //print("X acceleration = \(accelX)")
        accelRpmGyroData.accelData.x = accelX
        
        let accelY: Int16 = (Int16(dataBytes[3]) << 8) | Int16(dataBytes[2])
        //print("Y acceleration = \(accelY)")
        accelRpmGyroData.accelData.y = accelY
        
        let accelZ: Int16 = (Int16(dataBytes[5]) << 8) | Int16(dataBytes[4])
        //print("Z acceleration = \(accelZ)")
        accelRpmGyroData.accelData.z = accelZ
        
        //let RPM: UInt16 = (UInt16(dataBytes[7]) << 8) | UInt16(dataBytes[6])
        //print("RPM = \(RPM)")
        //accelRpmGyroData.rpmData = RPM
        
        //let gyroX: Int16 = (Int16(dataBytes[9]) << 8) | Int16(dataBytes[8])
        //print("X gyro = \(gyroX)")
        //accelRpmGyroData.gyroData.x = gyroX
        
        //let gyroY: Int16 = (Int16(dataBytes[11]) << 8) | Int16(dataBytes[10])
        //print("Y gyro = \(gyroY)")
        //accelRpmGyroData.gyroData.y = gyroY
        
        //let gyroZ: Int16 = (Int16(dataBytes[13]) << 8) | Int16(dataBytes[12])
        //print("Z gyro = \(gyroZ)")
        //accelRpmGyroData.gyroData.z = gyroZ
        
        //Accel + Gyro: [Accel X sint16 in mg] [Accel Y sint16 in mg] [Accel Z sint16 in mg] [RPM uint16] [Gyro X sint16 in 0.1dps] [Gyro Y sint16 in 0.1dps] [Gyro Z sint16 in 0.1dps]
        return accelRpmGyroData
    }
    
    private func parseTempData(characteristic: CBCharacteristic) -> Int16{
        let temperature = 0
        //[Temperature sint16 in 0.01 degrees C]
        
        var dataBytes: [UInt8] = []
        if characteristic.value != nil{
            dataBytes = getDataBytes(characteristic: characteristic)
        }
        let temp: Int16 = (Int16(dataBytes[1]) << 8) | Int16(dataBytes[0])
        
        return temp
    }
    
    private func parseLightProxData(characteristic: CBCharacteristic) -> (light: UInt16, prox: Int16){
        //Ambient Light and Prox: [Ambient Light uint16 in lux] [Range sint16 in mm, -1 means nothing detected]
        var lightData: (UInt16, Int16) = (0,0)

        
        var dataBytes: [UInt8] = []
        if characteristic.value != nil{
            dataBytes = getDataBytes(characteristic: characteristic)
        }
        let lightValue: UInt16 = (UInt16(dataBytes[1]) << 8) | UInt16(dataBytes[0])
        print("\(lightValue) LUX")
        let proxValue: Int16 = (Int16(dataBytes[3]) << 8) | Int16(dataBytes[2])
        print("\(proxValue) MM")
        lightData = (lightValue, proxValue)
        
        return lightData
    }
    
    //GET CHARACTERISTIC VALUE AND RETURN AS BYTE ARRAY
    func getDataBytes(characteristic: CBCharacteristic) -> [UInt8]{
        
        var data: Data? = characteristic.value as Data!
        //data = characteristic.value as Data!
        
        var dataBytes = [UInt8](repeating: 0, count: data!.count)
        (data! as NSData).getBytes(&dataBytes, length: data!.count)
        
        var hexValue = ""
        for value in data!{
            let hex = String(value, radix: 16)
            hexValue = hexValue + "0x\(hex) "
        }
        //print("Raw Hex = \(hexValue)")
        return dataBytes
    }
    
}

/*
 
 Here is what I’m thinking for the BLE profile. The properties of the characteristics and descriptors are in parenthesis. R = Read, W = Write, WNR = Write No Response, I = Indicate, and N = Notify
 
 ·        Generic Access Service (required)
 o   Device Name Characteristic (R)
 o   Appearance Characteristic  (R)
 ·        Generic Attribute Service (required)
 o   Service Changed Characteristic (I, R)
 §  Client Characteristic Configuration Descriptor (R, W)
 ·        MapleCandy Custom Service (UUID: f79b4eb3-1b6e-41f2-8d65-d346b4ef5685)
 o   RGB LED Characteristic (UUID: f79b4eb4-1b6e-41f2-8d65-d346b4ef5685) (R, W, WNR)
 o   Accelerometer + Gyro Characteristic (UUID: f79b4eb5-1b6e-41f2-8d65-d346b4ef5685) (R, N)
 §  Client Characteristic Configuration Descriptor (R, W)
 o   Temperature Characteristic (UUID: 0x2A6E) (R, N)
 §  Client Characteristic Configuration Descriptor (R, W)
 o   Ambient Light and Proximity Characteristic (f79b4eb6-1b6e-41f2-8d65-d346b4ef5685) (R, N)
 §  Client Characteristic Configuration Descriptor (R, W)
 
 It would be nice if each of the characteristics in the custom service had a User Description descriptor (UUID = 0x2901) as well so that someone could see what the characteristic is with another app, but that isn’t a hard requirement.
 
 Here are the data formats for each of the characteristics in the custom service:
 ·        RGB LED: [Red uint8] [Green uint8] [Blue uint8]
 ·        Accel + Gyro: [Accel X sint16 in mg] [Accel Y sint16 in mg] [Accel Z sint16 in mg] [RPM uint16] [Gyro X sint16 in 0.1dps] [Gyro Y sint16 in 0.1dps] [Gyro Z sint16 in 0.1dps]
 ·        Temperature (BT SIG standard): [Temperature sint16 in 0.01 degrees C]
 ·        Ambient Light and Prox: [Ambient Light uint16 in lux] [Range sint16 in mm, -1 means nothing detected]
 */













