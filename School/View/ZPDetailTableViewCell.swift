//
//  ZPDetailTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ZPDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var academicLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var fuLiLbl: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameTwoLbl: UILabel!
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellWithJobInfo(jobInfo:JobInfo){
        self.nameLbl.text = jobInfo.post_title
        self.priceLbl.text = jobInfo.istop
        self.placeLbl.text = jobInfo.post_title
        self.timelbl.text = jobInfo.post_date
        self.academicLbl.text = jobInfo.post_excerpt
        if jobInfo.schoolid == "1" {
            self.typeLbl.text = "全职"
        }else{
            self.typeLbl.text = "兼职"
        }
//        self.fuLiLbl.text = "福利：\(jobInfo.welfare!)"
        self.nameTwoLbl.text = jobInfo.school_name
        self.detailLbl.text = jobInfo.introduce
        self.contentLbl.text = jobInfo.post_content
   
    }
    
}
