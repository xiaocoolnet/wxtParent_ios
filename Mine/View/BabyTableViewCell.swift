//
//  BabyTableViewCell.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class BabyTableViewCell: UITableViewCell {

    @IBOutlet weak var babyAvator: UIImageView!
    
    @IBOutlet weak var babyName: UILabel!
    @IBOutlet weak var babyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
