//
//  BlogCellTableViewCell.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class BlogCellTableViewCell: UITableViewCell {

    

    
    @IBOutlet weak var blogAvator: UIImageView!
    
    @IBOutlet weak var blogName: UILabel!
    
    @IBOutlet weak var blogTime: UILabel!
    
    @IBOutlet weak var dianZanPeople: UILabel!
    
    @IBOutlet weak var dianZanBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }
    
    @IBAction func DianZan(sender: AnyObject) {
        dianZanBtn.selected = !dianZanBtn.selected
        if(!dianZanBtn.selected){
            
            dianZanBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
            
        }
        else{
            
            dianZanBtn.setImage(UIImage(named: "已点赞"), forState: .Normal)
        }

    }
   
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
