//
//  NoticeTableViewCell.swift
//  WXT_Parents
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All righ
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

//  标题
    @IBOutlet weak var titleLbl: UILabel!
//    内容
    @IBOutlet weak var contentLbl: UILabel!
//    图片
    @IBOutlet weak var bigImageView: UIImageView!
//    发送者
    @IBOutlet weak var senderLbl: UILabel!
//    已读人数
    @IBOutlet weak var readLbl: UILabel!
//    未读人数
    @IBOutlet weak var unreadLbl: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
