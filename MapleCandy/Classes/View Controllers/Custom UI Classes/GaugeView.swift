//
//  GaugeView.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import UIKit

class GaugeView: UIView
{
    
    @IBInspectable var indicatorImage = UIImageView()
    
    var indicatorView               : UIImageView!
    var animationTestTimer          : Timer?
    var valueLabel                  : UILabel!
    var zeroAngle                   = CGFloat(Double.pi * -136/180)
    var setupComplete               = false
    var lastRpm                     = 0
    var currentAngle: Double        = -135
    var baseAngle: Double           = -135
    var animationLock               = false
    
    override func draw(_ rect: CGRect) {
        
        //BASELINE DIMINSIONS
        let superViewWidth                   = rect.size.width
        let superViewHeight                  = rect.size.height
        let imageViewWidth                   = min(superViewWidth, superViewHeight)
        
        //SETUP GAUGE IMAGE VIEW
        let gaugeXCoordinate                 = superViewWidth/2 - imageViewWidth/2
        let gaugeYCoordinate                 = superViewHeight/2 - imageViewWidth/2
        let gaugeOrigin                      = CGPoint(x: gaugeXCoordinate, y: gaugeYCoordinate)
        let gaugeSize                        = CGSize(width: imageViewWidth, height: imageViewWidth)
        let newImageView                     = UIImageView(frame: CGRect(origin: gaugeOrigin, size: gaugeSize))
        
        //SET GUAGE BACKGROUND IMAGE BASED ON CURRENT CONFIGURTATION
        //switch gaugeOption{
        switch(MotionViewController.GlobalVar.ChannelNumber) {
        case 0:
            newImageView.image               = #imageLiteral(resourceName: "Gauge1")
            print("Draw Gauge 0")
        case 1:
            newImageView.image               = #imageLiteral(resourceName: "Gauge2")
            print("Draw Gauge 1")
        case 2:
            newImageView.image               = #imageLiteral(resourceName: "Gauge3")
            print("Draw Gauge 2")
        default:
            newImageView.image               = #imageLiteral(resourceName: "Gauge1")
            print("Draw Gauge 3")
        }
        
        self.addSubview(newImageView)
        
        //SETUP AND ADD VALUE LABEL TO GAUGE
        let valueLabelXCoordinate            = newImageView.bounds.size.width/2 - imageViewWidth/4
        let valueLabelYCoordinate            = newImageView.bounds.size.height - newImageView.bounds.size.width/5.5
        let labelOrigin                      = CGPoint(x: valueLabelXCoordinate , y: valueLabelYCoordinate - self.bounds.size.height * 0.052)
        let labelSize                        = CGSize(width: (imageViewWidth/2), height: self.bounds.size.height * 0.175)
        valueLabel                           = UILabel(frame: CGRect(origin: labelOrigin, size: labelSize))
        valueLabel.text                      = "0.00"
        valueLabel.textAlignment             = .center
        valueLabel.font                      = UIFont(name: valueLabel.font.fontName, size: 60)
        valueLabel.numberOfLines             = 0
        valueLabel.adjustsFontSizeToFitWidth = true

        //ADD LABEL VIEW TO IMAGE VIEW
        newImageView.addSubview(valueLabel)
        valueLabel.isHidden = false
        
        //SETUP AND ADD INDICATOR IMAGE VIEW
        let indicatorXCoordinate             = superViewWidth/2 - (imageViewWidth/3.25)/2
        let indicatorYCoordinate             = superViewHeight/2 - imageViewWidth/2
        let indicatorSize                    = CGSize(width: imageViewWidth/3.25, height: imageViewWidth * 0.985)
        let indicatorOrigin                  = CGPoint(x: indicatorXCoordinate, y: indicatorYCoordinate)
        indicatorView                        = UIImageView(frame: CGRect(origin: indicatorOrigin, size: indicatorSize))
        indicatorView.image                  = #imageLiteral(resourceName: "NewIndicatorTwo")
        
        //ADD INDICATOR VIEW TO VIEW
        self.addSubview(indicatorView)
        
        //INITIALIZE INDICATOR POSITION TO ZERO VALUE
        UIView.animate(withDuration: 0, animations: {
            self.indicatorView.transform = self.indicatorView.transform.rotated(by: self.zeroAngle)
            self.layoutIfNeeded()
        })
        
        switch MotionViewController.GlobalVar.ChannelNumber
        {
        case 0:
            setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel0, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel0)
            print("Chan0 last needle pos: \(MotionViewController.GlobalVar.lastNeedlePosChannel0) ")
        case 1:
            setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel1, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel1)
            print("Chan1 last needle pos: \(MotionViewController.GlobalVar.lastNeedlePosChannel1) ")
        case 2:
            setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel2, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel2)
            print("Chan2 last needle pos: \(MotionViewController.GlobalVar.lastNeedlePosChannel2) ")
        default:
            setRPM(rpm: MotionViewController.GlobalVar.lastNeedlePosChannel0, measureStr: MotionViewController.GlobalVar.lastMeasureStrChannel0)
            print("Chan0 last needle pos: \(MotionViewController.GlobalVar.lastNeedlePosChannel0) ")
        }
        
        //animationTestTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.serviceRPM), userInfo: nil, repeats: true)
    }
    
    @objc func serviceRPM(){
        let newRandomRpm = Int(arc4random_uniform(1500))
        let rpmToAngleChange = ((Float(newRandomRpm)/1500)*270)*Float(Double.pi/180)
        updateRpmTest(angleChange: rpmToAngleChange)
        valueLabel.text = "\(newRandomRpm)"
        lastRpm = newRandomRpm
    }
    
    func setRPM(rpm: Int, measureStr: String){
        //let newRandomRpm = Int(arc4random_uniform(1500))
        let rpmToAngleChange = ((Float(rpm)/382)*270)//*Float(Double.pi/180)
        updateRpmTest(angleChange: rpmToAngleChange)
        valueLabel.text = "\(measureStr)"
        lastRpm = rpm
    }
    
    func redrawGauge(){
        self.setNeedsDisplay()
    }
    
    func initGaugeNeedlePos(){
        //INITIALIZE INDICATOR POSITION TO ZERO VALUE
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.transform = self.indicatorView.transform.rotated(by: self.zeroAngle)
            self.layoutIfNeeded()
        })
    }
    
    func updateRpmTest(angleChange: Float){
        //ROTATE INDICATOR TO MATCH NEW RPM
        var angleInDegrees = (angleChange + 135)
        
        //If channel change do not show needle animation
        if (MotionViewController.GlobalVar.ChannelNumber != MotionViewController.GlobalVar.lastChannelNumber) {
            UIView.animate(withDuration: 0, animations: {
                //self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat(angleChange - Float(((Double.pi/180)*135))))
                //self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat((angleChange/2 - 135)*Float(Double.pi/180)))
                self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat((angleChange - 135)*Float(Double.pi/180)))
                
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                //self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat(angleChange - Float(((Double.pi/180)*135))))
                self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat((angleChange/2 - 135)*Float(Double.pi/180)))
                self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat((angleChange - 135)*Float(Double.pi/180)))
                
            })
        }
    }

}
