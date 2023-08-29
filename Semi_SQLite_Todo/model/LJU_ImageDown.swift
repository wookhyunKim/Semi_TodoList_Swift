//
//  LJU_ImageDown.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/26.
//

import Foundation
import Firebase
import FirebaseStorage

protocol LJU_ImageDownProtocol{
    func imagesDownLoaded(images: URL)
}

class LJU_ImageDown{

    var delegate: LJU_ImageDownProtocol!
    let storageRef = Storage.storage().reference(forURL: "gs://semitodolist.appspot.com")

    func allImageDown(){

        let imageRef = storageRef.child("cart.png")

        imageRef.downloadURL{
            url,error in
            if let error = error{
                print("ImageDown fail")
            }else{
                print(url)
                DispatchQueue.main.async {
                    self.delegate.imagesDownLoaded(images: url!)
                    
            }
        }


        }
    }
}


