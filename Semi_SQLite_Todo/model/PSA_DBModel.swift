//
//  DBModel.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/26.
//

struct DBModel{
    var tcode: String
    var ttitle: String
    var tcontent: String
    var timage: String
    
    init(tcode: String, ttitle: String, tcontent: String, timage: String) {
        self.tcode = tcode
        self.ttitle = ttitle
        self.tcontent = tcontent
        self.timage = timage
    }
}
