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
    @IBOutlet weak var readLable: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    阅读量
    @IBOutlet weak var readBtn: UIButton!
////    点赞
//    @IBOutlet weak var dianzanBtn: UIButton!
////    评论
//    @IBOutlet weak var pinglunBtn: UIButton!
////    点赞列表
//    @IBOutlet weak var zanListLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        dianzanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
//        pinglunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
