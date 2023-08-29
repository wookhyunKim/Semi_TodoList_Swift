//
//  LJU_UpdateModel.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/28.
//

import Foundation
import Firebase

class LJU_UpdateModel{
    
    
    var db = Firestore.firestore()
    
    func updateItems(DocumentId: String, image:String, title:String, todo:String, todoStatus:Bool, privateStatus:Bool){


        db.collection("todolist").document(DocumentId).updateData([
            "image" : image,
            "title" : title,
            "todo" : todo,
            "todoStatus" : todoStatus,
            "privateStatus" : privateStatus
        ]){error in
            if error != nil{
                print("Update fail")
            }else{
   
            }
        }
        
       
    }
    
    // todo완료 미완료 firebase
    func todoStatusUpdate(DocumentId: String, todoStatus:Bool){
        var status:Bool = false
        if todoStatus{
            status = false
        }else{
            status = true
        }
        
        
        db.collection("todolist").document(DocumentId).updateData([
            "todoStatus" : status
        ]){error in
            if error != nil{
                print("Update fail")
            }else{
   
            }
        }
        
    }
    // private y&n firebase
    func privateStatusUpdate(DocumentId: String, priateStatus:Bool){
        
        db.collection("todolist").document(DocumentId).updateData([
            "priateStatus" : priateStatus
        ]){error in
            if error != nil{
                print("Update fail")
            }else{
   
            }
        }
    }
    
    // 순서바꾸기
    func todolistMoveRow(DocumentId: String, sequence: Int){
        
        print(sequence)
        db.collection("todolist").document(DocumentId).updateData([
            "sequence" : sequence
        ]){error in
            if error != nil{
                print("Update fail")
            }else{
                
            }
        }
    }
    
    
}
