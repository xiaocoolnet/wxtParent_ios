//
//  PictureList.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class PictureList: JSONJoy {
    var picturelist: [PicInfo]
    var count: Int{
        return self.picturelist.count
    }
    
    init(){
        picturelist = Array<PicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        //        status = decoder["status"].string
        picturelist = Array<PicInfo>()
        for childs: JSONDecoder in decoder.array!{
            picturelist.append(PicInfo(childs))
        }
    }
    
    func append(list: [PicInfo]){
        self.picturelist = list + self.picturelist
    }
}
class PicInfo: JSONJoy{
    var pictureurl:String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        pictureurl = decoder["pictureurl"].string
        
    }
    
}
