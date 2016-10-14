//
//  CoursewareModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class CoursewareModel: JSONJoy{
    var status:String?
    var data: JSONDecoder?
    var array : Array<JSONDecoder>?
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = decoder["data"]
        }
        else{
            errorData = decoder["data"].string
        }
    }
}

class CoursewareList: JSONJoy {
    var status:String?
    var objectlist: [CoursewareInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<CoursewareInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<CoursewareInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(CoursewareInfo(childs))
        }
    }
    
    func append(list: [CoursewareInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class CoursewareInfo: JSONJoy{
    
    var id : String?
    var subject :String?
    var courseware_info = Array<courseware_infoInfo>()
    
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        subject = decoder["subject"].string
        if decoder["courseware_info"].array != nil {
            for childs: JSONDecoder in decoder["courseware_info"].array!{
                self.courseware_info.append(courseware_infoInfo(childs))
            }
        }
        
    }
    func addpend(list: [courseware_infoInfo]){
        self.courseware_info = list + self.courseware_info
    }
    
}

class courseware_infoList: JSONJoy {
    var status:String?
    var objectlist: [courseware_infoInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<courseware_infoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<courseware_infoInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(courseware_infoInfo(childs))
        }
    }
    
    func append(list: [courseware_infoInfo]){
        self.objectlist = list + self.objectlist
    }
}

class courseware_infoInfo: JSONJoy {
    
    var courseware_id:String?
    var schoolid:String?
    var classid:String?
    var user_id:String?
    var subjectid:String?
    var courseware_title:String?
    var courseware_content:String?
    var courseware_url:String?
    var courseware_time:String?
    var courseware_status:String?
    var teacher_name:String?
    var teacher_photo:String?
    var teacher_duty:String?
    var coursewarePic = Array<coursewarePicInfo>()
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        courseware_id = decoder["courseware_id"].string
        schoolid = decoder["schoolid"].string
        classid = decoder["classid"].string
        user_id = decoder["user_id"].string
        subjectid = decoder["subjectid"].string
        courseware_title = decoder["courseware_title"].string
        courseware_content = decoder["courseware_content"].string
        courseware_url = decoder["courseware_url"].string
        courseware_time = decoder["courseware_time"].string
        courseware_status = decoder["courseware_status"].string
        teacher_name = decoder["teacher_name"].string
        teacher_photo = decoder["teacher_photo"].string
        teacher_duty = decoder["teacher_duty"].string
        if decoder["pic"].array != nil {
            for childs: JSONDecoder in decoder["pic"].array!{
                self.coursewarePic.append(coursewarePicInfo(childs))
            }
        }
        
    }
    func addpend(list: [coursewarePicInfo]){
        self.coursewarePic = list + self.coursewarePic
    }
    
}


class coursewarePicList: JSONJoy {
    var status:String?
    var objectlist: [coursewarePicInfo]

    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<coursewarePicInfo>()
    }
    required init(_ decoder: JSONDecoder) {

        objectlist = Array<coursewarePicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(coursewarePicInfo(childs))
        }
    }

    func append(list: [coursewarePicInfo]){
        self.objectlist = list + self.objectlist
    }
}

class coursewarePicInfo: JSONJoy {

    var picture_url:String


    //    init() {
    //
    //    }
    required init(_ decoder: JSONDecoder){
        picture_url = decoder["picture_url"].string ?? ""
        
    }
    
}