//
//  HeightTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/1.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HeightTableViewCell: UITableViewCell {
//身高
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!//时间
    @IBOutlet weak var ageLbl: UILabel!//年龄
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillCellWithModel(){
        
    }
    
    
}
