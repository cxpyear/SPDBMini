//
//  DownloadManager.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/23.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit
import Alamofire

class DownloadFile: NSObject {
    var filebar: Float = 0
    var fileid: String = ""
    var fileResumeData: NSData = NSData()
    var isdownloading = Bool()
}


var downloadlist:[DownloadFile] = []

var isDownloading = Bool()


var alaRequest: Alamofire.Request?

class DownloadManager: NSObject {
   
    func downloadJSON(){

        Alamofire.request(.GET, server.currentUrl).responseJSON(options: NSJSONReadingOptions.MutableContainers, completionHandler: { (request , response , data , error ) -> Void in
            if error != nil{
                println("get json error = \(error)")
                return
            }else{
//                println("json data = \(jsonFilePath)")
                
                if let dataValue: AnyObject = data{
                    if let writeData = NSJSONSerialization.dataWithJSONObject(dataValue, options: NSJSONWritingOptions.allZeros, error: nil){
                        var isSameJsonData = isSameJsonFileExist(writeData, jsonFilePath)
                        if isSameJsonData == true{
                            return
                        }else{
                            var manager = NSFileManager.defaultManager()
                            if !manager.fileExistsAtPath(jsonFilePath){
                                manager.createFileAtPath(jsonFilePath, contents: nil , attributes: nil )
                            }
                            dataWriteToFile(writeData, jsonFilePath)
                        }
                    }
                }
            }
        })
    }
    
    
    func downloadFile(){
        var sources = current.sources
        var meetingid = current.id
       
           
        for var i = 0 ; i < sources.count ; i++ {
            var source = GBSource(keyValues: sources[i])
            var fileid = source.id
            var filename = source.name
            
            var downloadCurrentFile = DownloadFile()
            downloadCurrentFile.fileid = fileid
            
            var isfind:Bool = false
            
            if downloadlist.count==0{
                downloadlist.append(downloadCurrentFile)
            }
            else {
                for var i = 0; i < downloadlist.count ; ++i {
                    if fileid == downloadlist[i].fileid {
                        isfind = true
                        downloadCurrentFile = downloadlist[i]
                        break
                    }
                }
                if !isfind {
                    downloadCurrentFile.filebar = 0
                    downloadlist.append(downloadCurrentFile)
                }
            }
            
            //判断当前沙盒中是否存在对应的pdf文件，若存在，则直接返回，否则下载该文件。
            var b = isSameFileExist(fileid)
            if b == true{
                println("\(filename)已存在")
                downloadCurrentFile.filebar = 1
                continue
            }
            
            var filepath = server.downloadUrl + "gbtouch/meetings/\(meetingid)/\(fileid).pdf"
            var getPDFURL = NSURL(string: filepath)
            let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)

            
            var res: Alamofire.Request?
            
            if downloadlist[i].fileResumeData.length > 0 && downloadlist[i].isdownloading == false{
                res = Alamofire.download(resumeData: downloadlist[i].fileResumeData, destination)
                println("resuming=======================")
            }else{
                res = Alamofire.download(.GET, getPDFURL!, destination)
                println("downloading=======================")
            }
            
            res!.progress(closure: { (_ , totalBytesRead, totalBytesExpectedToRead) -> Void in
                var processbar: Float = Float(totalBytesRead)/Float(totalBytesExpectedToRead)

                for var i = 0 ; i < downloadlist.count ; i++ {
                    if downloadlist[i].fileid == downloadCurrentFile.fileid{
                        if processbar > downloadCurrentFile.filebar{

                            downloadCurrentFile.filebar = processbar
                            downloadCurrentFile.isdownloading = true
//                            println("i = \(i) bar = \(processbar)")

                            if processbar == 1{
                                println("\(filename)下载完成")
                            }
                        }
                    }
                }

            }).response({ (_ , _ , _ , error ) -> Void in
                
                for var i = 0 ; i < downloadlist.count ; i++ {
                    if downloadlist[i].fileid == downloadCurrentFile.fileid{
                        
                        if error != nil{
                            if let errInfo = error!.userInfo{
                                if let resumeInfo: AnyObject = errInfo[NSURLSessionDownloadTaskResumeData]{
                                    if let resumeD = resumeInfo as? NSData{
                                        downloadCurrentFile.fileResumeData = resumeD
                                        downloadCurrentFile.isdownloading = false
                                    }
                                }
                            }
                            
                            isDownloading = false
                        }else{
                            isDownloading = true
                        }
                    }
                }
            })
        }
    }

}
