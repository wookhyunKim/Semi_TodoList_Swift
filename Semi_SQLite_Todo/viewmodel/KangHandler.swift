//
//  KangHandler.swift
//  Semi-Sqlite-TodoList
//
//  Created by 맥찡 on 2023/08/27.
//

import Foundation
import SQLite3

protocol QueryModelProtocol {
    func itemDownloaded(items: [TodoListKang])
}

class SqliteServer{
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var delegate: QueryModelProtocol!
    
    init(){
        // SQLite 설정
        // for = 파일 위치, path = "파일 이름"
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "TodoListKang.sqlite")
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK{
            print("error opening database")
        }
        
        // db 생성
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todoListKang (sid INTEGER PRIMARY KEY AUTOINCREMENT, simage BLOB, stitle TEXT, smemo TEXT, sstatus INTEGER, sinsertdate TEXT, seq INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errMSG)")
            return
        }
    }
    
    // 추가
    func todoInsert(image: NSData, title: String, memo: String, status: Int, seq: Int){
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self) // 한글처리
        let queryString = "INSERT INTO todoListKang (simage, stitle, smemo, sstatus, sinsertdate, seq) VALUES (?, ?, ?, ?, ?, ?)"
        
        // 날짜를 문자 타입으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식 지정

        let currentDate = Date() // 현재 날짜와 시간
        let dateString = dateFormatter.string(from: currentDate) // String type로 바뀐 날짜
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errMSG)")
            return
        }
        
        print("image: \(image.bytes)")
        sqlite3_bind_blob(stmt, 1, image.bytes, Int32(image.length), SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, title, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, memo, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 4, Int32(status))
        sqlite3_bind_text(stmt, 5, dateString, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 6, Int32(seq))
        
        // 처리가 잘 됬냐
 //       sqlite3_step(stmt)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error insert data: \(errMSG)")
            return
        }
    }
    
    // 수정
    func todoUpdate(title: String, memo: String, id: Int){
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self) // 한글처리
        let queryString = "UPDATE todoListKang SET stitle = ?, smemo = ?, sinsertdate = ? WHERE sid = ?"
        
        // 날짜를 문자 타입으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 형식 지정

        let currentDate = Date() // 현재 날짜와 시간
        let dateString = dateFormatter.string(from: currentDate) // String type로 바뀐 날짜
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errMSG)")
            return
        }
        
        sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, memo, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, dateString, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 4, Int32(id))
        
        // 처리가 잘 됬냐
//        sqlite3_step(stmt)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error insert data: \(errMSG)")
            return
        }
    }
    
    // 스위치 변경시
    func todoSwitchUpdate(switchValue: Int, id: Int){
        let queryString = "UPDATE todoListKang SET sstatus = ? WHERE sid = ?"
        
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errMSG)")
            return
        }
        
        sqlite3_bind_int(stmt, 1, Int32(switchValue))
        sqlite3_bind_int(stmt, 2, Int32(id))
        
        // 처리가 잘 됬냐
//        sqlite3_step(stmt)
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error insert data: \(errMSG)")
            return
        }
    }
    
    // 삭제
    func todoDelete(id: Int){
        let queryString = "DELETE FROM todoListKang WHERE sid = ?"
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        sqlite3_bind_int(stmt, 1, Int32(id))
        sqlite3_step(stmt)
    
    }
    
    // 불러오기
    func downloadItems(){
        let queryString = "SELECT * FROM todoListKang ORDER BY seq ASC"
        var locations : [TodoListKang] = []
        
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errMSG)")
            return
        }
        
        // 불러올 데이터가 있으면
        while (sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = sqlite3_column_int(stmt, 0)
            let image = Data(bytes: sqlite3_column_blob(stmt, 1), count: Int(sqlite3_column_bytes(stmt, 1)))
            let title = String(cString: sqlite3_column_text(stmt, 2))
            let memo = String(cString: sqlite3_column_text(stmt, 3))
            let insertDate = String(cString: sqlite3_column_text(stmt, 5))
            let swich = Int(sqlite3_column_int(stmt, 4))
            let seq = Int(sqlite3_column_int(stmt, 6))
            
            let query = TodoListKang(id : Int(id),image: image, title: title, memo: memo, insertDate: insertDate, swich: swich, seq: seq)

            locations.append(query)
        }
        DispatchQueue.main.async {
            self.delegate.itemDownloaded(items: locations)
        }
    }
    
    
    // 목록이 바뀌면
    func todoupdateList(id: Int, num1: Int, num2: Int) {
        let newSeq = num1
        let oldSeq = num2
        
        // 업데이트할 목록 seq
        let updateQuery = "UPDATE todoListKang SET seq = ? WHERE sid = ?"
        // 바뀔 목록
        let selectQuery = "SELECT sid, seq FROM todoListKang ORDER BY seq ASC"
        // id값
        var currentIds:[Int] = []
        // seq값
        var currentSeq:[Int] = []
        
        if sqlite3_prepare(db, selectQuery, -1, &stmt, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errMSG)")
            return
        }
        
        // 불러올 데이터가 있으면
        while (sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let seq = sqlite3_column_int(stmt, 1)
            currentIds.append(Int(id))
            currentSeq.append(Int(seq))
        }
        
        sqlite3_finalize(stmt)
        
        if sqlite3_prepare(db, updateQuery, -1, &stmt, nil) != SQLITE_OK{
            let errMSG = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errMSG)")
            return
        }
        
        // 번호 바꾸기 num1 바뀌는 번호
        for (index, itemSeq) in currentSeq.enumerated() {
            var seq = itemSeq
            print("seq \(seq)")
            // newSeq 바뀔번호 oldSeq 기존번호
            if itemSeq == oldSeq {
                seq = newSeq
            } else if oldSeq > newSeq{
                seq += 1
            }else if oldSeq < newSeq{
                seq -= 1
            }

            sqlite3_bind_int(stmt, 1, Int32(seq))
            sqlite3_bind_int(stmt, 2, Int32(currentIds[index]))
            
            sqlite3_step(stmt)
            sqlite3_reset(stmt)
        }
        

    }
    



}

