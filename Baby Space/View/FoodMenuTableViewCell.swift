//
//  FoodMenuTableViewCell.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/23.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class FoodMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var images: UIImageView!
    @IBOutlet var Introduce: UITextField!
    @IBOutlet weak var lab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //jiayou
        // Configure the view for the selected state
    }

}
