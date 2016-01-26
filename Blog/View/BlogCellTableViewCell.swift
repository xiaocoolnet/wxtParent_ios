//
//  BlogCellTableViewCell.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class BlogCellTableViewCell: UITableViewCell {

    

    
    @IBOutlet weak var blogAvator: UIImageView!
    @IBOutlet weak var blogDicText: UILabel!
    
    @IBOutlet weak var blogName: UILabel!
    
    @IBOutlet weak var blogTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
