//
//  TeacherCommentsTableViewCell.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TeacherCommentsTableViewCell: UITableViewCell {
    @IBOutlet var TeacherName: UILabel!
    @IBOutlet var CommentsLabel: UILabel!
    @IBOutlet var TimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
