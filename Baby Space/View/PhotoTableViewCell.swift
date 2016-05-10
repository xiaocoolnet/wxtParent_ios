//
//  PhotoTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

//    内容
    @IBOutlet weak var contentlbl: UILabel!
//    图片
    @IBOutlet weak var bigImageIVew: UIImageView!
//    发送者
    @IBOutlet weak var senderLbl: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    更多
    @IBOutlet weak var moreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
