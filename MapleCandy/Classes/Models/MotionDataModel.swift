//
//  MotionDataModel.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
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
    
    private var diconnectionDelegateSuper: MapleCandyConnectionFailureDelegate!
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
        
        maplecandy.setMotionDelegate(Delegate: self)
        
    }
    
    func disableUpdates(){
        maplecandy.setMotionDelegate(Delegate: nil)
    }
    
    func enableUpdates(){
        maplecandy.setMotionDelegate(Delegate: self)
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
