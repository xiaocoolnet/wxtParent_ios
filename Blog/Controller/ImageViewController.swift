//
//  ImageViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var bigPicture: UIImageView!
    var imUrl:String!
    var tupian:UIImage!
    
    override func viewDidLoad() {
        self.title = "图片详情"
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        bigPicture.image = tupian
        print(imUrl)
        
//        let avatarUrl = NSURL(string: imUrl)
//        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
//                if(data != nil){
//                    let imgTmp = UIImage(data: data!)
//                    
//                    self.bigPicture!.image = imgTmp
//                    
//                    //self.view.addSubview(self.bigPicture!)
//                    
//                }
//            })
//        
    }

}
