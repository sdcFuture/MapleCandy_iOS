//
//  LEDControlViewController.swift
//  STidget
//
//  Created by Joe Bakalor on 11/22/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import UIKit

class LEDControlViewController: UIViewController, ColorChangeDelegate {

    @IBOutlet weak var colorPicker: SwiftHSVColorPicker!
    @IBOutlet weak var selectedColorView: SelectedColorView!
    @IBOutlet weak var brightnessSliderView: BrightnessView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    var ledDataModel: LEDControllerDataModel!
    var setupComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ledDataModel = LEDControllerDataModel(ledDelegate: nil)
        stidget.setDisconnectionDelegate(delegate: self)
    }
    
    func setupUI(){
        
        redButton.clipsToBounds = true
        redButton.layer.cornerRadius = 5
        redButton.titleLabel?.minimumScaleFactor = 0.5
        redButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        greenButton.clipsToBounds = true
        greenButton.layer.cornerRadius = 5
        greenButton.titleLabel?.minimumScaleFactor = 0.5
        greenButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        blueButton.clipsToBounds = true
        blueButton.layer.cornerRadius = 5
        blueButton.titleLabel?.minimumScaleFactor = 0.5
        blueButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        selectedColorView.clipsToBounds = true
        selectedColorView.layer.cornerRadius = 5
        brightnessSliderView.layer.cornerRadius = 5
    }
    
    override func viewDidLayoutSubviews() {
        //print("RED BUTTON BOUNDS = \(redButton.titleLabel!.bounds.size)")
        //print("GREEN BUTTON BOUNDS = \(greenButton.titleLabel!.bounds.size)")
        //print("BLUE BUTTON BOUNDS = \(blueButton.titleLabel!.bounds.size)")
        
        //ONLY RUN ONCE OTHERWISE WILL BE CALLED WHENEVER VIEW ARE UPDATED
        if setupComplete == false{
            brightnessSliderView.delegate = colorPicker
            colorPicker.setViewColor(UIColor.white, brightnessViewIn: brightnessSliderView, selectedColorViewIn: selectedColorView)
            
            colorPicker.colorChangeDelegate = self
            setupComplete = true
        }
        brightnessSliderView.setNeedsDisplay()
        //self.view.setNeedsDisplay()
        print("Layout Subviews")
    }
    
    func colorUpdatedTo(color: RGB) {
        redButton.setTitle("RED: \(Int(color.red * 255))", for: .normal)
        greenButton.setTitle("GREEN: \(Int(color.green * 255))", for: .normal)
        blueButton.setTitle("BLUE: \(Int(color.blue * 255))", for: .normal)
        //print("RGB Returned = \(color)")
        stidget.setLedColor(red: UInt8(color.red * 255), green: UInt8(color.green * 255), blue: UInt8(color.blue * 255))
        //stidget.setLedColor(red: 0, green: 0, blue: 255)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "STidget"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ledDataModel.removeDelegates()
    }

}


//MARK: MANAGE STIDGET CONNECTION FAILURE
extension LEDControlViewController: STidgetConnectionFailureDelegate{
    func stidgetConnectionFailed() {
        //RETURN TO HOME SCREEN
        self.navigationController?.popToRootViewController(animated: true)
        print("LED CONTROL VIEW CONTROLLER: Connection Failed")
    }
    
}































extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}
