//
//  WookTableViewController.swift
//  Semi_SQLite_Todo
//
//  Created by WOOKHYUN on 2023/08/26.
//

import UIKit

class WookTableViewController: UITableViewController {
    
    @IBOutlet var listTableView: UITableView!
    
    var todoList : [TodoList] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.createDB()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        selectAction()
    }
    
    
    // Mark : - Function
    func selectAction(){
        todoList.removeAll()
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.delegate = self
        database_Handler.selectAction()
        listTableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wookCell", for: indexPath)  as! WookTableViewCell
        
        // Configure the cell...
        //cell.lblTi.text = todoList[indexPath.row].dcontent
        
        cell.lblTitle.text = todoList[indexPath.row].todo_title
        cell.lblContent.text = todoList[indexPath.row].todo_content
        cell.lblDate.text = todoList[indexPath.row].todo_insertdate
        cell.imgView.image = UIImage(data: todoList[indexPath.row].todo_image)
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // id 가 primary key 값
            let id = todoList[indexPath.row].todo_id
            let database_Handler = DataBase_Handler_Wook()
            database_Handler.deleteAction(id)
            self.selectAction()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    // Override to support rearranging the table view.
    // 목록 순서 바꾸기
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        // cell 이랑 데이터랑 연동하기
        // 이동할 Item 복사
        let itemToMove = todoList[fromIndexPath.row]
        
        // 이동할 item 삭제
        todoList.remove(at: fromIndexPath.row)
        
        // 삭제된 item의 새로운 위치로 삽입
        todoList.insert(itemToMove, at: to.row)

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wSgDetail"{
            let cell = sender as! WookTableViewCell
            let indexPath = listTableView.indexPath(for: cell)
            
            let send = segue.destination as! WookDetailViewController
            send.givenId = todoList[indexPath!.row].todo_id
            send.givenTitle = todoList[indexPath!.row].todo_title
            send.givenContent = todoList[indexPath!.row].todo_content
            send.givenImage = UIImage(data: todoList[indexPath!.row].todo_image)
        }
        
    }
    
}

extension WookTableViewController : QueryModelProtocol{
    func itemDownloaded(items: [TodoList]) {
        todoList = items
        self.listTableView.reloadData()
        
    }
    
    
}
