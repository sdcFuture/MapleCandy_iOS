//
//  LEDControllerDataModel.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import Foundation


//MARK: LEDControllerDataModel
class LEDControllerDataModel: NSObject{
    
    //DEFINE LedUIDelegate paramter struct
    public struct LedUIDelegate {
        //DEFINE UPDATE HANDLER CLOSURE
        var updateHandler = {(red: Int, green: Int, Blue: Int) in}
    }
    
    private var ledUIDelegate: LedUIDelegate?
    private var diconnectionDelegateSuper: MapleCandyConnectionFailureDelegate!
    
    //INITIALIZE LED DATA MODEL WITH UI DELEGATES
    init(ledDelegate: LedUIDelegate?) {
        
        super.init()
        
        if let delegate = ledDelegate{
            ledUIDelegate = delegate
        }
        
        //SETUP SELF AS DELEGATE TO RECIEVE LED UPDATES FROM MAPLECANDY
        maplecandy.setLedDelegate(Delegate: self)
    }
    
    func removeDelegates(){
       maplecandy.setLedDelegate(Delegate: nil)
    }
    
}

extension LEDControllerDataModel: ledServiceDelegate{
    
    //LED COLOR UPDATED ==> NOT USED CURRNENTLY
    func ledColorUpdated() {
        
    }
    
}
