//
//  SendNewsTableViewCell.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class SendNewsTableViewCell: UITableViewCell {
  
    @IBOutlet var SendTime: UILabel!
    @IBOutlet var SendName: UILabel!
    @IBOutlet var SendContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
}
}
