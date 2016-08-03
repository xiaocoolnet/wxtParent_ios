//
//  BabyTeachersTableViewCell.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class BabyTeachersTableViewCell: UITableViewCell {
 
//头像
    @IBOutlet weak var headImageView: UIImageView!
//    姓名
    @IBOutlet weak var teacherNameLbl: UILabel!
//    发信息
    @IBOutlet weak var messgaeBtn: UIButton!
//    打电话
    @IBOutlet weak var callBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messgaeBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
