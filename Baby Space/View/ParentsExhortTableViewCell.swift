//
//  ParentsExhortTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/4/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ParentsExhortTableViewCell: UITableViewCell {

//    姓名
    @IBOutlet weak var nameLbl: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    内容
    @IBOutlet weak var contentLbl: UILabel!
//    老师姓名
    @IBOutlet weak var teacherNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
