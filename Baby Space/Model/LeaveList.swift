//
//  LeaveList.swift
//  WXT_Parents
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class LeaveListModel: JSONJoy {
    var leaveList: [LeaveListInfo]
    var count: Int{
        return self.leaveList.count
    }
    
    init(){
        leaveList = Array<LeaveListInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        leaveList = Array<LeaveListInfo>()
        for childs: JSONDecoder in decoder.array!{
            leaveList.append(LeaveListInfo(childs))
        }
    }
    
    func append(list: [LeaveListInfo]){
        self.leaveList = list + self.leaveList
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
    var teacheravatar:String?
    var teacherid:String?
    var teachername:String?
    var teacherphone:String?
    
    
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
        
        teacheravatar = decoder["teacheravatar"].string
        teacherid = decoder["teacherid"].string
        teachername = decoder["teachername"].string
        teacherphone = decoder["teacherphone"].string
        
    }
    
}