//
//  NewsZoneTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class NewsZoneTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var contentLbl: UILabel!
 
    @IBOutlet weak var readbtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//  进行cell的填充
    func fillCellWithData(newsInfo:NewsInfo){
        let time = (newsInfo.post_date! as NSString).substringWithRange(NSMakeRange(4, 15))
        self.timeLbl.text = time
        self.titleLbl.text = newsInfo.post_title
        self.contentLbl.text = newsInfo.post_excerpt
        let imageURL = imageUrl + newsInfo.thumb!
        self.bigImageView.sd_setImageWithURL(NSURL.fileURLWithPath(imageURL), placeholderImage: UIImage(named: "1"))
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
