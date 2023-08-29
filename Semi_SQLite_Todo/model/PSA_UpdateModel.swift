//
//  UpdateModel.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/27.
//

import Foundation


class UpdateModel{
    
    var urlPath = "http://localhost:8080/ios/todolist_update_ios.jsp"
    
    func updateItems(code: String, title: String, content: String, image: String) -> Bool{
        var result:Bool = true
        
        print(image)
        print(code)
        print(content)
        print(title)
        let urlAdd = "?title=\(title)&content=\(content)&image=\(image)&code=\(code)"

        urlPath = urlPath + urlAdd
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        
        DispatchQueue.global().async {
            do{
                _ = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    result = true
                }
            }catch{
                print("Failed to update data")
                result = false
            }
        }
        return result
    }
    
}
