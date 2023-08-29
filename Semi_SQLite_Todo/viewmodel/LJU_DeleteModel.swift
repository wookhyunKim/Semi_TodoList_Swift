//
//  LJU_DeleteModel.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation
import Firebase

class LJU_DeleteModel{
    
    var db = Firestore.firestore()
    
    func deleteItems(documentId: String) -> Bool{
        var status: Bool = true
        
        db.collection("todolist").document(documentId).delete(){
            error in
            error != nil ? (status = false) : (status = true)
        } // FireBase Query Delete End-
        return status
    } // func deleteItems End-
} // class LJU_DeleteModel End-
