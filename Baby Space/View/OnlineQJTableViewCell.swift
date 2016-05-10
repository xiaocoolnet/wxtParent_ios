//
//  OnlineQJTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class OnlineQJTableViewCell: UITableViewCell {
//    请假内容
    @IBOutlet weak var contentLbl: UILabel!
//    请假者
    @IBOutlet weak var motherNameLbl: UILabel!
//    老师名字
    @IBOutlet weak var teacherNameLbl: UILabel!
//    请假时间
    @IBOutlet weak var timeLbl: UILabel!
//    请假状态
    @IBOutlet weak var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
