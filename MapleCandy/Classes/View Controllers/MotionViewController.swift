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
    @IBOutlet weak var ADC0label: UILabel!
    @IBOutlet weak var ADC1label: UILabel!
    @IBOutlet weak var ADC2label: UILabel!
    
    //Gyro view labels
    @IBOutlet weak var gyroXLabel: UILabel!
    @IBOutlet weak var gyroYLabel: UILabel!
    @IBOutlet weak var gyroZLabel: UILabel!
    
    @IBOutlet weak var gaugeView: GaugeView!
    
    @IBOutlet weak var DAC0Label: UILabel!
    @IBOutlet weak var DAC1Label: UILabel!
    
    @IBOutlet weak var ChannelSelect: UISegmentedControl!
    
    struct GlobalVar {
        static var ChannelNumber = UInt8 (0)
        static var lastChannelNumber = UInt8 (0)
        static var lastDAC0 = Float (0)
        static var lastDAC1 = Float (0)
        static var lastNeedlePosChannel0 = (Int (0))
        static var lastMeasureStrChannel0 = String("0.00")
        static var lastNeedlePosChannel1 = (Int (0))
        static var lastMeasureStrChannel1 = String("0.00")
        static var lastNeedlePosChannel2 = (Int (0))
        static var lastMeasureStrChannel2 = String("0.00")
    }
    
    @IBAction func ChannelChanged(_ sender: UISegmentedControl) {
        
        GlobalVar.lastChannelNumber = GlobalVar.ChannelNumber;
        switch ChannelSelect.selectedSegmentIndex
        {
            case 0:
                GlobalVar.ChannelNumber = 0;
                self.gaugeView.setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel0, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel0)
            case 1:
                GlobalVar.ChannelNumber = 1;
                self.gaugeView.setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel1, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel1)
            case 2:
                GlobalVar.ChannelNumber = 2;
                self.gaugeView.setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel2, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel2)
            default:
                GlobalVar.ChannelNumber = 0;
                self.gaugeView.setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel0, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel0)
        }
        maplecandy.setDAC(DAC0: GlobalVar.lastDAC0, DAC1: GlobalVar.lastDAC1)
        self.gaugeView.redrawGauge()
        GlobalVar.lastChannelNumber = GlobalVar.ChannelNumber;
    }

    @IBAction func slider(_ sender: UISlider) {
        DAC0Label.text = "0: " + String(format: "%.2f", sender.value)
        maplecandy.setDAC(DAC0: Float(sender.value), DAC1: GlobalVar.lastDAC1)
        GlobalVar.lastDAC0 = sender.value
    }
    
    @IBAction func slider2(_ sender: UISlider) {
        DAC1Label.text = "1: " + String(format: "%.2f", sender.value)
        maplecandy.setDAC(DAC0: GlobalVar.lastDAC0, DAC1: Float(sender.value))
        GlobalVar.lastDAC1 = sender.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        maplecandy.setDisconnectionDelegate(delegate: self)
        
        self.ADC0label.text = "0: 0.00"
        self.ADC1label.text = "1: 0.00"
        self.ADC2label.text = "2: 0.00"
        DAC0Label.text = "0: 0.00"
        DAC1Label.text = "0: 0.00"

        //DEFINE CLOSURE TO HANDLE ACCELEROMETER UPDATES
        let accelerationUpdateHandler = MotionDataModel.AccelerationUIDelegate(updateHandler: {
            (x: Int16, y: Int16, z: Int16) in
            print("ADC 0: \(x), 1: \(y), 2: \(z)")
            //self.ADC0label.text = "0:\(x)"
            //Measurement * 3.3/4095
            let ADC0StringFloat = String(format: "%.2f",Float(x) * 8.058608e-4);
            self.ADC0label.text = "0: \(ADC0StringFloat)"
            
            //Measurement * 10.0/4095
            //self.ADC1label.text = "1: \(y)"
            let ADC1StringFloat = String(format: "%.2f",Float(y) * 2.442002e-3)
            self.ADC1label.text = "1: \(ADC1StringFloat)"
            
            //Measurement * 20.0/4095
            //self.ADC2label.text = "2: \(z)"
            let ADC2StringFfloat = String(format: "%.2f",Float(z) * 4.884004e-3)
            self.ADC2label.text = "2: \(ADC2StringFfloat)"

            //DEFINE HOW YOU WANT THE UI TO PROCESS THE DATA
            
            //Needle Position = Measurement * (383/4095)
            let needleConversionFactor = Float(0.0935286935)
   
            switch GlobalVar.ChannelNumber
            {
            case 0:
                let gaugeNeedlePos = Int (Float(x) * needleConversionFactor)
                print("Needle Channel 0 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: ADC0StringFloat)
                GlobalVar.lastNeedlePosChannel0 = gaugeNeedlePos
                GlobalVar.lastMeasureStrChannel0 = ADC0StringFloat
            case 1:
                let gaugeNeedlePos = Int (Float(y) * needleConversionFactor)
                print("Needle Channel 1 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: ADC1StringFloat)
                GlobalVar.lastNeedlePosChannel1 = gaugeNeedlePos
                GlobalVar.lastMeasureStrChannel1 = ADC1StringFloat
            case 2:
                let gaugeNeedlePos = Int (Float(z) * needleConversionFactor)
                print("Needle Channel 2 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: ADC2StringFfloat)
                GlobalVar.lastNeedlePosChannel2 = gaugeNeedlePos
                GlobalVar.lastMeasureStrChannel2 = ADC0StringFloat
            default:
                let gaugeNeedlePos = Int (Float(x) * needleConversionFactor)
                print("Needle Channel 0 = \(gaugeNeedlePos)")
                self.gaugeView.setRPM(rpm: gaugeNeedlePos, measureStr: ADC0StringFloat)
                GlobalVar.lastNeedlePosChannel0 = gaugeNeedlePos
                GlobalVar.lastMeasureStrChannel0 = ADC0StringFloat
            }
            
            })
        
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
        self.tabBarController?.title = "Maple Candy 1.0.0"
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
