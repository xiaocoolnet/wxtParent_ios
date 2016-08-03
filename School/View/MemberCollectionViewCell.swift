//
//  MemberCollectionViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/2.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    var imgView:UIImageView?//cell上的图片
    var nameLbl:UILabel?//cell上的名字
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        初始化各种控件
        imgView = UIImageView(frame: CGRectMake(0, 0, (WIDTH-125)/5, (WIDTH-125)/5))
        imgView?.layer.masksToBounds = true
        imgView?.layer.cornerRadius = (WIDTH-125)/10
        imgView?.image = UIImage(named: "Logo.png")
        self.addSubview(imgView!)
        
        nameLbl = UILabel(frame: CGRectMake(0,(WIDTH-125)/5+10,(WIDTH-125)/5,20))
        nameLbl?.text = "张三"
        nameLbl?.textAlignment = .Center
        self.addSubview(nameLbl!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
