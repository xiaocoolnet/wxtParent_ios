//
//  BabyFriendsTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/27.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class BabyFriendsTableViewCell: UITableViewCell {

//    头像
    @IBOutlet weak var headImageView: UIImageView!
//    姓名
    @IBOutlet weak var nameLbl: UILabel!
//    打电话按钮
//    @IBOutlet weak var callBtn: UIButton!
//    发信息按钮
//    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.messageBtn.setBackgroundImage(UIImage(named: "评论"), forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func fillCellWithModel(model:BabyFirendInfo){
        
            self.nameLbl.text = model.name
            let imgUrl = imageUrl + model.photo!
            let photourl = NSURL(string: imgUrl)
            self.headImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "Logo.png"))

    }


}
