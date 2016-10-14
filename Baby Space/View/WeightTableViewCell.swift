//
//  WeightTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/1.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class WeightTableViewCell: UITableViewCell {
//    体重
    @IBOutlet weak var weightLbl: UILabel!
//    时间
    @IBOutlet weak var timeLbl: UILabel!
//    年龄
    @IBOutlet weak var ageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillCellWithModel(model:sta_weiInfomation){
        weightLbl.text = model.weight
        timeLbl.text = model.log_date
        //  得到现在的体重
        //  根据现在的年纪进行计算得到的年纪数据
        
    }
    
}
