//
//  SchoolTeacherTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/3.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class SchoolTeacherTableViewCell: UITableViewCell {
//   头像
    @IBOutlet weak var headImageView: UIImageView!
//    名字
    @IBOutlet weak var nameLbl: UILabel!
//    班级
    @IBOutlet weak var classLbl: UILabel!
//    简介
    @IBOutlet weak var introduceLbl: UILabel!
//    奖项
    @IBOutlet weak var prizeLbl: UILabel!
//    履历
    @IBOutlet weak var experienceLbl: UILabel!
//    联系方式
    @IBOutlet weak var contactLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
