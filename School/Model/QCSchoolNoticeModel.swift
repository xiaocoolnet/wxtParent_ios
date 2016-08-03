//
//  QCSchoolNoticeModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/6.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation


class successData: JSONJoy {
    var status : String?
    var dataSource : QCSchoolNoticeModel?
    var errorData : String?
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        if status == "success"{
            dataSource = QCSchoolNoticeModel(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
    }
}


class QCSchoolNoticeList: JSONJoy {
    var schoolNoticelist: [QCSchoolNoticeModel]
    var count: Int{
        return self.schoolNoticelist.count
    }
    
    init(){
        schoolNoticelist = Array<QCSchoolNoticeModel>()
    }
    required init(_ decoder: JSONDecoder) {
        
        schoolNoticelist = Array<QCSchoolNoticeModel>()
        for useids: JSONDecoder in decoder.array!{
            schoolNoticelist.append(QCSchoolNoticeModel(useids))
        }
    }
    
    func append(list: [QCSchoolNoticeModel]){
        self.schoolNoticelist = list + self.schoolNoticelist
    }
}

class QCSchoolNoticeModel:JSONJoy{

    var notice_content : String?
    var notice_time : String?
    var notice_title : String?
    var photo : String?
    var releasename : String?
    var hight : CGFloat?
    required init(_ decoder: JSONDecoder) {
        notice_title = decoder["notice_title"].string
        notice_content = decoder["notice_content"].string
        notice_time = decoder["notice_time"].string
        photo = decoder["photo"].string
        releasename = decoder["releasename"].string
        hight = calculateHeight(notice_content!, size: 14, width: WIDTH - 110)
    }
}