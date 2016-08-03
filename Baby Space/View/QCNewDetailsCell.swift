//
//  QCNewDetailsCell.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCNewDetailsCell: UITableViewCell {
    
    var headerImageView = UIImageView()
    var teacherNameLabel = UILabel()
    var teacherTitleLabel = UILabel()
    var timeLabel = UILabel()
    
    var contentTitleLabel = UILabel()
    var contentLabel = UILabel()
    var contentImageView = UIImageView()
    
    var readLabel = UILabel()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        headerImageView.frame = CGRectMake(15, 15, 60, 60)
        headerImageView.image = UIImage.init(named: "1")
        headerImageView.cornerRadius = 30
        contentView.addSubview(headerImageView)
        
        teacherNameLabel.frame = CGRectMake(90, 15, 100, 20)
        teacherNameLabel.text = "老师名称"
        contentView.addSubview(teacherNameLabel)
        
        teacherTitleLabel.frame = CGRectMake(90, 55, 100, 20)
        teacherTitleLabel.text = "园长"
        teacherTitleLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(teacherTitleLabel)
    
        timeLabel.frame = CGRectMake(WIDTH - 150, 15, 150, 20)
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.text = "04-23 12:30"
        contentView.addSubview(timeLabel)
        
        let bgView = UIView()
        bgView.frame = CGRectMake(0, 90, WIDTH, 1)
        bgView.backgroundColor = UIColor.grayColor()
        contentView.addSubview(bgView)
        
        contentTitleLabel.frame = CGRectMake((WIDTH - 200) / 2, 100, 200, 20)
        contentTitleLabel.text = "舞蹈大赛公告"
        contentTitleLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(contentTitleLabel)
        
        contentLabel.frame = CGRectMake(10, 130, WIDTH - 20, 100)
        contentLabel.numberOfLines = 0
        contentLabel.text = "舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛舞蹈大赛"
        contentLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(contentLabel)
        
        contentImageView.frame = CGRectMake(10, 230, WIDTH - 20, 200)
        contentImageView.image = UIImage.init(named: "1")
        contentView.addSubview(contentImageView)
        
        let bgView2 = UIView()
        bgView2.frame = CGRectMake(0, 440, WIDTH, 1)
        bgView2.backgroundColor = UIColor.grayColor()
        contentView.addSubview(bgView2)
        
        readLabel.frame = CGRectMake(10, 450, WIDTH - 20, 20)
        readLabel.textColor = UIColor.orangeColor()
        readLabel.text = "总发45 已阅读13 未读10"
        contentView.addSubview(readLabel)
        
        
        
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
