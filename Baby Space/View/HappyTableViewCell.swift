//
//  HappyTableViewCell.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HappyTableViewCell: UITableViewCell {

    
    @IBOutlet var Time: UILabel!
    @IBOutlet var Name: UILabel!
    @IBOutlet var Content: UILabel!
    @IBOutlet var Title: UILabel!
    @IBOutlet var images: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
