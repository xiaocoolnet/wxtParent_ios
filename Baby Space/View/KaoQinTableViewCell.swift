//
//  KaoQinTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class KaoQinTableViewCell: UITableViewCell {

    
//    小点
    @IBOutlet weak var stateView: UIView!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    线
    @IBOutlet weak var stateImageView: UIImageView!
//    已签
    @IBOutlet weak var stateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
