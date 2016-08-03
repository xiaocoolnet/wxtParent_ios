//
//  ZhaoPinTableViewCell.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ZhaoPinTableViewCell: UITableViewCell {

    @IBOutlet weak var headImagView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var detailLbl: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellWithJobInfo(jobInfo:JobInfo){
        
//        职位名称
        self.nameLbl.text = jobInfo.post_title
//        发布时间
        let dateformate = NSDateFormatter()
        dateformate.dateFormat = "MM-dd"
        //  这是什么  （崩溃）
//        let date = NSDate(timeIntervalSince1970: NSTimeInterval(jobInfo.create_time!)!)
//        let str:String = dateformate.stringFromDate(date)
//        self.timeLbl.text = str
//        薪资
        self.priceLbl.text = jobInfo.post_excerpt
//        详情
        self.detailLbl.text = jobInfo.post_content
       
        
//        let imgUrl = imageUrl + jobInfo.avatar!
//        let avatarUrl = NSURL(string: imgUrl)
//        self.headImageView.yy_setImageWithURL(avatarUrl, placeholder: UIImage(named: "Logo.png"))
    }

}
