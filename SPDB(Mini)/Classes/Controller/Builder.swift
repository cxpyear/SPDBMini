//
//  Builder.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/23.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit
import Alamofire

class Builder: NSObject {
    override init() {
        super.init()
        
//        getCurrentFirst()
        
        Poller().start(self, method: "getCurrentPerTime:", timerInter: 10.0)
    }
    
    
    func isAllFileDownloaded() -> Bool{
        var count = current.sources.count
        var manager = NSFileManager.defaultManager()
        
        for var i = 0 ; i < count; i++ {
            if let source = GBSource(keyValues: current.sources[i]){
                var id  = source.id
                var path = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(id).pdf")
                
                if !manager.fileExistsAtPath(path){
                    return false
                }
            }
        }
        return true
    }
    
    
    
    /**
    获取current数据
    */
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
                        NSNotificationCenter.defaultCenter().postNotificationName(CurrentDidChangedNotification, object: nil, userInfo: [CurrentDidChangedName: current])
                        
                        if current.id.isEmpty == false{
                            isDownloading = true
                            
                            DownloadManager().downloadJSON()
                            DownloadManager().downloadFile()
                        }else{
                            
                        }
                    }
                }else{
                    
                }

            }
        }
    }
    
    
    
    func getCurrentPerTime(timer: NSTimer){
        
//        println("doenloalist.count = \(downloadlist.count)")
        
        Alamofire.request(.GET, server.currentUrl).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (request , response , data , error ) -> Void in
            if error != nil{
                println("get current error = \(error)")
                return
            }else{
                
                //判断当前会议是否和本地保存的会议信息一致。一致则返回。
                if let dataResult: AnyObject = data{
                    if let dataValue = NSJSONSerialization.dataWithJSONObject(dataResult, options: NSJSONWritingOptions.allZeros, error: nil){
                        var isSameData = isSameJsonFileExist(dataValue, jsonFilePath)
                        if isSameData == true{
                            
                            if self.isAllFileDownloaded() == true{
                                return
                            }else{
                                println("isDownloading =============== \(isDownloading)")
                                if isDownloading == false{
                                    isDownloading = true
                                    DownloadManager().downloadFile()
                                }
                            }
                        }
                            
                        //当前会议和本地保存的会议信息不一致
                        else{
                            if let result = GBCurrent(keyValues: dataResult){
                                current = result
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(CurrentDidChangedNotification, object: nil, userInfo: [CurrentDidChangedName: current])
                                
                                println("post current change notification")
                                
                                //如果当前会议不为空
                                //1.通知其他界面回到主界面刷新
                                //2.下载所有的json数据和文件数据
                                if current.id.isEmpty == false{
                                    
//                                    downloadlist.removeAll(keepCapacity: false)
                                    
                                    
                                    DownloadManager().downloadFile()
                                    DownloadManager().downloadJSON()
                                   
                                }
                                
                                //如果当前会议为空
                                //1.通知其他界面回到主界面刷新
                                //2.下载所有的json数据和文件数据
                                else{
                                    
//                                    if (alaRequest != nil) {
//                                        alaRequest!.cancel()
//                                    }
      
                                    downloadlist.removeAll(keepCapacity: false)
                                    DeleteManager().deleteAllFiles()
                                }
                                
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }
    

    
    
    
//    func getCurrentInfo(){
//        
//    }
}
