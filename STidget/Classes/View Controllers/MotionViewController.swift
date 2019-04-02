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
    
    @IBOutlet weak var DACLabel: UILabel!
    
    @IBOutlet weak var DAC1Label: UILabel!
    @IBAction func skider2(_ sender: Any) {
    }
    @IBAction func slider(_ sender: UISlider) {
        DACLabel.text = String(format: "%.1f", sender.value) + " Volts"
        stidget.setDAC(DAC0: Float(sender.value), DAC1: Float(0))
        
        //Send data multiple times for debug
        
        //let ms = 1000
        //usleep(useconds_t(100 * ms)) //sleep 100 msec
        //stidget.setDAC(DAC0: Float(sender.value), DAC1: Float(0))

        //usleep(useconds_t(100 * ms)) //sleep 100 msec
        //stidget.setDAC(DAC0: Float(sender.value), DAC1: Float(0))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        stidget.setDisconnectionDelegate(delegate: self)
        
        //DEFINE CLOSURE TO HANDLE ACCELEROMETER UPDATES
        let accelerationUpdateHandler = MotionDataModel.AccelerationUIDelegate(updateHandler: {
            (x: Int16, y: Int16, z: Int16) in
            print("ACC x: \(x), y: \(y), z: \(z)")
            //self.accelXLabel.text = "0:\(x)"
            //Measurement * 3.3/4095
            let xStringFloat = String(format: "%.2f",Float(x) * 8.058608e-4);
            self.accelXLabel.text = "0: \(xStringFloat)"
            
            //Measurement * 10.0/4095
            //self.accelYLabel.text = "1: \(y)"
            let yStringFloat = String(format: "%.2f",Float(y) * 2.442002e-3)
            self.accelYLabel.text = "1: \(yStringFloat)"
            
            //Measurement * 20.0/4095
            //self.accelZLabel.text = "2: \(z)"
            let zStringFloat = String(format: "%.2f",Float(z) * 4.884004e-3)
            self.accelZLabel.text = "2: \(zStringFloat)"

            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
   
            //Needle Position = Measurement * 380/4095
            let gaugeNeedlePos = Int (Float(x) * 0.0927961)
            print("Needle Position = \(gaugeNeedlePos)")
            self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: xStringFloat)
        })
        
        //DEFINE CLOSURE TO HANDLE GYROSCOPE UPDATES
//        let gyroscopeUpdateHandler = MotionDataModel.GyroscopeUIDelegate(updateHandler: {
//            (x: Int16, y: Int16, z: Int16) in
//            print("GYRO x: \(x), y: \(y), z: \(z)")
//            self.gyroXLabel.text = "X: \(x)"
//            self.gyroYLabel.text = "Y: \(y)"
//            self.gyroZLabel.text = "Z: \(z)"
            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
//        })
        
        //DEFINE CLOSURE TO HANDLE RPM UPDATES
        let rpmUpdateHandler = MotionDataModel.RpmUIDelegate(updateHandler: {
            (rpm: UInt16) in
            //print("New rpm: \(rpm)")
            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
            //self.gaugeView.setRPM(rpm: Int(rpm))
        })
        
        //INITIALIZE MOTION DATA MODEL
        //motionDataModel = MotionDataModel(accelerationDelegate: accelerationUpdateHandler, gyroscopeDelegate: gyroscopeUpdateHandler, rpmDelegate: rpmUpdateHandler)
        motionDataModel = MotionDataModel(accelerationDelegate: accelerationUpdateHandler, gyroscopeDelegate: nil, rpmDelegate: rpmUpdateHandler)
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
