//
//  DeleteModel.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/27.
//

import Foundation


class DeleteModel{
    
    var urlPath = "http://localhost:8080/ios/todolist_delete_ios.jsp"
    
    func deleteItems(code: String) -> Bool{
        var result:Bool = true
        let urlAdd = "?code=\(code)"
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
                print("Failed to insert data")
                result = false
            }
        }
        return result
    }
    
}
