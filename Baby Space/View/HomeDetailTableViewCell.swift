//
//  HomeDetailTableViewCell.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HomeDetailTableViewCell: UITableViewCell {
    
    let name = UILabel()
    let photoBtn = UIImageView()
    let titleLab = UILabel()
    let subjectLab = UILabel()
    let contentLab = UILabel()
    let create_time = UILabel()
    
    let picBtn = UIButton()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        photoBtn.frame = CGRectMake(15, 10, 40, 40)
        photoBtn.layer.cornerRadius = 20
        photoBtn.clipsToBounds = true
        photoBtn.userInteractionEnabled = false
        contentView.addSubview(photoBtn)
        
        name.frame = CGRectMake(65, 10, 120, 20)
        contentView.addSubview(name)
        
        let clas = UILabel()
        clas.frame = CGRectMake(65, 40, 40, 20)
        clas.text = "班级"
        clas.textColor = UIColor.lightGrayColor()
        contentView.addSubview(clas)
        
        create_time.frame = CGRectMake(190, 10, WIDTH - 190 - 10, 20)
        create_time.textColor = UIColor.lightGrayColor()
        create_time.textAlignment = NSTextAlignment.Right
        create_time.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(create_time)
        
        let line = UILabel()
        line.frame = CGRectMake(10, 69.5, WIDTH - 20, 0.5)
        line.backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(line)
        
        titleLab.frame = CGRectMake(0, 80, WIDTH, 30)
        titleLab.textAlignment = NSTextAlignment.Center
        titleLab.font = UIFont.systemFontOfSize(19)
        contentView.addSubview(titleLab)
        
        subjectLab.frame = CGRectMake(30, 120, 40, 20)
        subjectLab.textColor = UIColor.lightGrayColor()
        subjectLab.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(subjectLab)
        
        contentLab.frame = CGRectMake(75, 120, WIDTH - 85, 20)
        contentLab.textColor = UIColor.lightGrayColor()
        contentLab.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(contentLab)
        
        contentView.addSubview(picBtn)
        
        
        
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
