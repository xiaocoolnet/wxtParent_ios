//
//  ParentModel.swift
//  WXT_Parents
//
//  Created by 沈晓龙 on 16/8/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

class AllFamilyModel: JSONJoy{
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

class AllFamilyList: JSONJoy {
    var status:String?
    var objectlist: [AllFamilyInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<AllFamilyInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<AllFamilyInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(AllFamilyInfo(childs))
        }
    }
    
    func append(list: [AllFamilyInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class AllFamilyInfo: JSONJoy{
    
    var classname:String
    var classid:String
    var stu_par_list = Array<student_listInfo>()
    var isSelected = false
    var isOpen = false
    required init(_ decoder: JSONDecoder){
        classname = decoder["classname"].string ?? ""
        classid = decoder["classid"].string ?? ""
        
        if decoder["stu_par_list"].array != nil {
            for childs: JSONDecoder in decoder["stu_par_list"].array!{
                self.stu_par_list.append(student_listInfo(childs))
            }
        }
        
    }
    func addpend(list: [student_listInfo]){
        self.stu_par_list = list + self.stu_par_list
    }
    
}

class student_listList: JSONJoy {
    var status:String?
    var objectlist: [student_listInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<student_listInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<student_listInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(student_listInfo(childs))
        }
    }
    
    func append(list: [student_listInfo]){
        self.objectlist = list + self.objectlist
    }
}

class student_listInfo: JSONJoy {
    
    var id:String?
    var name:String?
    var phone:String?
    var photo:String?
    var isSelected = false
    var isOpen = false
    var isChecked = false
    var parent_info = Array<parent_listInfo>()
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        name = decoder["name"].string
        phone = decoder["phone"].string
        photo = decoder["photo"].string
        if decoder["parent_info"].array != nil {
            for childs: JSONDecoder in decoder["parent_info"].array!{
                self.parent_info.append(parent_listInfo(childs))
            }
        }
        
    }
    func addpend(list: [parent_listInfo]){
        self.parent_info = list + self.parent_info
    }
}


class parent_listList: JSONJoy {
    var status:String?
    var objectlist: [parent_listInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<parent_listInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<parent_listInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(parent_listInfo(childs))
        }
    }
    
    func append(list: [parent_listInfo]){
        self.objectlist = list + self.objectlist
    }
}

class parent_listInfo: JSONJoy {
    
    var id:String
    var name:String
    var phone:String
    var photo:String
    var appellation:String
    
    required init(_ decoder: JSONDecoder){
        name = decoder["name"].string ?? ""
        id = decoder["id"].string ?? ""
        phone = decoder["phone"].string ?? ""
        photo = decoder["photo"].string ?? ""
        appellation = decoder["appellation"].string ?? ""
    }
    
}


