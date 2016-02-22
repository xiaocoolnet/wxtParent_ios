//
//  ClassCellTableViewCell.swift
//  WXT_Parents
//
//  Created by Mac on 16/2/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ClassCellTableViewCell: UITableViewCell {

    @IBOutlet weak var diaryImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
