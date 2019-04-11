//
//  DeviceSelectorViewController.swift
//  STidget
//
//  Created by Joe Bakalor on 11/27/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import UIKit
import CoreBluetooth

//STIDGET SINGLETON
let stidgetGATT = STidgetGATT()
var stidget: STidget!
var globalHomeButton: UIButton?


class DeviceSelectorViewController: UIViewController {
    
    @IBOutlet weak var stidgetImageView: UIImageView!
    @IBOutlet weak var stidgetStatusText: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var testPeripheral: CBPeripheral!
    var animate = true
    
    override func viewDidLoad() {
        
        let tabBarAppearence = UITabBarItem.appearance()
        tabBarAppearence.setTitleTextAttributes([NSAttributedStringKey.font:UIFont(name: "System Font", size: 16)!], for: .normal)
        
        //INITIALIZE STIDGET SINGLETON
        stidget = STidget()
        super.viewDidLoad()
        
        //SET DEVICE MANAGER DELEGATE
        stidget.setDeviceManager(Manager: self)
        stidget.discover()
        setupUI()
    }
    
    
    //SETUP UI
    func setupUI(){
        
        //SET STATUS TEST TO APPROPRIATE STRING
        stidgetStatusText.text = "Searching..."
        
        //DISABLE AND HIDE CONNECT BUTTON UNTIL STIDGET IS FOUND
        connectButton.isEnabled = false
        connectButton.layer.opacity = 0
        
        //ST LOGO SIZE = 2086 X 674
        //FUTURE LOGO SIZE = 399 X 104
        
//        let imageSize2 = CGSize(width: (((self.navigationController?.navigationBar.frame.height)!) - 10)*(2086/674), height: (self.navigationController?.navigationBar.frame.height)! - 10)
//        let imageOrigin2 =  CGPoint(x: (self.navigationController?.navigationBar.frame.width)! - imageSize2.width - 5 , y: 5)
//        let imageView2 = UIImageView(frame: CGRect(origin: imageOrigin2, size: imageSize2))
//        imageView2.image = #imageLiteral(resourceName: "ST_Bloc marque_Qi_H_LARGE_Rev.png")
//
//        self.navigationController?.navigationBar.addSubview(imageView2)
//
//        //ADD FUTURE LOGO TO NAVIGATION BAR
//        let imageSize = CGSize(width: (((self.navigationController?.navigationBar.frame.height)!) - 10)*(399/104), height: (self.navigationController?.navigationBar.frame.height)! - 10)
//        let imageOrigin =  CGPoint(x: imageSize.width/1.5, y: 5)
//        let imageView = UIImageView(frame: CGRect(origin: imageOrigin, size: imageSize))
//        imageView.image = #imageLiteral(resourceName: "Future_H_RGB_LG_Rev.png")// #imageLiteral(resourceName: "FutureLogo2.png")
//
//        self.navigationController?.navigationBar.addSubview(imageView)
    }
    
    @objc func buttonPressed(_ sender: UIButton!){
        print("Home Button pressed")
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        stidgetStatusText.text = "Searching..."
        
        connectButton.isEnabled = false
        connectButton.layer.opacity = 0
        
        //SET STIDGET DEVICE MANAGER DELEGATE
        stidget.setDeviceManager(Manager: self)
        
        //GET CURRENT STIDGET STATUS
        let stidgetStatus = stidget.getSTidgetStatus()
        
        if stidgetStatus == .connected{
            stidget.disconnect()
        }else if stidgetStatus == .idle || stidgetStatus == .unknown{
            animate = true
            //ADD ROTATION ANIMATION TO STIDGET IMAGE
            rotateView(targetView: stidgetImageView)
            stidget.discover()
        }
    }
    
    //USER CONNNECT BUTTON, INITIATES CONNECTION TO FOUND STIDGET
    @IBAction func connectButton(_ sender: UIButton) {
        animate = true
        //ADD ROTATION ANIMATION TO STIDGET IMAGE
        rotateView(targetView: stidgetImageView)
        stidgetStatusText.text = "Connecting!"
        stidget.connect()
    }
}

//MARK: STidgetDeviceManager Protocol
extension DeviceSelectorViewController: STidgetDeviceManager{
    
    func foundStidget() {
        
        animate = false
        UIView.animate(withDuration: 0.5, animations: {
            self.connectButton.layer.opacity = 1
        })
        connectButton.isEnabled = true
        stidgetStatusText.text = "Found MapleCandy"
    }
    
    func connected() {
        animate = false
        //REMOVE SELF AS STIDGET DEVICE MANAGER DELEGATE
        stidget.setDeviceManager(Manager: nil)
        
        //SETUP TRANSISTION TO TAB VIEW CONTROLLER
        let transistion = CATransition()
        transistion.subtype = kCATransitionReveal
        view.window!.layer.add(transistion, forKey: kCATransition)
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "tabViewController") as! UITabBarController
        
        //TRANSISTION TO TABVIEW CONTROLLER
        self.navigationController?.show(newView, sender: self)
    }
    
    func disconnected() {
        animate = true
        //ADD ROTATION ANIMATION TO STIDGET IMAGE
        rotateView(targetView: stidgetImageView)
        print("Start discovering again")
        stidget.discover()
    }
    
    func connectionFailed() {
        animate = true
        //ADD ROTATION ANIMATION TO STIDGET IMAGE
        rotateView(targetView: stidgetImageView)
        print("Start discovering again")
        stidget.discover()
    }
}

//MARK: ROTATION ANIMATION FOR STIDGET SPINNER
extension DeviceSelectorViewController{
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            if self.animate{
                self.rotateView(targetView: targetView, duration: duration)
            }else{
                
            }
        }
    }
}









//SETUP AND ADD FUTURE ELECTRONICS LOGO TO STIDGET SPINNER
//        let logoSize = CGSize(width: stidgetImageView.frame.size.width * 0.15, height: stidgetImageView.frame.size.width * 0.15)
//        let yCoord = stidgetImageView.frame.maxY - stidgetImageView.frame.size.height/2 - logoSize.height/2
//        let xCoord = stidgetImageView.frame.minX + stidgetImageView.frame.size.width/2 - logoSize.width/2
//        let logoOrigin = CGPoint(x: xCoord, y: yCoord)
//        let futureLogoImageView = UIImageView(frame: CGRect(origin: logoOrigin, size: logoSize))
//        futureLogoImageView.image = #imageLiteral(resourceName: "futureLogoOption1.png")
//        self.view.addSubview(futureLogoImageView)
