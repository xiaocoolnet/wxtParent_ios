//
//  ReadTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ReadTableViewCell: UITableViewCell {
//    头像
    @IBOutlet weak var headImageView: UIImageView!
//    姓名
    @IBOutlet weak var nameLbl: UILabel!
//    关系
    @IBOutlet weak var relationLbl: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
