//
//  ClassScheduleTableViewCell.swift
//  WXT_Parents
//
//  Created by 牛尧 on 16/2/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class ClassScheduleTableViewCell: UITableViewCell {

    let oneLable = UILabel()
    let twoLable = UILabel()
    let threeLable = UILabel()
    let fourLable = UILabel()
    let fiveLable = UILabel()
    let sixLable = UILabel()
    let sevenLable = UILabel()
    let eightLable = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        oneLable.frame = CGRectMake(10, 10, WIDTH - 20, 30)
        contentView.addSubview(oneLable)
        twoLable.frame = CGRectMake(10, 40, WIDTH - 20, 30)
        contentView.addSubview(twoLable)
        threeLable.frame = CGRectMake(10, 70, WIDTH - 20, 30)
        contentView.addSubview(threeLable)
        fourLable.frame = CGRectMake(10, 100, WIDTH - 20, 30)
        contentView.addSubview(fourLable)
        fiveLable.frame = CGRectMake(10, 130, WIDTH - 20, 30)
        contentView.addSubview(fiveLable)
        sixLable.frame = CGRectMake(10, 160, WIDTH - 20, 30)
        contentView.addSubview(sixLable)
        sevenLable.frame = CGRectMake(10, 190, WIDTH - 20, 30)
        contentView.addSubview(sevenLable)
        eightLable.frame = CGRectMake(10, 220, WIDTH - 20, 30)
        contentView.addSubview(eightLable)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
