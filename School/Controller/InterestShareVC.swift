//
//  InterestShareVC.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class InterestShareVC: UIViewController {
    var id:String!
    var webView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        
        GETData()

        // Do any additional setup after loading the view.
    }
    func createUI(){
        
        //  进行webView的请求
        webView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 40)
        self.view.addSubview(webView)
        
        //  设置分享按钮
        let shareBtn = UIButton()
        shareBtn.frame = CGRectMake(0, HEIGHT - 104, WIDTH, 40)
        shareBtn.backgroundColor = UIColor(red: 155.0 / 255.0, green: 240.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
        shareBtn.titleLabel?.font = UIFont.systemFontOfSize(17)
        shareBtn.setTitle("分 享", forState: .Normal)
        shareBtn.addTarget(self, action: #selector(self.shareWC), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(shareBtn)
    }
    func shareWC(){
        //  进行分享的操作
        print("分享")
        //
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        //
        let url = "http://wxt.xiaocool.net/index.php?g=portal&m=article&a=Interest&id=" + id
        shareParames.SSDKSetupShareParamsByText(url,
                                                images : UIImage(named: "1.png"),
                                                url : NSURL(string:url),
                                                title : "老师风采",
                                                type : SSDKContentType.Auto)
        
        //  判断微信是否安装了
        if WXApi.isWXAppInstalled() {
            
            //微信朋友圈分享
            ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                
                switch state{
                    
                case SSDKResponseState.Success:
                    print("分享成功")
                    
                    let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                    alert.show()
                    
                case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
                case SSDKResponseState.Cancel:  print("分享取消")
                    
                default:
                    break
                }
            }
        }else{
            let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    func GETData(){
        //  需要拼接id
        
        let url = NSURL(string: "http://wxt.xiaocool.net/index.php?g=portal&m=article&a=teacher&id=" + id)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
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