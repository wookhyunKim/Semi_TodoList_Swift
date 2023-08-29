//
//  KangTodoList.swift
//  Semi-Sqlite-TodoList
//
//  Created by 맥찡 on 2023/08/27.
//

import Foundation

class TodoListKang{
    var id : Int
    var image: Data
    var title: String
    var memo: String
    var insertDate: String
    var swich: Int
    var seq: Int
    
    init(id: Int, image: Data, title: String, memo: String, insertDate: String, swich: Int, seq: Int) {
        self.id = id
        self.image = image
        self.title = title
        self.memo = memo
        self.insertDate = insertDate
        self.swich = swich
        self.seq = seq
    }
    
}
