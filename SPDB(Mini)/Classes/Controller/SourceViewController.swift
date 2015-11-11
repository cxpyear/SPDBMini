//
//  SourceViewController.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/26.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sourceTv: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var swipeGetsure: UISwipeGestureRecognizer!
    
    var imageUnDownloaded = UIImage(named: "Download-50")
    var imageDownloaded = UIImage(named: "Arrow-50")
    
    var sourceList = NSArray()
    
    var cellIdentify = "sourceCell"
    
    var backAlert = UIAlertView()
    var alertClickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceList = current.sources
        
        self.sourceTv.rowHeight = 75
        self.sourceTv.tableFooterView = UIView(frame: CGRectZero)
        self.sourceTv.registerNib(UINib(nibName: "SourceTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentify)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getCurrent:", name: CurrentDidChangedNotification, object: nil)
        
        Poller().start(self, method: "reloadTv", timerInter: 2.0)
        
        
        swipeGetsure.addTarget(self, action: "swipeAction")
        self.sourceTv.addGestureRecognizer(swipeGetsure)

    }
    
    func swipeAction(){
        self.btnBack.hidden = !self.btnBack.hidden
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.btnBack.hidden = true
    }
    
    func reloadTv(){
        self.sourceTv.reloadData()
    }
    
    func getCurrent(notification: NSNotification){
        if alertClickCount == 0{
            backAlert = UIAlertView(title: "提 示", message: "当前会议信息改变,将回到主界面重新开始", delegate: self, cancelButtonTitle: "确 定")
            backAlert.show()
            alertClickCount = 1
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == self.backAlert{
            alertClickCount = 0
            var mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainView") as! MainViewController
            self.presentViewController(mainVC, animated: true, completion: nil)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return sourceList.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify, forIndexPath: indexPath) as! SourceTableViewCell
        
        var sourceRowValue = GBSource(keyValues: sourceList[indexPath.row])
        cell.lblSourceName.text = sourceRowValue.name.stringByDeletingPathExtension
        var fileid = sourceRowValue.id
        
        if isSameFileExist(fileid) == true{
            cell.progressBar.hidden = true
            cell.lblProgressValue.hidden = true
            cell.imgFile.image = imageDownloaded
        }else {
            for var i = 0 ; i < downloadlist.count ; i++ {
                if fileid == downloadlist[i].fileid{
                    
                    if isSameFileExist(fileid) == false{
                        
                        var downloadCurrent = downloadlist[i]
//                        println("filebar = \(downloadlist[i].filebar)")
                        cell.progressBar.hidden = false
                        cell.progressBar.progress = downloadCurrent.filebar
                        cell.imgFile.image = imageUnDownloaded
                        cell.lblProgressValue.hidden = false
                        cell.lblProgressValue.text = "\(Int(downloadCurrent.filebar * 100))%"
                    }else{
                        cell.progressBar.hidden = true
                        cell.lblProgressValue.hidden = true
                        cell.imgFile.image = imageDownloaded
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sourceRowValue = GBSource(keyValues: self.sourceList[indexPath.row])
        var fileid = sourceRowValue.id
        
        if isSameFileExist(fileid){
            var docVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("docView") as! DocViewController
            docVC.fileid = fileid
            self.presentViewController(docVC, animated: true , completion: nil)
        }else{
            UIAlertView(title: "提 示", message: "当前文件尚未下载完成，请稍后再试", delegate: self , cancelButtonTitle: " 确 定").show()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
