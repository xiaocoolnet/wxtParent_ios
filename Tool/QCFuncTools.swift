//
//  QCFuncTools.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/30.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
import MBProgressHUD
//  动态计算高度
func calculateHeight(string:String,size:CGFloat,width:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)
    return boundingRect.height
}

//  请求成功的加载效果
func successHUD(view:UIView,successData:String){
    let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
    hud.labelText = successData
    hud.removeFromSuperViewOnHide = true
    hud.hide(true, afterDelay: 1)
}
//  请求失败的加载效果
func messageHUD(view:UIView,messageData:String){
    let progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
    progressHUD.mode = MBProgressHUDMode.Text;
    progressHUD.labelText = messageData
    progressHUD.margin = 10.0
    progressHUD.removeFromSuperViewOnHide = true
    progressHUD.hide(true, afterDelay: 1)
}

//  提示框
func alert(message:String,delegate:AnyObject){
    let alert = UIAlertView(title: "提示信息", message: message, delegate: delegate, cancelButtonTitle: "确定")
    alert.show()
}