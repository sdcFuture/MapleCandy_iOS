//
//  EnvironmentDataModel.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import Foundation
import UIKit

class EnvironmentDataModel: NSObject{
    
    public struct LightLevelUIDelegate {
        var updateHandler = {(newVlue: UInt16) in}
    }
    
    public struct ProximityUIDelegate {
        var updateHandler = {(newVlue: Int16) in}
    }
    
    public struct TemperatureUIDelegate{
        var updateHandler = {(newVlue: Int16) in}
    }
    
    private var diconnectionDelegateSuper: MapleCandyConnectionFailureDelegate!
    private var lightLevelUIDelegate: LightLevelUIDelegate?
    private var proximityUIDelegate: ProximityUIDelegate?
    private var temperatureUIDelegate: TemperatureUIDelegate?
    
    //INITIALIZE ENVIRONMENTAL DATA MODEL WITH UI DELEGATES
    init(lightLevelDelegate: LightLevelUIDelegate?, proximityDelegate: ProximityUIDelegate?, temperatureDelegate: TemperatureUIDelegate?) {
        
        super.init()
        
        if let delegate = lightLevelDelegate{
            lightLevelUIDelegate = delegate
        }
        
        if let delegate = proximityDelegate{
            proximityUIDelegate = delegate
        }
        
        if let delegate = temperatureDelegate{
            temperatureUIDelegate = delegate
        }
        
        //SETUP SELF AS DELEGATE TO RECIEVE ENVIRONMENTAL UPDATES FROM MAPLECANDY
        maplecandy.setEnvironmentalDelegate(Delegate: self)
    }
    
    func enableUpdates(){
        maplecandy.setEnvironmentalDelegate(Delegate: self)
    }
    
    func disableUpdates(){
        maplecandy.setEnvironmentalDelegate(Delegate: nil)
    }
    
    
}

extension EnvironmentDataModel: environmentalServiceDelegate{
    
    func temperatureUpdated(to temp: Int16) {
        temperatureUIDelegate?.updateHandler(temp)
    }
    
    func lightLevelUpdated(to lightLevel: UInt16) {
        lightLevelUIDelegate?.updateHandler(lightLevel)
    }
    
    func proximityUpdated(to distance: Int16) {
        proximityUIDelegate?.updateHandler(distance)
    }
}
