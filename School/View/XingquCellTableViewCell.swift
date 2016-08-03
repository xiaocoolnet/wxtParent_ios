//
//  XingquCellTableViewCell.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class XingquCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var kindLbl: UILabel!
    @IBOutlet weak var statelbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellWithXingQuBanInfo(banInfo:XingQuBanInfo){
        
        //        兴趣班名称
        self.kindLbl.text = banInfo.post_title
        //        加入状态
        if banInfo.status == "success"{
          self.statelbl.text = "已加入"
        }else{
           self.statelbl.text = "未加入"
        }
        //        详情
        self.detailLbl.text = banInfo.description
//        let img = imageUrl + "123"
        let imgUrl = imageUrl + banInfo.thumb!
        let avatarUrl = NSURL(string: imgUrl)
        self.headImageView.yy_setImageWithURL(avatarUrl, placeholder: UIImage(named: "Logo.png"))
    }

}
