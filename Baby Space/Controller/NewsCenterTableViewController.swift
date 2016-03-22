//
//  NewsCenterTableViewController.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import Alamofire
class NewsCenterTableViewController: UITableViewController {
    
    @IBOutlet var tableSource: UITableView!
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let conversationVC = ConversationListViewController()
            self.navigationController?.pushViewController(conversationVC, animated: true)
        }
    }

}
