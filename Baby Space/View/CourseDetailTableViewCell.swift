//
//  CourseDetailTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class CourseDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
//    @IBOutlet weak var dianzanBtn: UIButton!
//    @IBOutlet weak var pinglunBtn: UIButton!
//    @IBOutlet weak var zanListLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
//        pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
