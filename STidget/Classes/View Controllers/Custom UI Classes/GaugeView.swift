//
//  GaugeView.swift
//  STidget
//
//  Created by Joe Bakalor on 11/30/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import UIKit

class GaugeView: UIView
{
    enum GaugeOptions{
        case RPM
        case TEMP
        case LIGHT
        case PROX
    }
    

    //@IBInspectable var gaugeOption = GaugeOptions
    @IBInspectable var indicatorImage = UIImageView()
    
    let rpmRange                    = 0...1500
    var gaugeOption: GaugeOptions   = .RPM
    var indicatorView               : UIImageView!
    var animationTestTimer          : Timer?
    var valueLabel                  : UILabel!
    var zeroAngle                   = CGFloat(Double.pi * -136/180)
    var angleRange: Double          = 271
    var setupComplete               = false
    var lastRpm                     = 0
    var currentAngle: Double        = -135
    var baseAngle: Double           = -135
    var animationLock               = false
    
    override func draw(_ rect: CGRect) {
        
        //BASELINE DIMINSIONS
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
        switch gaugeOption{
        case .RPM:
            newImageView.image               = #imageLiteral(resourceName: "STTachFinal.png")
        case .PROX:
            newImageView.image               = #imageLiteral(resourceName: "STTachometer-2")
        case .TEMP:
            newImageView.image               = #imageLiteral(resourceName: "STTachometer-2")
        case .LIGHT:
            newImageView.image               = #imageLiteral(resourceName: "STTachometerLIGHT")
        }
        
        self.addSubview(newImageView)
        
        //SETUP AND ADD VALUE LABEL TO GAUGE
        let valueLabelXCoordinate            = newImageView.bounds.size.width/2 - imageViewWidth/4
        let valueLabelYCoordinate            = newImageView.bounds.size.height - newImageView.bounds.size.width/6
        let labelOrigin                      = CGPoint(x: valueLabelXCoordinate , y: valueLabelYCoordinate - self.bounds.size.height * 0.052)
        let labelSize                        = CGSize(width: (imageViewWidth/2), height: self.bounds.size.height * 0.175)
        valueLabel                           = UILabel(frame: CGRect(origin: labelOrigin, size: labelSize))
        valueLabel.text                      = "0"
        valueLabel.textAlignment             = .center
        valueLabel.font                      = UIFont(name: valueLabel.font.fontName, size: 60)
        valueLabel.numberOfLines             = 0
        valueLabel.adjustsFontSizeToFitWidth = true

        //ADD LABEL VIEW TO IMAGE VIEW
        newImageView.addSubview(valueLabel)
        valueLabel.isHidden = true
        
        //SETUP AND ADD INDICATOR IMAGE VIEW
        let indicatorXCoordinate             = superViewWidth/2 - (imageViewWidth/3.25)/2
        let indicatorYCoordinate             = superViewHeight/2 - imageViewWidth/2
        let indicatorSize                    = CGSize(width: imageViewWidth/3.25, height: imageViewWidth)
        let indicatorOrigin                  = CGPoint(x: indicatorXCoordinate, y: indicatorYCoordinate)
        indicatorView                        = UIImageView(frame: CGRect(origin: indicatorOrigin, size: indicatorSize))
        indicatorView.image                  = #imageLiteral(resourceName: "NewIndicatorTwo")
        
        //ADD INDICATOR VIEW TO VIEW
        self.addSubview(indicatorView)
        
        //INITIALIZE INDICATOR POSITION TO ZERO VALUE
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.transform = self.indicatorView.transform.rotated(by: self.zeroAngle)
            self.layoutIfNeeded()
        })
        
        //animationTestTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.serviceRPM), userInfo: nil, repeats: true)
    }
    
    @objc func serviceRPM(){
        let newRandomRpm = Int(arc4random_uniform(1500))
        let rpmToAngleChange = ((Float(newRandomRpm)/1500)*270)*Float(Double.pi/180)
        updateRpmTest(angleChange: rpmToAngleChange)
        valueLabel.text = "\(newRandomRpm)"
        lastRpm = newRandomRpm
    }
    
    func setRPM(rpm: Int){
        //let newRandomRpm = Int(arc4random_uniform(1500))
        let rpmToAngleChange = ((Float(rpm)/382)*270)//*Float(Double.pi/180)
        updateRpmTest(angleChange: rpmToAngleChange)
        valueLabel.text = "\(rpm)"
        lastRpm = rpm
    }
    
    func updateRpmTest(angleChange: Float){
        //ROTATE INDICATOR TO MATCH NEW RPM
        var angleInDegrees = (angleChange + 135)
        
        UIView.animate(withDuration: 0.25, animations: {
            //self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat(angleChange - Float(((Double.pi/180)*135))))
            self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat((angleChange/2 - 135)*Float(Double.pi/180)))
            self.indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat((angleChange - 135)*Float(Double.pi/180)))
            
        })

    }

}
