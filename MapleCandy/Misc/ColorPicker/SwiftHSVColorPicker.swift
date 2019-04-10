//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//

import UIKit


protocol ColorChangeDelegate {
    func colorUpdatedTo(color: RGB)
}

open class SwiftHSVColorPicker: UIView, ColorWheelDelegate, BrightnessViewDelegate {
    var colorWheel: ColorWheel!
    var brightnessView: BrightnessView!
    var selectedColorView: SelectedColorView!
    
    //SECONDARY VIEWS
    var brightnessViewJB: BrightnessView?
    var selectedColorViewJB: SelectedColorView?

    open var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    
    var colorChangeDelegate: ColorChangeDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setViewColor(_ color: UIColor, brightnessViewIn: BrightnessView, selectedColorViewIn: SelectedColorView) {
        
        brightnessViewJB = brightnessViewIn
        selectedColorViewJB = selectedColorViewIn
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color
        setup()
    }
    
    func setup() {
        // Remove all subviews
        let views = self.subviews
        for view in views {
            view.removeFromSuperview()
        }
        
        let selectedColorViewHeight: CGFloat = 44.0
        let brightnessViewHeight: CGFloat = 26.0
        
        // let color wheel get the maximum size that is not overflow from the frame for both width and height
        let colorWheelSize = min(self.bounds.width, self.bounds.height)
        let wheelSize = min(self.frame.size.width, self.frame.size.height)
        
        print("Frame width = \(self.frame.size.width), height = \(self.frame.size.height)")
        print("Wheel size = \(wheelSize)")
        // let the all the subviews stay in the middle of universe horizontally
        let centeredX = (self.frame.size.width - wheelSize) / 2.0
        
        // Init SelectedColorView subview
        selectedColorView = SelectedColorView(frame: CGRect(x: centeredX + 25, y:0, width: colorWheelSize - 50, height: selectedColorViewHeight), color: self.color)
        
        // Add selectedColorView as a subview of this view
        //self.addSubview(selectedColorView)
        //selectedColorView.isHidden = true
        
        // Init new ColorWheel subview
        colorWheel = ColorWheel(frame: CGRect(x: self.frame.size.width/2 - colorWheelSize/2, y: self.frame.size.height/2 - colorWheelSize/2, width: wheelSize, height: wheelSize), color: self.color)
        colorWheel.delegate = self
        colorWheel.backgroundColor = UIColor.clear
        print("Color wheel frame = \(colorWheel.frame)")
        // Add colorWheel as a subview of this view
        self.addSubview(colorWheel)
        
        // Init new BrightnessView subview
        //brightnessView = BrightnessView(frame: CGRect(x: centeredX + 25, y: colorWheel.frame.maxY, width: colorWheelSize - 50, height: brightnessViewHeight), color: self.color)
        //brightnessView.delegate = self
        brightnessViewJB?.setColorLayer(color: self.color)
        //brightnessViewJB = BrightnessView(frame: brightnessViewJB!.frame, color: self.color)
        brightnessViewJB?.delegate = self
        // Add brightnessView as a subview of this view
        //self.addSubview(brightnessView)
        //brightnessView.isHidden = true
    }
    
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        
        //brightnessView.setViewColor(self.color)
        brightnessViewJB!.setViewColor(self.color)
        
        selectedColorView.setViewColor(self.color)
        selectedColorViewJB!.setViewColor(self.color)
        
        colorChangeDelegate?.colorUpdatedTo(color: hsv2rgb((hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)))
    }
    
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        colorWheel.setViewBrightness(brightness)
        
        selectedColorView.setViewColor(self.color)
        selectedColorViewJB!.setViewColor(self.color)
        
        colorChangeDelegate?.colorUpdatedTo(color: hsv2rgb((hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)))
    }
}
