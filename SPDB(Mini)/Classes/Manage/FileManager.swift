//
//  FileManager.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/26.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit

/**
判断获取到的json数据是否和本地存储的json数据一致，是返回true；否则返回false
*/
func isSameJsonFileExist(jsondata: NSData, filePath: String) -> Bool {
    var manager = getGBDefaultManager()
    if manager.fileExistsAtPath(filePath){
        if let contents = manager.contentsAtPath(filePath){
            if jsondata == contents{
//                println("json is already exist")
                return true
            }
        }
    }
    return false
}

/**
判断获取到id的文件是否存在，是返回true；否则返回false
*/
func isSameFileExist(id: String) -> Bool {
    var filepath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(id).pdf")
    var manager = getGBDefaultManager()
    if manager.fileExistsAtPath(filepath){
        return true
    }else{
        return false
    }
}




/**
将data写入制定文件路径下，成功返回true，否则返回false

:param: writeData 要写入的数据
:param: filePath  要写入数据的路径

*/
func dataWriteToFile(writeData: NSData, filePath: String) -> Bool{
    var success = writeData.writeToFile(filePath, options: NSDataWritingOptions.allZeros, error: nil)
    if success == true{
        println("save json data success===success = \(success)")
    }else{
        println("save json data fail fail===fail = \(success)")
    }
    return success
}