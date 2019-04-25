//
//  DeviceSelectorViewController.swift
//  MapleCandy
//
//  Created by SDC Future Electronics on 4/12/19.
//  Copyright © 2019 SDC Future Electronics. All rights reserved.
//

import UIKit
import CoreBluetooth

//MAPLECANDY SINGLETON
let maplecandyGATT = MapleCandyGATT()
var maplecandy: MapleCandy!
var globalHomeButton: UIButton?


class DeviceSelectorViewController: UIViewController {
    
    @IBOutlet weak var maplecandyImageView: UIImageView!
    @IBOutlet weak var maplecandyStatusText: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var PrivacyPolicyButton: UIButton!
    var testPeripheral: CBPeripheral!
    var animate = true
    
    
    @IBAction func openPrivacyPolicy(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.futureelectronics.com/policies/privacy-policy/")! as URL, options: [:], completionHandler:nil)
    }
    
    override func viewDidLoad() {
        let tabBarAppearence = UITabBarItem.appearance()
        tabBarAppearence.setTitleTextAttributes([NSAttributedStringKey.font:UIFont(name: "System Font", size: 16)!], for: .normal)
        
        self.PrivacyPolicyButton.layer.cornerRadius = 5
        //INITIALIZE MAPLECANDY SINGLETON
        maplecandy = MapleCandy()
        super.viewDidLoad()
        
        //SET DEVICE MANAGER DELEGATE
        maplecandy.setDeviceManager(Manager: self)
        maplecandy.discover()
        setupUI()
        //dispNavBarImage()
    }
    
    func dispNavBarImage() {
        
        let image = #imageLiteral(resourceName: "renesas_rl78_logo.png")
        let imageView = UIImageView(image: image)
        let navController = self.navigationController!
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    

    //SETUP UI
    func setupUI(){
        
        //SET STATUS TEST TO APPROPRIATE STRING
        maplecandyStatusText.text = "Searching..."
        
        //DISABLE AND HIDE CONNECT BUTTON UNTIL MAPLECANDY IS FOUND
        connectButton.isEnabled = false
        connectButton.layer.opacity = 0
        
        //FUTURE LOGO SIZE = 399 X 104
        
//        let imageSize2 = CGSize(width: (((self.navigationController?.navigationBar.frame.height)!) - 10)*(2086/674), height: (self.navigationController?.navigationBar.frame.height)! - 10)
//        let imageOrigin2 =  CGPoint(x: (self.navigationController?.navigationBar.frame.width)! - imageSize2.width - 5 , y: 5)
//        let imageView2 = UIImageView(frame: CGRect(origin: imageOrigin2, size: imageSize2))
//
//        self.navigationController?.navigationBar.addSubview(imageView2)
//
        //ADD RENESAS RL78 LOGO TO NAVIGATION BAR
//        let imageSize = CGSize(width: (((self.navigationController?.navigationBar.frame.height)!) - 10)*(399/104), height: (self.navigationController?.navigationBar.frame.height)! - 6)
//        let imageOrigin =  CGPoint(x: imageSize.width/1.5+5, y: 5)
//        let imageView = UIImageView(frame: CGRect(origin: imageOrigin, size: imageSize))
//        imageView.image = #imageLiteral(resourceName: "Renesas_Rl78_Logo.png")// #imageLiteral(resourceName: "FutureLogo2.png")

//        self.navigationController?.navigationBar.addSubview(imageView)
        
    }
    
    @objc func buttonPressed(_ sender: UIButton!){
        print("Home Button pressed")
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        maplecandyStatusText.text = "Searching..."
        
        connectButton.isEnabled = false
        connectButton.layer.opacity = 0
        
        //SET MAPLECANDY DEVICE MANAGER DELEGATE
        maplecandy.setDeviceManager(Manager: self)
        
        //GET CURRENT MAPLECANDY STATUS
        let maplecandyStatus = maplecandy.getMapleCandyStatus()
        
        if maplecandyStatus == .connected{
            maplecandy.disconnect()
        }else if maplecandyStatus == .idle || maplecandyStatus == .unknown{
            animate = true
            //ADD ROTATION ANIMATION TO MAPLECANDY IMAGE
            rotateView(targetView: maplecandyImageView)
            maplecandy.discover()
        }
    }
    
    //USER CONNNECT BUTTON, INITIATES CONNECTION TO FOUND MAPLECANDY
    @IBAction func connectButton(_ sender: UIButton) {
        animate = true
        //ADD ROTATION ANIMATION TO MAPLECANDY IMAGE
        rotateView(targetView: maplecandyImageView)
        maplecandyStatusText.text = "Connecting..."
        maplecandy.connect()
    }
}

//MARK: MapleCandyDeviceManager Protocol
extension DeviceSelectorViewController: MapleCandyDeviceManager{
    
    func foundMaplecandy() {
        
        animate = false
        UIView.animate(withDuration: 0.5, animations: {
            self.connectButton.layer.opacity = 1
        })
        connectButton.isEnabled = true
        maplecandyStatusText.textColor = UIColor(red: 0.0, green:0.502, blue: 0.502, alpha: 1.0)
        maplecandyStatusText.text = "Candy found!"
    }
    
    func connected() {
        animate = false
        //REMOVE SELF AS MAPLECANDY DEVICE MANAGER DELEGATE
        maplecandy.setDeviceManager(Manager: nil)
        
        //SETUP TRANSISTION TO TAB VIEW CONTROLLER
        let transistion = CATransition()
        transistion.subtype = kCATransitionReveal
        view.window!.layer.add(transistion, forKey: kCATransition)
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "tabViewController") as! UITabBarController
        
        //TRANSISTION TO TABVIEW CONTROLLER
        self.navigationController?.show(newView, sender: self)
        
        clearGlobalVar()
    }
    
    func disconnected() {
        animate = true
        //ADD ROTATION ANIMATION TO MAPLECANDY IMAGE
        rotateView(targetView: maplecandyImageView)
        print("Start discovering again")
        maplecandy.discover()
    }
    
    func connectionFailed() {
        animate = true
        //ADD ROTATION ANIMATION TO MAPLECANDY IMAGE
        rotateView(targetView: maplecandyImageView)
        print("Start discovering again")
        maplecandy.discover()
    }
    
    func clearGlobalVar(){
        MotionViewController.GlobalVar.ChannelNumber = UInt8 (0)
        MotionViewController.GlobalVar.lastChannelNumber = UInt8 (0)
        MotionViewController.GlobalVar.lastDAC0 = Float (0)
        MotionViewController.GlobalVar.lastDAC1 = Float (0)
        MotionViewController.GlobalVar.lastNeedlePosChannel0 = (Int (0))
        MotionViewController.GlobalVar.lastMeasureStrChannel0 = String("0.00")
        MotionViewController.GlobalVar.lastNeedlePosChannel1 = (Int (0))
        MotionViewController.GlobalVar.lastMeasureStrChannel1 = String("0.00")
        MotionViewController.GlobalVar.lastNeedlePosChannel2 = (Int (0))
        MotionViewController.GlobalVar.lastMeasureStrChannel2 = String("0.00")
    }
}

//MARK: ROTATION ANIMATION FOR MAPLECANDY SPINNER
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

