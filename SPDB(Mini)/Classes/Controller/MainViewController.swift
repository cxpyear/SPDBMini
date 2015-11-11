//
//  MainViewController.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/23.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit
import Alamofire

var initCount = 0

class MainViewController: UIViewController {
    
    @IBOutlet weak var lblMeetingName: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var whiteBgView: UIView!
    
    var builder = Builder()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if server.ip == ""{
            UIAlertView(title: "提 示", message: "请先设置ip后再使用本系统", delegate: self , cancelButtonTitle: "确定").show()
        }
        
        
        
        if initCount == 0{
            getCurrentFirst()
            initFirst()
            initCount = 1
        }else{
            initView()
        }
        
        println("home = \(NSHomeDirectory())")
        
        
        
        whiteBgView.layer.cornerRadius = 10

        btnLogin.layer.cornerRadius = 8
        btnLogin.addTarget(self, action: "goLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getCurrent:", name: CurrentDidChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getCurrentInitError", name: ConnectErrorNotification, object: nil)
        
    }
    
    func initFirst(){
        if !current.id.isEmpty{
            whiteBgView.hidden = true
            self.lblMeetingName.text = current.name
            self.btnLogin.enabled = true
            self.btnLogin.backgroundColor = SPDBRedColor
        }else{
            self.lblMeetingName.text = "暂  无  会  议"
            self.btnLogin.enabled = false
            self.btnLogin.backgroundColor = SPDBGrayColor
            whiteBgView.hidden = false
        }
    }
    
    func getCurrentFirst(){
        var url = NSURL(string: server.currentUrl)
        
        Alamofire.request(.GET, server.currentUrl).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (request , response , data , error ) -> Void in
            if error != nil || data == nil {
                println("get first data = \(error)")
                NSNotificationCenter.defaultCenter().postNotificationName(ConnectErrorNotification, object: nil)
                return
            }else{
                if let dataResult = data{
                    if let result = GBCurrent(keyValues: dataResult){
                        
                        current = result
                        
                        if current.id.isEmpty == false{
                            isDownloading = true
                            
                            DownloadManager().downloadJSON()
                            DownloadManager().downloadFile()
                        }else{
                            UIAlertView(title: "提 示", message: "当前暂无会议", delegate: self , cancelButtonTitle: "确定").show()
                        }
                        self.initView()
                    }
                }else{
                    
                }
            }
        }
    }

    
    
    func getCurrentInitError(){
        whiteBgView.hidden = true
        var alert = UIAlertView(title: "提 示", message: "无法连接到服务器，请检查网络设置后重试", delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }

    
    func initView(){
        if !current.id.isEmpty{
            whiteBgView.hidden = true
            self.lblMeetingName.text = current.name
            self.btnLogin.enabled = true
            self.btnLogin.backgroundColor = SPDBRedColor
        }else{
            self.lblMeetingName.text = "暂  无  会  议"
            self.btnLogin.enabled = false
            self.btnLogin.backgroundColor = SPDBGrayColor
            whiteBgView.hidden = true
        }
    }
    
    
    func getCurrent(notification: NSNotification){
        initView()
    }
    
    
    func goLogin(sender: UIButton){
        self.btnLogin.enabled = false
        self.btnLogin.backgroundColor = SPDBGrayColor
        
        var sourceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sourceView") as! SourceViewController
        self.presentViewController(sourceVC, animated: true, completion: nil)
    }

    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

