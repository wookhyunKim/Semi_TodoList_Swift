//
//  LJU_DBModel.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation

// --- FireBase Data 담을 DataTypeClass
class LJU_DBModel{
    
    var documentID: String // FireBase 문서ID
    var image: String // 이미지 URL
    var title: String // TodoList 제목
    var todo: String // 내용
    var todoStatus: Bool // 완료&미완료
    var privateStatus: Bool // 공개&비공개
    var sequence: Int // todolist순번
    
    init(documentID: String, image: String, title: String, todo: String, todoStatus: Bool, privateStatus: Bool, sequence: Int) {
        self.documentID = documentID
        self.image = image
        self.title = title
        self.todo = todo
        self.todoStatus = todoStatus
        self.privateStatus = privateStatus
        self.sequence = sequence
    }
}
