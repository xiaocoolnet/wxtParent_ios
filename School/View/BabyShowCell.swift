//
//  BabyShowCell.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class BabyShowCell: UITableViewCell {
    var headImageView = UIImageView()
    
    var nameLbl = UILabel()
    
    var introduceLbl =  UILabel()
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.awakeFromNib()
        //  初始化UI
        self.nameLbl.frame = CGRectMake(80, 10, 200, 30)
        self.contentView.addSubview(nameLbl)
        
        self.introduceLbl.frame = CGRectMake(80, 45, 300, 20)
        self.contentView.addSubview(introduceLbl)
        
        self.headImageView.frame = CGRectMake(5, 5, 75, 75)
        self.contentView.addSubview(headImageView)
        

    }

}
