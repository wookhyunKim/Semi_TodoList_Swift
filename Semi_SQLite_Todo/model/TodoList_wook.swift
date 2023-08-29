//
//  TodoList_wook.swift
//  Semi_SQLite_Todo
//
//  Created by WOOKHYUN on 2023/08/26.
//

import Foundation


class TodoListWook{
    var todo_id : Int  // todo PK
    var todo_seq : Int    //  순서바꿀때 정렬로 사용하기 위한 변수
    var todo_title : String //  todo 제목
    var todo_content : String // todo 내용
    var todo_insertdate : String // todo 입력날짜
    var todo_image : Data // todo 이미지
    var todo_open : Int // todo 공개여부 결정할 bool
    var todo_status : Int // todo 상태 완료/미완료
    
    init(todo_id: Int, todo_seq: Int, todo_title: String, todo_content: String, todo_insertdate: String, todo_image: Data, todo_open: Int, todo_status: Int) {
        self.todo_id = todo_id
        self.todo_seq = todo_seq
        self.todo_title = todo_title
        self.todo_content = todo_content
        self.todo_insertdate = todo_insertdate
        self.todo_image = todo_image
        self.todo_open = todo_open
        self.todo_status = todo_status
    }
    
}
