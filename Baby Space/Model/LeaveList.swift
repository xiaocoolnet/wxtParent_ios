//
//  LeaveList.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class LeaveListModel: JSONJoy{
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

class LeaveList: JSONJoy {
    var status:String?
    var objectlist: [LeaveListInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<LeaveListInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<LeaveListInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(LeaveListInfo(childs))
        }
    }
    
    func append(list: [LeaveListInfo]){
        self.objectlist = list + self.objectlist
    }
    
}


class LeaveListInfo: JSONJoy{
    var begintime:String?
    var create_time:String?
    var deal_time:String?
    var endtime:String?
    var feedback:String?
    var id:String?
    var parentavatar:String?
    var parentname:String?
    var parentid:String?
    var parentphone:String?
    var reason:String?
    var status:String?
    var studentid:String?
    var studentname:String?
    var studentavatar:String?
    var teacheravatar:String?
    var teacherid:String?
    var teachername:String?
    var teacherphone:String?
    var classname:String?
    var pic = Array<LeavePicInfo>()
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        begintime = decoder["begintime"].string
        create_time = decoder["create_time"].string
        deal_time = decoder["deal_time"].string
        endtime = decoder["endtime"].string
        feedback = decoder["feedback"].string
        id = decoder["id"].string
        
        parentavatar = decoder["parentavatar"].string
        parentid = decoder["parentid"].string
        parentname = decoder["parentname"].string
        parentphone = decoder["parentphone"].string
        
        reason = decoder["reason"].string
        status = decoder["status"].string
        studentid = decoder["studentid"].string
        studentname = decoder["studentname"].string
        studentavatar = decoder["studentavatar"].string
        
        teacheravatar = decoder["teacheravatar"].string
        teacherid = decoder["teacherid"].string
        teachername = decoder["teachername"].string
        teacherphone = decoder["teacherphone"].string
        classname = decoder["classname"].string
        
        if decoder["pic"].array != nil {
            for childs: JSONDecoder in decoder["pic"].array!{
                self.pic.append(LeavePicInfo(childs))
            }
        }
        
    }
    func addpend(list: [LeavePicInfo]){
        self.pic = list + self.pic
    }
}


class LeavePicList: JSONJoy {
    var status:String?
    var objectlist: [LeavePicInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<LeavePicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<LeavePicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(LeavePicInfo(childs))
        }
    }
    
    func append(list: [LeavePicInfo]){
        self.objectlist = list + self.objectlist
    }
}

class LeavePicInfo: JSONJoy {
    
    var picture_url:String
    
    required init(_ decoder: JSONDecoder){
        picture_url = decoder["picture_url"].string ?? ""
        
    }
    
}



