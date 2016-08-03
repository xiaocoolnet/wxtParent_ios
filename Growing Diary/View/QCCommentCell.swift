//
//  QCCommentCell.swift
//  WXT_Parents
//
//  Created by JQ on 16/6/29.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCCommentCell: UITableViewCell {
    
    
    //  定义属性 (四个属性)
    //  头像
    var avatarImageView :UIImageView!
    //  名字
    var nameLabel :UILabel!
    //  userid
    var userid :NSString!
    //  照片
    var photoImageView :UIImageView!
    //  内容
    var contentLabel :UILabel!
    //  时间
    var comment_timeLabel :UILabel!
    //  MARK: - 初始化方法 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //  自定义控件在cell里面的位置
        let width = self.contentView.frame.size.width
        
        self.avatarImageView = UIImageView(frame:CGRectMake(5, 5, 0.2 * width, 0.2 * width))
        self.avatarImageView.layer.cornerRadius = 8
        self.avatarImageView.layer.masksToBounds = true
        self.contentView.addSubview(self.avatarImageView)
        
        //  添加名字的label
        self.nameLabel = UILabel(frame:CGRectMake(0.2 * width + 10, 5, width * 0.3, 20))
        self.contentView.addSubview(self.nameLabel)
        
        //  添加时间的label
        self.comment_timeLabel = UILabel(frame:CGRectMake(width *  0.6, 5, width * 0.3, 20))
        self.comment_timeLabel.textColor = UIColor.lightGrayColor()
        self.comment_timeLabel.font = UIFont.systemFontOfSize(14.0)
        self.contentView.addSubview(self.comment_timeLabel)
        
        //  内容设置
        self.contentLabel = UILabel(frame:CGRectMake( 0.2 * width + 10, 30, 0.8 * width - 15, 20))
        self.contentLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.contentLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - 填充 cell
    func fillCellWithModel(model:QCCommentModel)  {
        self.nameLabel.text = model.name
        self.avatarImageView.sd_setImageWithURL(NSURL.init(string: model.avatar!), placeholderImage: UIImage(named: "1.png"))
        //  自定义content的高度

        let titleHeight:CGFloat = calculateHeight(model.content!, size: 17, width: self.contentLabel.frame.size.width - 15)
        print(self.contentLabel.frame.size.width)
        self.contentLabel.numberOfLines = 0
        self.contentLabel.frame.size.height = titleHeight
        self.contentLabel.text = model.content
        self.comment_timeLabel.text = model.comment_time
    
    }
    //  MARK: - 认证cell
    class func QCCommentCell() -> String{
        return "QCCommentCell"
    }
    
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    

  

}
