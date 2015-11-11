//
//  Server.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/23.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit

class Server: NSObject {
    
    var ip = String()
    
    var currentUrl = String()
    var heartbeatUrl = String()
    var downloadUrl = String()
    
    override init() {
        super.init()
        
        ip = getInitialIPValue()
        
        currentUrl = "http://" + ip + ":18080/v1/current"
        downloadUrl = "http://" + ip + ":10086/"
        
    }
    
    func getInitialIPValue() -> String{
        var result = String()
        
        var standardDefaluts = NSUserDefaults.standardUserDefaults()
        if let ipValue: AnyObject = standardDefaluts.objectForKey("ip_preference"){
            result = String(ipValue as! NSString)
        }else{
            result = "192.168.1.100"
            standardDefaluts.setObject(result, forKey: "ip_preference")
            standardDefaluts.synchronize()
        }
        
        println("ip result = \(result)")
        standardDefaluts.synchronize()
        return result
    }
   
}
