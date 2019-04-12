//
//  MotionViewController.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController {
    
    //Motion data model
    var motionDataModel: MotionDataModel!
    
    let ChannelNumber = 0
    
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
    
    @IBOutlet weak var ChannelSelect: UISegmentedControl!
    
    struct GlobalVar {
        static var ChannelNumber = UInt8 (0)
        static var settingDAC0 = Float (0)
        static var settingDAC1 = Float (0)
    }
    
    @IBAction func ChannelChanged(_ sender: UISegmentedControl) {
        
        switch ChannelSelect.selectedSegmentIndex
        {
            case 0:
                GlobalVar.ChannelNumber = 0;
            case 1:
                GlobalVar.ChannelNumber = 1;
            case 2:
                GlobalVar.ChannelNumber = 2;
            default:
                GlobalVar.ChannelNumber = 0;
        }
        maplecandy.setDAC(DAC0: GlobalVar.settingDAC0, DAC1: GlobalVar.settingDAC1)
        viewDidLoad()
    }

    @IBAction func slider(_ sender: UISlider) {
        DACLabel.text = "0: " + String(format: "%.2f", sender.value)
        maplecandy.setDAC(DAC0: Float(sender.value), DAC1: GlobalVar.settingDAC1)
        GlobalVar.settingDAC0 = sender.value
    }
    
    @IBAction func slider2(_ sender: UISlider) {
        DAC1Label.text = "1: " + String(format: "%.2f", sender.value)
        maplecandy.setDAC(DAC0: GlobalVar.settingDAC0, DAC1: Float(sender.value))
        GlobalVar.settingDAC1 = sender.value
    }
    
    override func   viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        maplecandy.setDisconnectionDelegate(delegate: self)
        
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
            
            //Needle Position = Measurement * (380/4095)
            let needleConversionFactor = Float(0.0927961)
   
            switch GlobalVar.ChannelNumber
            {
            case 0:
                let gaugeNeedlePos = Int (Float(x) * needleConversionFactor)
                print("Needle Channel 0 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: xStringFloat)
            case 1:
                let gaugeNeedlePos = Int (Float(y) * needleConversionFactor)
                print("Needle Channel 1 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: yStringFloat)
            case 2:
                let gaugeNeedlePos = Int (Float(z) * needleConversionFactor)
                print("Needle Channel 2 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: zStringFloat)
            default:
                let gaugeNeedlePos = Int (Float(x) * needleConversionFactor)
                print("Needle Channel 0 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: xStringFloat)
            }
            
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
        self.tabBarController?.title = "Maple Candy"
        motionDataModel.enableUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motionDataModel.disableUpdates()
    }

    override func viewDidLayoutSubviews() {

    }
    
}



//MARK: MANAGE MAPLECANDY CONNECTION FAILURE
extension MotionViewController: MapleCandyConnectionFailureDelegate{
    
    func maplecandyConnectionFailed() {
        //RETURN TO HOME SCREEN
        self.navigationController?.popToRootViewController(animated: true)
        print("MOTION VIEW CONTROLLER: Connection Failed")
    }
}
