//
//  EnvironmentDataModel.swift
//  STidget
//
//  Created by Joe Bakalor on 11/30/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
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
    
    private var diconnectionDelegateSuper: STidgetConnectionFailureDelegate!
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
        
        //SETUP SELF AS DELEGATE TO RECIEVE ENVIRONMENTAL UPDATES FROM STIDGET
        stidget.setEnvironmentalDelegate(Delegate: self)
    }
    
    func enableUpdates(){
        stidget.setEnvironmentalDelegate(Delegate: self)
    }
    
    func disableUpdates(){
        stidget.setEnvironmentalDelegate(Delegate: nil)
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
