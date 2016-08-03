//
//  TakeTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TakeTableViewCell: UITableViewCell {
//    老师头像
    @IBOutlet weak var headImageView: UIImageView!
//    老师姓名
    @IBOutlet weak var nameLbl: UILabel!

//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    照片
    @IBOutlet weak var bigImageView: UIImageView!
//    同意按钮
    @IBOutlet weak var agreeBtn: UIButton!

//  某某家长
    @IBOutlet weak var somebodyLabel: UILabel!
    
//  哪个班级
    @IBOutlet weak var banjiLable: UILabel!
    //    不同意按钮
    @IBOutlet weak var disagreeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
