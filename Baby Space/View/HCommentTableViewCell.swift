//
//  HCommentTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HCommentTableViewCell: UITableViewCell {

//    头像
    @IBOutlet weak var headImageview: UIImageView!
//    姓名
    @IBOutlet weak var nameLbl: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    内容
    @IBOutlet weak var contentLbl: UILabel!
//    图片
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellWithHCommentInfo(hCommentInfo:HCommentInfo){
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        
        self.nameLbl.text = hCommentInfo.name
        self.contentLbl.text = hCommentInfo.content
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(hCommentInfo.comment_time!)!)
        let str:String = dateformate.stringFromDate(date)
        self.timeLbl.text = str
        let imgUrl = microblogImageUrl + hCommentInfo.photo!
        let photourl = NSURL(string: imgUrl)
        self.photoImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "卡通.png"))
        
        let imgUrl1 = imageUrl + hCommentInfo.avatar!
        let avatarUrl = NSURL(string: imgUrl1)
        self.headImageview.yy_setImageWithURL(avatarUrl, placeholder: UIImage(named: "Logo.png"))
    }
    
}
