//
//  SchoolNoticeCell.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class SchoolNoticeCell: UITableViewCell {
    //  定义控件
    var headerImageView = UIImageView()
    var titleLabel = UILabel()
    var timeLable = UILabel()
    var contentLabel = UILabel()
    //  init进行初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //  添加控件
        self.contentView.backgroundColor = RGBA(239, g: 239, b: 244, a: 1)
        
        let view = UIView()
        view.frame = CGRectMake(10, 10, WIDTH - 20, 106)
        view.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(view)
        
        headerImageView.frame = CGRectMake(8, 10, 120, 90)
        view.addSubview(headerImageView)
        
        titleLabel.frame = CGRectMake(136, 10, 150, 30)
        view.addSubview(titleLabel)
        
        timeLable.frame = CGRectMake(290, 10, WIDTH - 310, 30)
        timeLable.textAlignment = NSTextAlignment.Right
        timeLable.font = UIFont.systemFontOfSize(14)
        timeLable.textColor = UIColor.lightGrayColor()
        view.addSubview(timeLable)
        
        contentLabel.frame = CGRectMake(136, 40, WIDTH - 154, 60)
        contentLabel.font = UIFont.systemFontOfSize(14)
        contentLabel.numberOfLines = 0
//        contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentLabel.textColor = UIColor.lightGrayColor()
        view.addSubview(contentLabel)
    }
    //  init方法的监测
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    //  cell的填充方法
    func fillCellWithModel(model:YuanHomeInfo){
        titleLabel.text = model.post_title
        
        timeLable.text = model.post_date
        
        contentLabel.numberOfLines = 0
        
        contentLabel.text = model.post_excerpt
        let imageURL = microblogImageUrl + model.thumb!
        headerImageView.sd_setImageWithURL(NSURL.init(string: imageURL), placeholderImage: UIImage(named: "1.png"))
        
        
        
    }
    //  MARK: - 认证cell
    class func SchoolNoticeCell() -> String{
        return "SchoolNoticeCell"
    }
    class
    
    
    
    
    
    
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
