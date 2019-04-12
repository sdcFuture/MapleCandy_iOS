//
//  EnvironmentViewController.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import UIKit

class EnvironmentViewController: UIViewController {
    
    enum TempUnits{
        case f
        case c
    }
    
    //VIEW DATA MODEL INSTANCE
    var environmentDataModel: EnvironmentDataModel!
    var tempUnits: TempUnits = .c
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var ambientLightLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        temperatureLabel.font = UIFont(name: "DBLCDTempBlack", size: 84)
        ambientLightLabel.font = UIFont(name: "DBLCDTempBlack", size: 84)
        proximityLabel.font = UIFont(name: "DBLCDTempBlack", size: 84)
        
        maplecandy.setDisconnectionDelegate(delegate: self)
        
        //DEFINE CLOSURE TO HANDLE LIGHT LEVEL UPDATES
        let lightLevelUpdateHandler = EnvironmentDataModel.LightLevelUIDelegate(updateHandler:{
            (lightLevel: UInt16) in
            print("Updated Light Level: \(lightLevel)")
            self.ambientLightLabel.text = "\(lightLevel) LUX"
            //self.ambientLightLevelLabel.text = "\(lightLevel)"
        })
        
        //DEFINE CLOSURE TO HANDLE TEMPERATURE VALUE UPDATES
        let temperatureUpdateHandler = EnvironmentDataModel.TemperatureUIDelegate(updateHandler:{
            (temp: Int16) in
            print("Updated Temperature: \(temp)")
            self.temperatureLabel.text = "\(Double(temp)/100) C"
        })
        
        //DEFINE CLOSURE TO HANDLE PROXIMITY UPDATES
        let proximityUpdateHandler = EnvironmentDataModel.ProximityUIDelegate(updateHandler:{
            (distance: Int16) in
            print("Updated Proimity to: \(distance)")
            self.proximityLabel.text = "\(distance) mm"
            
        })
        
        environmentDataModel = EnvironmentDataModel(lightLevelDelegate: lightLevelUpdateHandler,
                                                    proximityDelegate: proximityUpdateHandler,
                                                    temperatureDelegate: temperatureUpdateHandler)
    }
    
    override func viewDidLayoutSubviews() {
        
        temperatureLabel.baselineAdjustment = .alignCenters
        
        ambientLightLabel.baselineAdjustment = .alignCenters
        proximityLabel.baselineAdjustment = .alignCenters
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "MapleCandy"
        environmentDataModel.enableUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        environmentDataModel.disableUpdates()
    }
}


//MARK: MANAGE MAPLECANDY CONNECTION FAILURE
extension EnvironmentViewController: MapleCandyConnectionFailureDelegate{
    func maplecandyConnectionFailed() {
        //RETURN TO HOME SCREEN
        self.navigationController?.popToRootViewController(animated: true)
        print("ENVIRONMENT VIEW CONTROLLER: Connection failed")
    }
}

