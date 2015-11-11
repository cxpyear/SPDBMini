//
//  DeleteManager.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/26.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit

class DeleteManager: NSObject {
   
    /**
    删除nshomedirectory下的所有文件
    */
    func deleteAllFiles(){
        var manager = NSFileManager.defaultManager()
        var filePath = NSHomeDirectory().stringByAppendingPathComponent("Documents")
        
        if let filelist = manager.contentsOfDirectoryAtPath(filePath, error: nil){
            for var i = 0 ; i < filelist.count ; i++ {
                var docpath = filePath.stringByAppendingPathComponent("\(filelist[i])")
                var success = manager.removeItemAtPath(docpath, error: nil)
                if success{
                    println("\(filelist[i])文件删除成功")
                }
            }
        }
        
    }
    
}
