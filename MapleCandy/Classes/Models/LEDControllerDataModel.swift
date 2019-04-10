//
//  LEDControllerDataModel.swift
//  STidget
//
//  Created by Joe Bakalor on 11/30/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
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
    private var diconnectionDelegateSuper: STidgetConnectionFailureDelegate!
    
    //INITIALIZE LED DATA MODEL WITH UI DELEGATES
    init(ledDelegate: LedUIDelegate?) {
        
        super.init()
        
        if let delegate = ledDelegate{
            ledUIDelegate = delegate
        }
        
        //SETUP SELF AS DELEGATE TO RECIEVE LED UPDATES FROM STIDGET
        stidget.setLedDelegate(Delegate: self)
    }
    
    func removeDelegates(){
       stidget.setLedDelegate(Delegate: nil)
    }
    
}

extension LEDControllerDataModel: ledServiceDelegate{
    
    //LED COLOR UPDATED ==> NOT USED CURRNENTLY
    func ledColorUpdated() {
        
    }
    
}
