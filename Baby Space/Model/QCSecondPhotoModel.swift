//
//  File.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class QCPhotoList: JSONJoy {
    var homeworkList: [QCPhotoInfo]
    var count: Int{
        return self.homeworkList.count
    }
    
    init(){
        homeworkList = Array<QCPhotoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        homeworkList = Array<QCPhotoInfo>()
        for childs: JSONDecoder in decoder.array!{
            homeworkList.append(QCPhotoInfo(childs))
        }
    }
    
    func append(list: [QCPhotoInfo]){
        self.homeworkList = list + self.homeworkList
    }
}

class QCPhotoInfo: JSONJoy{
    
    var picture_url:String?

    
    
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        
        
        picture_url = decoder["picture_url"].string

        
        
    }
    
}