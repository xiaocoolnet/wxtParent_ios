//
//  QCHomeWorkItem.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class QCHomeWorkItem: UICollectionViewCell {
    
    var itemImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        itemImageView.frame = self.contentView.frame
        contentView.addSubview(itemImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
