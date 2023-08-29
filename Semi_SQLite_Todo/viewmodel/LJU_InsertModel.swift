//
//  LJU_InsertModel.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation
import Firebase

class LJU_InsertModel{
    
    let db = Firestore.firestore()
    
    func insertItems(image:String, title:String, todo:String){

        
        db.collection("todolist").addDocument(data: [
            "image": image,
            "title": title,
            "todo": todo,
            "todoStatus": false,
            "privateStatus": false,
            "sequence": 2
        ]){error in
 
        } // // FireBase Query Insert End-

    } // func insertItems End-
} //class LJU_InsertModel End-
