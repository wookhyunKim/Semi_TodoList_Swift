//
//  QueryModel.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/26.
//

import Foundation


protocol QueryModelProtocol{
    func itemDownloaded(item: [DBModel])
}

class QueryModel{
    var delegate: QueryModelProtocol!
    let urlPath = "http://localhost:8080/ios/todolist_query_ios.jsp"
    
    func downloadItems(){
        let url: URL = URL(string: urlPath)!
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.parseJSON(data)
                }
            }catch{
                print("Failed to download data")
            }
        }
        
    }
    
    // JSON을 배열 형식으로 풀기
    func parseJSON(_ data: Data){
        let decoder = JSONDecoder()
        var locations: [DBModel] = []
        
        do{
            let todolist = try decoder.decode([TodoListJSON].self , from: data)
            for todo in todolist{
                let query = DBModel(tcode: todo.tcode, ttitle: todo.ttitle, tcontent: todo.tcontent, timage: todo.timage)
                locations.append(query)
            }
            
        }catch{
            print("Fail: \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            self.delegate.itemDownloaded(item: locations)
        }
    }
    
    
}
