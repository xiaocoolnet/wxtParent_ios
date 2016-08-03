//
//  ClassActivitiesTableViewCell.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ClassActivitiesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var senderLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
//    报名人数
    @IBOutlet weak var signUpLbl: UILabel!
    
    @IBOutlet weak var dianZanBtn: UIButton!
    
//    @IBOutlet weak var pingLunBtn: UIButton!
    
//    @IBOutlet weak var zanListLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        dianZanBtn.setBackgroundImage(UIImage(named: "点赞"), forState: .Normal)
//        pingLunBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
