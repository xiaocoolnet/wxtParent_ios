//
//  QCPictureInfo.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class QCPictureList: JSONJoy {
    var homeworkList: [QCPictureInfo]
    var count: Int{
        return self.homeworkList.count
    }
    
    init(){
        homeworkList = Array<QCPictureInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        homeworkList = Array<QCPictureInfo>()
        for childs: JSONDecoder in decoder.array!{
            homeworkList.append(QCPictureInfo(childs))
        }
    }
    
    func append(list: [QCPictureInfo]){
        self.homeworkList = list + self.homeworkList
    }
}

class QCPictureInfo: JSONJoy{
    var picture_url:String?

    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        picture_url = decoder["picture_url"].string
  
    }
    
}