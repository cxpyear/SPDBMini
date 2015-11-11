//
//  DocViewController.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/26.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit

class DocViewController: UIViewController, UIWebViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var txtShowTotalPage: UITextField!
    @IBOutlet weak var txtShowCurrentPage: UITextField!
    @IBOutlet weak var docView: UIWebView!
    
    var totalPage = Int()
    var currentPage = Int()
    
    var fileid = String()
    
    var fileExistAlert = UIAlertView()
    var backAlert = UIAlertView()
    var alertClickCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topView.hidden = true
        self.docView.scrollView.delegate = self
        
        loadPDFFile()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getCurrent:", name: CurrentDidChangedNotification, object: nil)
        
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
            var mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainView") as! MainViewController
            self.presentViewController(mainVC, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtShowCurrentPage{
            self.txtShowCurrentPage.endEditing(true)
        }
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        if textField == self.txtShowCurrentPage{
            if textField.text.isEmpty{
                return
            }else if let value = self.txtShowCurrentPage.text{
                if let page = value.toInt(){
                    if page <= 0{
                        return
                    }
                    skipToPage(page)
                    currentPage = page
                }
            }
        }
    }
    
    
    
    func loadPDFFile(){
        var filePath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(fileid).pdf")
        
        var b = isSameFileExist(fileid)
        if b == true{
            self.docView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: filePath)!))
            
            var path: CFString = CFStringCreateWithCString(nil, filePath, CFStringEncoding(CFStringBuiltInEncodings.UTF8.rawValue))
            var url: CFURLRef = CFURLCreateWithFileSystemPath(nil , path, CFURLPathStyle.CFURLPOSIXPathStyle, 0)
            
            if let document = CGPDFDocumentCreateWithURL(url){
                var totalPages = CGPDFDocumentGetNumberOfPages(document)
                self.totalPage = totalPages
            }

        }else{
            self.docView.hidden = true
            self.topView.hidden = true
            fileExistAlert = UIAlertView(title: "提示", message: "当前服务器中不存在该文件", delegate: self, cancelButtonTitle: "确定")
            fileExistAlert.show()
            self.totalPage = 0

        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        self.topView.hidden = false
        self.txtShowTotalPage.text = "共\(totalPage)页"
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pdfHeight = scrollView.contentSize.height
        var onePageHeight = pdfHeight / CGFloat(totalPage)
        
        var page = (scrollView.contentOffset.y) / onePageHeight
        var p = Int(page + 0.5)
        self.txtShowCurrentPage.text = "\(p + 1)"
    }
    
    /**
    跳转到pdf指定的页码
    
    :param: num 指定的pdf跳转页码位置
    */
    func skipToPage(num: Int){
        var totalPDFheight = docView.scrollView.contentSize.height
        var pageHeight = CGFloat(totalPDFheight / CGFloat(totalPage))
        
        var specificPageNo = num
        if specificPageNo <= totalPage{
            
            var value2 = CGFloat(pageHeight * CGFloat(specificPageNo - 1))
            var offsetPage = CGPointMake(0, value2)
            docView.scrollView.setContentOffset(offsetPage, animated: true)
        }
    }
    
    
    @IBAction func btnToFirst(sender: UIButton) {
        skipToPage(1)
        currentPage = 1
        self.txtShowCurrentPage.text = String(currentPage)
    }

    @IBAction func btnToPrevious(sender: UIButton) {
        if currentPage > 1 {
            --currentPage
            skipToPage(currentPage)
            
            self.txtShowCurrentPage.text = String(currentPage)
        }
    }
   
    @IBAction func btnToAfter(sender: UIButton) {
        if currentPage < totalPage  {
            ++currentPage
            skipToPage(currentPage)
            self.txtShowCurrentPage.text = String(currentPage)
        }
    }
    
    
    @IBAction func btnToLast(sender: UIButton) {
        
        skipToPage(totalPage)
        currentPage = totalPage
        self.txtShowCurrentPage.text = String(currentPage)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
