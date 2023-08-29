//
//  LJU_ImageUpload.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation
import Firebase
import FirebaseStorage

class LJU_ImageUpload{
    

    
    func imageUpload(image: Data,titleText: String, todoText: String){
 
        // 오늘 날짜시간 file명으로 바꾸기
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fileName = date.string(from: Date())
        
        
        let storage = Storage.storage().reference()
        // 파일명
        let riversRef = storage.child("images/\(fileName).png")
        
        let uploadTask = riversRef.putData(image, metadata: nil) {(metadata,error) in
            guard let metadata = metadata else {
                
                return
            }
            
            riversRef.downloadURL {(url, error) in
                guard let downloadURL = url else{

                    return
                }

                let image:String = url!.absoluteString
                let insertDB = LJU_InsertModel()
                insertDB.insertItems(image: image, title: titleText, todo: todoText)
            }
            
        }
        
        
        
    }
    
    
    func imageUploadUpdate(DocumentId: String, image: Data, title: String, todo: String, todoStatus: Bool, privateStatus: Bool){
 
        // 오늘 날짜시간 file명으로 바꾸기
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fileName = date.string(from: Date())
        
        
        let storage = Storage.storage().reference()
        // 파일명
        let riversRef = storage.child("images/\(fileName).png")
        
        let uploadTask = riversRef.putData(image, metadata: nil) {(metadata,error) in
            guard let metadata = metadata else {
                
                return
            }
            
            riversRef.downloadURL {(url, error) in
                guard let downloadURL = url else{

                    return
                }

                let image:String = url!.absoluteString
                let updateDB = LJU_UpdateModel()
                updateDB.updateItems(DocumentId: DocumentId, image: image, title: title, todo: todo, todoStatus: todoStatus, privateStatus: privateStatus)
            }
            
        }
        
        
        
    }
    
}
