//
//  DaKaTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class DaKaTableViewCell: UITableViewCell {
//    签到时间
    @IBOutlet weak var upTimeLbl: UILabel!
//    签退时间
    @IBOutlet weak var offTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
