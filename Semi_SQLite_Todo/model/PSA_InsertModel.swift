//
//  InsertModel.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/27.
//

import Foundation


class InsertModel{
  //var urlPath = "http://localhost:8080/ios/test.jsp"
  var urlPath = "http://localhost:8080/ios/todolist_Insert_ios.jsp"
    
    func insertItems(title: String, content: String, image: String) -> Bool{
    var result:Bool = true
    let urlAdd = "?title=\(title)&content=\(content)&image=\(image)"
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
