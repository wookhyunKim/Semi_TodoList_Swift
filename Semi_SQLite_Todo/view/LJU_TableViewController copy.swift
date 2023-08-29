////
////  LJU_TableViewController.swift
////  TodoList_FireBase
////
////  Created by 이종욱 on 2023/08/26.
////
//
//import UIKit
//
//class LJU_TableViewController: UITableViewController {
//
//    
//    // --- TableView
//    @IBOutlet var tvTodoList: UITableView!
//    @IBOutlet var searchBar: UISearchBar!
//    
//    var todolist_data:[LJU_DBModel] = []
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // --- 상단 edit버튼 활성화
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        readValues()
//    }
//    
//   
//    
//    // Alert 띄우기
//    func callAlert(){
//        
//        let alert = UIAlertController(title: "Private Todo", message: "Plase enter password", preferredStyle: .alert)
//        
//        // 비밀번호 텍스트필드
//        alert.addTextField{(alertTextField) in
//            alertTextField.placeholder = "Password"
//            alertTextField.isSecureTextEntry = true
//        }
//        
//        let yes = UIAlertAction(title: "Ok", style: .default,handler: {
//            ACTION in
//            // 비밀번호 체크
//            if alert.textFields?[0].text == "1234"{
//            // 세그로 화면이동
//               self.performSegue(withIdentifier: "sgUpdate", sender: self)
//                
//            }else{
//                let errorAlert = UIAlertController(title: "Error", message: "it's a different password", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "Ok", style: .default,handler: {ACTION in
//                    self.callAlert()
//                })
//                ok.setValue(UIColor.red, forKey: "titleTextColor")
//                
//                errorAlert.addAction(ok)
//                self.present(errorAlert, animated: true)
//            }
//            }
//            
//        )
//        
//        let no = UIAlertAction(title: "Cancel", style: .cancel)
//        no.setValue(UIColor.red, forKey: "titleTextColor")
//        alert.addAction(no)
//        
//        alert.addAction(yes)
//        present(alert, animated: true)
//    } // func callAlert End-
//
//    
//    
//    // SelectModel에서 데이터 불러오기
//    func readValues(){
//        let selectModel = LJU_SelectModel()
//        selectModel.delegate = self
//        selectModel.downloadItems(tableName: "todolist") // todolist Table 불러오기
//        tvTodoList.reloadData()
//        
//    }
//    
//    
//    
//    
//
//    // MARK: - Table view data source
//
//    // --- TableView Column
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    // --- TableView Row 데이터갯수
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return todolist_data.count // todolist_data의 index만큼
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! LJU_TableViewCell
//
//        // Configure the cell...
//        
//        
//        
//        cell.cell_title.text = todolist_data[indexPath.row].title
//        cell.cell_todo.text = todolist_data[indexPath.row].todo
//        
//        // preivateStatus에 따른 자물쇠 onOff
//        if todolist_data[indexPath.row].privateStatus{
//            cell.cell_lock.isHidden = false
//        }else{
//            cell.cell_lock.isHidden = true
//        }
//        
//        // todo완료&미완료 에 따른 backgroundColor 및 줄긋기
//        if todolist_data[indexPath.row].todoStatus{
//            
//            cell.contentView.backgroundColor = .systemGray5
//            cell.cell_Btn.setTitle("❌", for: .normal)
//            
//            cell.cell_title.attributedText = cell.cell_title.text?.strikeText()
//            cell.cell_todo.attributedText = cell.cell_todo.text?.strikeText()
//            
//        }else{
//            cell.contentView.backgroundColor = .white
//            cell.cell_Btn.setTitle("✅", for: .normal)
//            cell.cell_title.attributedText = cell.cell_title.text?.nomalText()
//            cell.cell_todo.attributedText = cell.cell_todo.text?.nomalText()
//        }
//        
//        // cellImage 호출
//        let url = URL(string: todolist_data[indexPath.row].image)
//        
//        DispatchQueue.global().async {
//            if let data = try? Data(contentsOf: url!){
//                DispatchQueue.main.async {
//                    cell.cell_image.image = UIImage(data: data)
//                }
//            }else{
//                    print("이미지불러오기실패")
//                }
//        }
//        
//        // cell안의 버튼의 태그에 indexPath.row 넣기
//        cell.cell_Btn.tag = indexPath.row
//        // cell안의 버튼함수 호출, 터치업이벤트
//        cell.cell_Btn.addTarget(self, action: #selector(cellBtnClick(sender:)), for: .touchUpInside)
//        return cell
//    }
//    
//    // Cell안에 버튼 함수 https://co-dong.tistory.com/70
//    @objc func cellBtnClick(sender: UIButton){
//
//        
//        let todoStatusUpdate = LJU_UpdateModel()
//        todoStatusUpdate.todoStatusUpdate(DocumentId: todolist_data[sender.tag].documentID, todoStatus: todolist_data[sender.tag].todoStatus)
//        readValues()
//    }
//    
//    // 테이블 클릭 이벤트
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       
//        let message = LJU_Message.self
//        message.documentId = todolist_data[indexPath.row].documentID
//        message.image = todolist_data[indexPath.row].image
//        message.title = todolist_data[indexPath.row].title
//        message.todo = todolist_data[indexPath.row].todo
//        message.todoStatus = todolist_data[indexPath.row].todoStatus
//        message.privateStatus = todolist_data[indexPath.row].privateStatus
//        
//        if todolist_data[indexPath.row].privateStatus == true{
//            callAlert()
//        }else{
//            self.performSegue(withIdentifier: "sgUpdate", sender: self)
//        }
//        
//        
// 
//        
//        
//    }
//    
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    
//    // Override to support editing the table view.
//    // 밀어서 삭제하기
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            
//            // 선택된 cell의 documentId 가져오기
//            let documentId = todolist_data[indexPath.row].documentID
//            // deleteAction 함수 호출
//            deleteAction(documentID: documentId)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    // 삭제하기 함수
//    func deleteAction(documentID:String){
//        // DeleteModel 부르기
//        let delAction = LJU_DeleteModel()
//        // 리턴값 받지않게 _ 처리 deleteItem함수 실행
//        _ = delAction.deleteItems(documentId: documentID)
//        // 화면재구성하기
//        self.readValues()
//    }
//
//    // 키보드 외부 클릭시 내리기
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            self.view.endEditing(true)
//        }
//    
//    
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        
//        let moverow = LJU_UpdateModel()
//        moverow.todolistMoveRow(DocumentId: todolist_data[fromIndexPath.row].documentID, sequence: todolist_data[to.row].sequence)
//        moverow.todolistMoveRow(DocumentId: todolist_data[to.row].documentID, sequence: todolist_data[fromIndexPath.row].sequence)
//        
//    }
//    
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//} // class LJU_TableViewController End-
//
//// selectProtocol
//extension LJU_TableViewController:LJU_SelectModelProtocol{
//    func itemDownLoaded(items: [LJU_DBModel]) {
//        // self 전역변수 todolist_data에 itmes 넣기
//        todolist_data = items
//        // data는 들어갔으니 TableView 화면 재구성하기
//        self.tvTodoList.reloadData()
//    }
//    
//    
//}
//
//// 글자 밑줄긋기
//extension String {
//    func strikeText() -> NSAttributedString{
//        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value:  UIColor.red, range: NSMakeRange(0, attributeString.length))
//                                    
//        return attributeString
//    }
//    
//    func nomalText() -> NSAttributedString{
//        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value:  UIColor.black, range: NSMakeRange(0, attributeString.length))
//        return attributeString
//    }
//}
////
////
////extension LJU_TableViewController: UISearchBarDelegate{
////
////    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
////        <#code#>
////    }
////}
