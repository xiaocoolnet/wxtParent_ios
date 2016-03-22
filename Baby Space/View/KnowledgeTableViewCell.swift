//
//  KnowledgeTableViewCell.swift
//  WXT_Parents
//
//  Created by Mac on 16/3/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class KnowledgeTableViewCell: UITableViewCell {
    @IBOutlet var KnowTime: UILabel!
    @IBOutlet var KnowName: UILabel!
    @IBOutlet var KnowContent: UILabel!
    @IBOutlet var KnowTitle: UILabel!
    @IBOutlet var KnowImages: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
