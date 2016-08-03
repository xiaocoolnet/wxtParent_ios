//
//  ClassModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/7/28.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class BabyClassModel: JSONJoy{
    var status:String?
    var data: BabyClassInfo?
    var datas = Array<BabyClassInfo>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = BabyClassInfo(decoder["data"])
        }
        else{
            errorData = decoder["data"].string
        }
    }
}

class BabyClassList: JSONJoy {
    var status:String?
    var objectlist: [BabyClassInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<BabyClassInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<BabyClassInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(BabyClassInfo(childs))
        }
    }
    
    func append(list: [BabyClassInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class BabyClassInfo: JSONJoy{
    
    var mon = Array<MonInfo>()
    var tu = Array<MonInfo>()
    var we = Array<MonInfo>()
    var th = Array<MonInfo>()
    var fri = Array<MonInfo>()
    var sat = Array<MonInfo>()
    var sun = Array<MonInfo>()
    
    
    required init(_ decoder: JSONDecoder){
        if decoder["mon"].array != nil {
            for childs: JSONDecoder in decoder["mon"].array!{
                self.mon.append(MonInfo(childs))
            }
        }
        if decoder["tu"].array != nil {
            for childs: JSONDecoder in decoder["tu"].array!{
                self.tu.append(MonInfo(childs))
            }
        }
        if decoder["we"].array != nil {
            for childs: JSONDecoder in decoder["we"].array!{
                self.we.append(MonInfo(childs))
            }
        }
        if decoder["th"].array != nil {
            for childs: JSONDecoder in decoder["th"].array!{
                self.th.append(MonInfo(childs))
            }
        }
        if decoder["fri"].array != nil {
            for childs: JSONDecoder in decoder["fri"].array!{
                self.fri.append(MonInfo(childs))
            }
        }
        if decoder["sat"].array != nil {
            for childs: JSONDecoder in decoder["sat"].array!{
                self.sat.append(MonInfo(childs))
            }
        }
        if decoder["sun"].array != nil {
            for childs: JSONDecoder in decoder["sun"].array!{
                self.sun.append(MonInfo(childs))
            }
        }
        
    }
    func addpend(list: [MonInfo]){
        self.mon = list + self.mon
    }
    
    
}

class MonList: JSONJoy {
    var status:String?
    var objectlist: [MonInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MonInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MonInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MonInfo(childs))
        }
    }
    
    func append(list: [MonInfo]){
        self.objectlist = list + self.objectlist
    }
}

class MonInfo: JSONJoy {
    
    var one:String?
    var two:String?
    var three:String?
    var four:String?
    var five:String?
    var six:String?
    var seven:String?
    var eight:String?
    
    
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        one = decoder["1"].string
        two = decoder["2"].string
        three = decoder["3"].string
        four = decoder["4"].string
        five = decoder["5"].string
        six = decoder["6"].string
        seven = decoder["7"].string
        eight = decoder["8"].string
        
    }
    
}
