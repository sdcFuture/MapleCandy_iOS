//
//  MotionDataModel.swift
//  STidget
//
//  Created by Joe Bakalor on 11/30/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import Foundation

class MotionDataModel: NSObject{
    
    public struct AccelerationUIDelegate {
        var updateHandler = {(x: Int16, y: Int16, z: Int16) in}
    }
    
    public struct GyroscopeUIDelegate {
        var updateHandler = {(x: Int16, y: Int16, z: Int16) in}
    }
    
    public struct RpmUIDelegate{
        var updateHandler = {(newValue: UInt16) in}
    }
    
    private var diconnectionDelegateSuper: STidgetConnectionFailureDelegate!
    private var accelerationUIDelegate: AccelerationUIDelegate?
    private var gyroscopeUIDelegate: GyroscopeUIDelegate?
    private var rpmUIDelegate: RpmUIDelegate?
    
    //INITIALIZE MOTION DATA MODEL WITH UI DELEGATE 
    init(accelerationDelegate: AccelerationUIDelegate?, gyroscopeDelegate: GyroscopeUIDelegate?, rpmDelegate: RpmUIDelegate?) {
        super.init()
        
        if let delegate = accelerationDelegate{
            accelerationUIDelegate = delegate
        }
        
        if let delegate = gyroscopeDelegate{
            gyroscopeUIDelegate = delegate
        }
        
        if let delegate = rpmDelegate{
            rpmUIDelegate = delegate
        }
        
        stidget.setMotionDelegate(Delegate: self)
        
    }
    
    func disableUpdates(){
        stidget.setMotionDelegate(Delegate: nil)
    }
    
    func enableUpdates(){
        stidget.setMotionDelegate(Delegate: self)
    }

}

extension MotionDataModel: motionServiceDelegate{

    func rpmUpdated(to rpm: UInt16) {
        rpmUIDelegate?.updateHandler(rpm)
    }
    
    func accelerometerUpdated(to x: Int16, y: Int16, z: Int16) {
        accelerationUIDelegate?.updateHandler(x, y, z)
    }
    
    func gyroUpdated(to x: Int16, y: Int16, z: Int16) {
        gyroscopeUIDelegate?.updateHandler(x, y, z)
    }
    
    
}
