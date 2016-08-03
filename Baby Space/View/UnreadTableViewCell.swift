//
//  UnreadTableViewCell.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class UnreadTableViewCell: UITableViewCell {

    
    @IBOutlet weak var chooseBtn: UIButton!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var relationLbl: UILabel!
    
    @IBOutlet weak var remindBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.remindBtn.layer.masksToBounds = true
        self.remindBtn.layer.cornerRadius = 10.0
        self.remindBtn.layer.borderWidth = 1.0
        self.remindBtn.layer.borderColor = RGBA(138.0, g: 227.0, b: 163.0, a: 1).CGColor
        
        self.chooseBtn.setImage(UIImage(named: "ic_fasong.png"), forState: .Normal)
        self.chooseBtn.setImage(UIImage(named: "Logo.png"), forState: .Selected)
        self.chooseBtn.addTarget(self, action: #selector(UnreadTableViewCell.choosePress), forControlEvents: .TouchUpInside)
    }
    func choosePress(){
        if self.chooseBtn.selected {
            self.chooseBtn.selected = false
        }else{
            self.chooseBtn.selected = true
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
