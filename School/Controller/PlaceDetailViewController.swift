//
//  PlaceDetailViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var BigImageView: UIImageView!
    
    @IBOutlet weak var detailLbl: UILabel!
    var jobInfo:JobInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = jobInfo?.school_name
        self.detailLbl.text = jobInfo?.introduce
    }

}
