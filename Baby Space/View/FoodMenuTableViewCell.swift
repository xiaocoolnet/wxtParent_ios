//
//  FoodMenuTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class FoodMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLbl: UILabel!//第一餐
    
    @IBOutlet weak var secondLbl: UILabel!//第二餐
    
    @IBOutlet weak var thirdLbl: UILabel!//第三餐
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
