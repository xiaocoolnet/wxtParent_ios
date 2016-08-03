//
//  YNCommentTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class YNCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellWithNCommentInfo(nCommentInfo:NCommentInfo){
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd HH:mm"
        
        self.nameLbl.text = nCommentInfo.name
        self.contentLbl.text = nCommentInfo.content
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(nCommentInfo.comment_time!)!)
        let str:String = dateformate.stringFromDate(date)
        self.timeLbl.text = str
        let imgUrl = microblogImageUrl + nCommentInfo.photo!
        let photourl = NSURL(string: imgUrl)
        self.photoImageView.yy_setImageWithURL(photourl, placeholder: UIImage(named: "卡通.png"))
        
        let imgUrl1 = imageUrl + nCommentInfo.avatar!
        let avatarUrl = NSURL(string: imgUrl1)
        self.headImageView.yy_setImageWithURL(avatarUrl, placeholder: UIImage(named: "Logo.png"))
    }
    
}
