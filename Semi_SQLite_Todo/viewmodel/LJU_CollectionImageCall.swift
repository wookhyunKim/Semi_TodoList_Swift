//
//  LJU_ImageDown.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation
import Firebase

protocol LJU_CollectionImageCallProtocol{
    func imageUrlPath(urlPath: [String])
}

class LJU_CollectionImageCall{

    var delegate: LJU_CollectionImageCallProtocol!
    let db = Firestore.firestore()

    func imageUrlDownload(){
        var imagesUrlPathList: [String] = []
        db.collection("images")
            .getDocuments(completion: {(querySnapshot, err) in
                if (err != nil){
                    print("CollectionImageList Error")
                }else{
                    print("CollectionImageList Success")
                    for imageList in querySnapshot!.documents{
                        imagesUrlPathList.append(imageList.data()["imagePath"] as! String   )
                    }
                    DispatchQueue.main.async {
                        self.delegate.imageUrlPath(urlPath: imagesUrlPathList)
                    }
                }
                
            })
                          
                          
                          
    }
}


