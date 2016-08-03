//
//  QCFriendsCell.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCFriendsCell: UITableViewCell {

    var headerImageView = UIImageView()
    var nameLabel = UILabel()
    
    
    
    //  MARK: - 初始化控件
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        headerImageView.frame = CGRectMake(10, 10, 50, 50)
        headerImageView.image = UIImage.init(named: "1")
        headerImageView.cornerRadius = 25
        contentView.addSubview(headerImageView)
        
        nameLabel.frame = CGRectMake(70, 20, 100, 30)
        nameLabel.text = "用户名称"
        contentView.addSubview(nameLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - 填充 cell
    func fillCellWithModel(model:TeaInfo)  {
//        let string = imageUrl + model.phone!
//        headerImageView.sd_setImageWithURL(NSURL.init(string: string))
        
        nameLabel.text = model.name
    }
    //  MARK: - 认证cell
    class func QCFriendsCell() -> String{
        return "QCFriendsCell"
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
