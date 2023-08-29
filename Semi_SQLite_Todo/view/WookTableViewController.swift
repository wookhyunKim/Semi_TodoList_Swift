//
//  WookTableViewController.swift
//  Semi_SQLite_Todo
//
//  Created by WOOKHYUN on 2023/08/26.
//

import UIKit

class WookTableViewController: UITableViewController {
    
    @IBOutlet var listTableView: UITableView!
    
    
    
    
    
    var todoList : [TodoListWook] = []
    
    var status : Int = 0
    
    var pw : String = "1234"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.createDB()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 1
        longPressGesture.isEnabled = true
        longPressGesture.delegate = self
        longPressGesture.addTarget(self, action: #selector(handleLongPress))
        listTableView.addGestureRecognizer(longPressGesture)
        
        //         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        selectAction()
    }
    
    // MARK: - switch
    @IBAction func swOpen(_ sender: UISwitch) {
        
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = listTableView.indexPath(for: cell) else {
            return
        }
        
        if sender.isOn {
            let addAlert = UIAlertController(title: "공개여부확인", message: "", preferredStyle: .alert)
            
            //addAlert.addTextField()
            // placeholder
            addAlert.addTextField{
                ACTION in ACTION.placeholder = "비밀번호를 입력하세요"
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .default,handler: {ACTION in
                sender.setOn(false, animated: true)
            })
            
            let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
                sender.setOn(true, animated: true)
                let result = self.passCheck(addAlert.textFields![0].text!)
                if result{
                    sender.setOn(true, animated: true)
                    self.updateOpen(self.todoList[indexPath.row].todo_id,1)
                    self.selectAction()
                    print("비번맞음")
                }else{
                    sender.setOn(false, animated: true)
                    self.selectAction()
                    print("비번틀림")
                }
                
                
            })
            addAlert.addAction(cancelAction)
            addAlert.addAction(okAction)
            
            present(addAlert,animated: true)
        }else{
            self.updateOpen(self.todoList[indexPath.row].todo_id,0)
            self.selectAction()
        }
    }
    
    func updateOpen(_ id : Int, _ tf : Int){
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.updateOpen(id, tf)
        
    }
    
    
    
    // MARK: - function
    func selectAction(){
        //todoList.removeAll()
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.delegate = self
        database_Handler.selectAction()
        listTableView.reloadData()
    }
    
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        // longpress는 스위치문 사용하기 좋음
        //        switch gesture.state {
        //        case .began:
        //            handleBegan(gesture)
        //        case .changed:
        //            handleChanged(gesture)
        //        default:
        //            // ended, canceled, failed
        //            handleEnded(gesture)
        //        }
        if gesture.state == .ended{
            let point = gesture.location(in: listTableView)
            
            if let indexPath = listTableView.indexPathForRow(at: point){
                todoList[indexPath.row].todo_status = todoList[indexPath.row].todo_status == 1 ? 0 : 1
                self.status = todoList[indexPath.row].todo_status
                let database_Handler = DataBase_Handler_Wook()
                database_Handler.updateStatus(todoList[indexPath.row].todo_id, todoList[indexPath.row].todo_status)
            }
            handleEnded(gesture)
        }
    }
    
    //    private func handleBegan(_ gesture: UILongPressGestureRecognizer) {
    //        // TODO
    //    }
    //
    //    private func handleChanged(_ gesture: UILongPressGestureRecognizer) {
    //        // TODO
    //
    //    }
    
    private func handleEnded(_ gesture: UILongPressGestureRecognizer) {
        // TODO
        
        showAlert()
    }
    
    
    func showAlert(){
        // AlertController 초기화
        let testAlert = UIAlertController(title: "\(status == 0 ? "취소" : "완료")", message: "\(status == 0 ? "취소하시겠습니까?" : "할 일을 완료하셨습니까 ?")", preferredStyle: .alert)
        
        
        // AlertAction 설정 ( 버튼 생성 )
        // 기본 글씨체
        let actionDefault = UIAlertAction(title: "네", style: .default,handler: {ACTION in
            self.listTableView.reloadData()
            
        })
        // UIAlertController에 UIAlertAction 버튼추가하기
        testAlert.addAction(actionDefault)
        
        let cancelDefault = UIAlertAction(title: "아니오", style: .default)
        // UIAlertController에 UIAlertAction 버튼추가하기
        testAlert.addAction(cancelDefault)
        
        // alert 띄우기 present  barrier default
        present(testAlert, animated: true)
        
    }
    
//    func textFieldAlert(){
//        let addAlert = UIAlertController(title: "공개여부확인", message: "", preferredStyle: .alert)
//
//        //addAlert.addTextField()
//        // placeholder
//        addAlert.addTextField{
//            ACTION in ACTION.placeholder = "비밀번호를 입력하세요"
//        }
//
//        let cancelAction = UIAlertAction(title: "취소", style: .default)
//
//        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
//            let result = self.passCheck(addAlert.textFields![0].text!)
//            if result{
//                self.swStatus = true
//                self.selectAction()
//                print("비번맞음")
//            }else{
//                print("비번틀림")
//            }
//
//
//        })
//        addAlert.addAction(cancelAction)
//        addAlert.addAction(okAction)
//
//        present(addAlert,animated: true)
//    }
//
    func passCheck(_ text : String)-> Bool{
        var rs : Bool = false
        if text == pw {
            rs = true
        }else{
            rs = false
        }
        return rs

    }
    
    // MARK: - Table 구성
    
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
        
        
        // 완료상태 cell 바꿔주기
        if todoList[indexPath.row].todo_status == 1 {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        
        cell.lblTitle.text = todoList[indexPath.row].todo_title
        cell.lblContent.text = todoList[indexPath.row].todo_content
        cell.lblDate.text = todoList[indexPath.row].todo_insertdate
        cell.imgView.image = UIImage(data: todoList[indexPath.row].todo_image)
        return cell
    }
    
    
    
    // 삭제
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
    
    // segue로 보내주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

            
            
            if segue.identifier == "wSgDetail"{
                let cell = sender as! WookTableViewCell
                let indexPath = listTableView.indexPath(for: cell)
                
                if todoList[indexPath!.row].todo_open == 1 {
                    let send = segue.destination as! WookDetailViewController
                    send.givenId = todoList[indexPath!.row].todo_id
                    send.givenTitle = todoList[indexPath!.row].todo_title
                    send.givenContent = todoList[indexPath!.row].todo_content
                    send.givenImage = UIImage(data: todoList[indexPath!.row].todo_image)
                }
                

            }

        
    }
    
    
} // WookTableViewController
// MARK: - extension
// protocol 로 받아온 값 리스트에 넣어주기
extension WookTableViewController : QueryModelProtocolWook{
    func itemDownloaded(items: [TodoListWook]) {
        todoList = items
        self.listTableView.reloadData()
        
    }
    
    
}

// longpress gesture
extension WookTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
