//
//  func.swift
//  Semi_SQLite_Todo
//
//  Created by WOOKHYUN on 2023/08/26.
//

import Foundation
import UIKit

class ImageTypeChanger{
    
    
    // encoding
    func uiImageToData(image : UIImage) -> Data{
        //let image : UIImage = UIImage(named:"imageNameHere")!
        let imageData: Data = image.pngData()! as Data
        //let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return imageData
    }
    
    
    // decoding
    func dataTouiImage(blobImage : String) -> UIImage{
        let dataDecoded:NSData = NSData(base64Encoded: blobImage, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage: UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedimage
    }
}
