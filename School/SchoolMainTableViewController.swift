//
//  SchoolMainTableViewController.swift
//  WXT_Parents
//
//  Created by xiaocool on 16/1/28.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import ImageSlideshow
class SchoolMainTableViewController: UITableViewController {

    @IBOutlet weak var schoolImageScroll: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScrollViewImage()
        
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }

    // MARK: - Table view data source

 
    func ScrollViewImage(){
        schoolImageScroll.slideshowInterval = 5.0
        schoolImageScroll.setImageInputs([AFURLSource(urlString: "http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg")!, AFURLSource(urlString: "http://ppt360.com/background/UploadFiles_6733/201012/2010122016291897.jpg")!, AFURLSource(urlString: "http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg")!])
    }



    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return 0.01
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }

}
