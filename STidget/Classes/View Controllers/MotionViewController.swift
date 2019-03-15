//
//  MotionViewController.swift
//  STidget
//
//  Created by Joe Bakalor on 11/22/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController {
    
    //Motion data model
    var motionDataModel: MotionDataModel!
    
    //Accelerometer view labels
    @IBOutlet weak var accelXLabel: UILabel!
    @IBOutlet weak var accelYLabel: UILabel!
    @IBOutlet weak var accelZLabel: UILabel!
    
    //Gyro view labels
    @IBOutlet weak var gyroXLabel: UILabel!
    @IBOutlet weak var gyroYLabel: UILabel!
    @IBOutlet weak var gyroZLabel: UILabel!
    
    @IBOutlet weak var gaugeView: GaugeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        stidget.setDisconnectionDelegate(delegate: self)
        
        //DEFINE CLOSURE TO HANDLE ACCELEROMETER UPDATES
        let accelerationUpdateHandler = MotionDataModel.AccelerationUIDelegate(updateHandler: {
            (x: Int16, y: Int16, z: Int16) in
            print("ACC x: \(x), y: \(y), z: \(z)")
            self.accelXLabel.text = "X: \(x)"
            self.accelYLabel.text = "Y: \(y)"
            self.accelZLabel.text = "Z: \(z)"
            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
        })
        
        //DEFINE CLOSURE TO HANDLE GYROSCOPE UPDATES
        let gyroscopeUpdateHandler = MotionDataModel.GyroscopeUIDelegate(updateHandler: {
            (x: Int16, y: Int16, z: Int16) in
            print("GYRO x: \(x), y: \(y), z: \(z)")
            self.gyroXLabel.text = "X: \(x)"
            self.gyroYLabel.text = "Y: \(y)"
            self.gyroZLabel.text = "Z: \(z)"
            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
        })
        
        //DEFINE CLOSURE TO HANDLE RPM UPDATES
        let rpmUpdateHandler = MotionDataModel.RpmUIDelegate(updateHandler: {
            (rpm: UInt16) in
            print("New rpm: \(rpm)")
            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
            self.gaugeView.setRPM(rpm: Int(rpm))
        })
        
        //INITIALIZE MOTION DATA MODEL
        motionDataModel = MotionDataModel(accelerationDelegate: accelerationUpdateHandler, gyroscopeDelegate: gyroscopeUpdateHandler, rpmDelegate: rpmUpdateHandler)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "STidget"
        motionDataModel.enableUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motionDataModel.disableUpdates()
    }
    
    override func viewDidLayoutSubviews() {

    }
    
}



//MARK: MANAGE STIDGET CONNECTION FAILURE
extension MotionViewController: STidgetConnectionFailureDelegate{
    
    func stidgetConnectionFailed() {
        //RETURN TO HOME SCREEN
        self.navigationController?.popToRootViewController(animated: true)
        print("MOTION VIEW CONTROLLER: Connection Failed")
    }
}
