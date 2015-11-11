//
//  CommonLib.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/23.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit
import Foundation


class Poller {
    var timer: NSTimer?
    
    func start(obj: NSObject, method: Selector,timerInter: Double) {
        stop()
        
        timer = NSTimer(timeInterval: timerInter, target: obj, selector: method , userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        //NSRunLoopCommonModes
    }
    
    func stop() {
        if (isRun()){
            timer?.invalidate()
        }
    }
    
    func isRun() -> Bool{
        return (timer != nil && timer?.valid != nil)
    }
}


//SPDBColor
var SPDBBlueColor = UIColor(red: 11/255.0, green: 24/255.0, blue: 69/255.0, alpha: 1)
var SPDBRedColor = UIColor(red: 152/255.0, green: 0/255.0, blue: 28/255.0, alpha: 1)
var SPDBGrayColor = UIColor(red: 141/255.0, green: 141/255.0, blue: 141/255.0, alpha: 1)

func SPDBColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1)
}


func getGBDefaultManager() -> NSFileManager{
    return NSFileManager.defaultManager()
}

var jsonFilePath = NSHomeDirectory().stringByAppendingPathComponent("Documents/jsondata.txt")

var CurrentDidChangedNotification = "CurrentDidChangedNotification"
var CurrentDidChangedName = "CurrentDidChangedName"

var ConnectErrorNotification = "ConnectErrorNotification"

