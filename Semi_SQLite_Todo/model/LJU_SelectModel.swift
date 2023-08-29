//
//  LJU_SelectModel.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation
import Firebase

protocol LJU_SelectModelProtocol{
    func itemDownLoaded(items: [LJU_DBModel])
} // protocol LJU_SelectModelProtocol End-

class LJU_SelectModel{
    
    var delegate: LJU_SelectModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(tableName: String){
        var locations: [LJU_DBModel] = []
        db.collection(tableName)
            .order(by: "todoStatus")
            .order(by: "sequence").getDocuments(completion: {
            (querySnapshot,err) in
                // Error Check
                if (err != nil){
                    print("SelectModel Error")
                }else{
                    
                    print("SelectModel Success")
                    // FireBase Data를 DBModel Type으로 변환 및 locations에 넣기
                    for documnent in querySnapshot!.documents{
                        let query = LJU_DBModel(
                            documentID: documnent.documentID,
                            image: documnent.data()["image"] as! String,
                            title: documnent.data()["title"] as! String,
                            todo: documnent.data()["todo"] as! String,
                            todoStatus: documnent.data()["todoStatus"] as! Bool,
                            privateStatus: documnent.data()["privateStatus"] as! Bool,
                            sequence: documnent.data()["sequence"] as! Int)
                            
                        locations.append(query)
                    } // for End-
                    DispatchQueue.main.async {
                        self.delegate.itemDownLoaded(items: locations)
                    } // DispatchQueue End-
                } // if, else End-
            })// // FireBase Query getDocuments End-
    } // func downloadItems End-
} // Class LJU_SelectModel End-
