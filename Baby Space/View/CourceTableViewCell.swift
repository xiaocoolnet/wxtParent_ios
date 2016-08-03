//
//  CourceTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/30.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class CourceTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var typeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
