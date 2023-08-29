//
//  DataBase_Handler.swift
//  SQLite_DB_Handler
//
//  Created by WOOKHYUN on 2023/08/24.
//

import Foundation
import SQLite3

//protocol
protocol QueryModelProtocolWook{
    func itemDownloaded(items: [TodoListWook])
}


class DataBase_Handler_Wook{
    
    // SQLite db OpaquePointer 는 C 언어
    var db : OpaquePointer?
    var todoList : [TodoListWook] = []
    var delegate : QueryModelProtocolWook!
    
    
    init(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "SemiTodo.sqlite") // .appending(path: "fileName") app 내 db의 fileName

        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK{
            print("error opening database")
        }
    }

    
    
    // DB 생성
    func createDB(){
        // Table 만들기
        // todo 라는 table을 만들어서 did , dimageName, dcontent를 column으로 넣기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todo (todo_id INTEGER PRIMARY KEY AUTOINCREMENT, todo_seq INTEGER ,todo_title TEXT,todo_content TEXT,todo_insertdate TEXT,todo_image BLOB, todo_open INTEGER DEFAULT 1, todo_status INTEGER DEFAULT 0)", nil, nil, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errMSG)")
            return
        }
    }
    
    // Select Action
    func selectAction(){
        var stmt : OpaquePointer?
        
        // DB 쿼리문
        let queryString = "SELECT * FROM todo"
        
        // 쿼리문 준비
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // 조건 (sqlite3_step(stmt) == SQLITE_ROW ):  불러올 데이터가 있으면
        while(sqlite3_step(stmt) == SQLITE_ROW){
            // 0,1,2 는 db에서 컬럼의 순서
            let id = Int(sqlite3_column_int(stmt,0))
            let seq = Int(sqlite3_column_int(stmt,1))
            let title = String(cString: sqlite3_column_text(stmt, 2))
            let content = String(cString: sqlite3_column_text(stmt, 3))
            let insertdate = String(cString: sqlite3_column_text(stmt, 4))
            let image =  Data(bytes: sqlite3_column_blob(stmt, 5), count: Int(sqlite3_column_bytes(stmt, 5)))
            let open = Int(sqlite3_column_int(stmt,6))
            let status = Int(sqlite3_column_int(stmt,7))
            
            todoList.append(TodoListWook(todo_id: id, todo_seq: seq, todo_title: title, todo_content: content, todo_insertdate: insertdate, todo_image: image, todo_open: open, todo_status: status))
        }
        DispatchQueue.main.async {
            // delegate에 todoList 값을 넣어주기
            self.delegate?.itemDownloaded(items: self.todoList)
        }
    }
    
    
    // + 버튼 눌렀을 때 추가하기
    func insertAction(_ title : String,_ content:String,_ image : Data){
        var stmt : OpaquePointer?
        // 한글정의
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "INSERT INTO todo (todo_title, todo_content, todo_insertdate, todo_image) VALUES (?,?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // 날짜를 문자 타입으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식 지정

        let currentDate = Date() // 현재 날짜와 시간
        let dateString = dateFormatter.string(from: currentDate) // String type로 바뀐 날짜
        
        // Data type을 원시메모리로 바꾸기
        //let data: Data = // 여러분의 Data 객체
        //let rawPointer = data.withUnsafeBytes { $0.baseAddress }
        let rawPointer = image.withUnsafeBytes { $0.baseAddress }
        //let dataSize = data.count
        let dataSize = image.count
        
        
        // ? <- insert
        // stmt , ? 순서 , 내용 , -1 : 한글 , SQLITE_TRANSIENT
        sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, content, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, dateString, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 4, rawPointer, Int32(dataSize), nil)
        
        
        sqlite3_step(stmt)
    }
    
    // deleteAction
    func deleteAction(_ id:Int){
        var stmt : OpaquePointer?
        // 쿼리문
        let queryString = "DELETE FROM todo WHERE todo_id = ?"
        // 쿼리 준비
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        // ?에 값 넣어주기
        sqlite3_bind_int(stmt, 1, Int32(id))
        // 쿼리실행
        sqlite3_step(stmt)
    }
    
    
    // updateAction
    func updateAction(_ id : Int, _ title : String,_ content:String, _ image : Data){
        
        var stmt : OpaquePointer?
        // 한글정의
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "UPDATE todo SET todo_title = ?, todo_content = ?, todo_image = ? WHERE todo_id = ?"
        
        //  sqlite3_prepare(db, queryString, -1, &stmt, nil) 이것만 있어도됌
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        
        // Data type을 원시메모리로 바꾸기
        let rawPointer = image.withUnsafeBytes { $0.baseAddress }
        let dataSize = image.count
        
        
        
        // ? <- insert
        // stmt , ? 순서 , 내용 , -1 : 한글 , SQLITE_TRANSIENT
        sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, content, -1, SQLITE_TRANSIENT)
        sqlite3_bind_blob(stmt, 3, rawPointer, Int32(dataSize), nil)
        sqlite3_bind_int(stmt, 4, Int32(id))
        
        //  sqlite3_step(stmt) 이것만 있어도됌
        sqlite3_step(stmt)
    }
    
    // status update
    func updateStatus(_ id : Int, _ status : Int){
        
        var stmt : OpaquePointer?
        // 한글정의
        //let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "UPDATE todo SET todo_status = ? WHERE todo_id = ?"
        
        //  sqlite3_prepare(db, queryString, -1, &stmt, nil) 이것만 있어도됌
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        
        // ? <- insert
        // stmt , ? 순서 , 내용 , -1 : 한글 , SQLITE_TRANSIENT
        sqlite3_bind_int(stmt, 1, Int32(status))
        sqlite3_bind_int(stmt, 2, Int32(id))
        
        //  sqlite3_step(stmt) 이것만 있어도됌
        sqlite3_step(stmt)
    }
    
    
    // 공개여부 open update
    func updateOpen(_ id : Int, _ open : Int){
        
        var stmt : OpaquePointer?
        // 한글정의
        //let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let queryString = "UPDATE todo SET todo_open = ? WHERE todo_id = ?"
        
        //  sqlite3_prepare(db, queryString, -1, &stmt, nil) 이것만 있어도됌
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        
        // ? <- insert
        // stmt , ? 순서 , 내용 , -1 : 한글 , SQLITE_TRANSIENT
        sqlite3_bind_int(stmt, 1, Int32(open))
        sqlite3_bind_int(stmt, 2, Int32(id))
        
        //  sqlite3_step(stmt) 이것만 있어도됌
        sqlite3_step(stmt)
    }
}
