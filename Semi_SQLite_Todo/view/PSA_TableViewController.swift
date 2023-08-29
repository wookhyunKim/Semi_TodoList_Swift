//
//  TableViewController.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/26.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tvListView: UITableView!
    
    var todoList: [DBModel] = []
    var isFiltering: Bool = false
    var searchText: String = ""
    
    
    var filteredArr: [String] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.setSearchControlUI()
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.isEnabled = true
        longPressGesture.delegate = self
        longPressGesture.addTarget(self, action: #selector(handleLongPress(_:)))
        tvListView.addGestureRecognizer(longPressGesture)
        
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem //상단에 편집하는거
        
        
        //         Uncomment the following line to preserve selection between presentations
        //         self.clearsSelectionOnViewWillAppear = false
        //
        //         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //    override func viewWillAppear(_ animated: Bool) { //다른데 갔다왔을때 controller가 숨어있다가 실행되는거
    //        appendData()
    //        tvListView.reloadData()
    //    }
    //    func appendData(){
    //
    //            todoList.append(TodoList(itemsImageFile: Message.itemImageFile))
    //
    //    }
    
    func initUI() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setSearchControlUI() {
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    func readValues(){
        let queryModel = QueryModel()
        queryModel.delegate = self  // extension으로 사용
        queryModel.downloadItems()
        tvListView.reloadData()
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering ? filteredArr.count : todoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! PSA_TableViewCell
        
        // Configure the cell...
        
        
        //        cell.imgView.image = UIImage(data: todoList[indexPath.row].timage)
        cell.imgView.image = UIImage(named: todoList[indexPath.row].timage)
        cell.lblTitle.text = isFiltering ? filteredArr[indexPath.row] : todoList[indexPath.row].ttitle
        cell.lblContent.text =  todoList[indexPath.row].tcontent

        
        
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
            let id = todoList[indexPath.row].tcode
            
            let delete = DeleteModel()
            let result = delete.deleteItems(code: id)
            
            if result{
                let resultAlert = UIAlertController(title: "결과", message: "삭제 되었습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                
                resultAlert.addAction(okAction)
                present(resultAlert, animated: true)
            }
            readValues()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //이동할 Item의 복사
        let itemToMove = todoList[fromIndexPath.row]
        //이동할 Item의 삭제
        todoList.remove(at: fromIndexPath.row)
        //삭제된 Item의 새로운 위치로 삽입
        todoList.insert(itemToMove, at: to.row)
        
    }
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgDetail"{
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            
            let detailView = segue.destination as! PSA_DetailViewController
            detailView.receiveCode = todoList[indexPath!.row].tcode
            detailView.receiveTitle = todoList[indexPath!.row].ttitle
            detailView.receiveContent = todoList[indexPath!.row].tcontent
            detailView.receiveImage = todoList[indexPath!.row].timage
            
        }
        
    }
    
    
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended{
            handleEnded(gesture)
        }
    }
    
    //    private func handleBegan(_ gesture: UILongPressGestureRecognizer){
    //    }
    //    private func handleChanged(_ gesture: UILongPressGestureRecognizer){
    //
    //    }
    
    private func handleEnded(_ gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: tableView)
        if let indexPath = tvListView.indexPathForRow(at: location) {
            let selectedCell = tvListView.cellForRow(at: indexPath) as? PSA_TableViewCell
            

            let testAlert = UIAlertController(title: "To do", message: "할 일을 완료하셨습니까?", preferredStyle: .alert)
   
            let actionDefault = UIAlertAction(title: "네", style: .destructive,handler: {ACTION in
                selectedCell!.backgroundColor = .lightGray
                self.readValues()
            })
            let actionDestructive = UIAlertAction(title: "아니요", style: .destructive,handler: {ACTION in
                selectedCell!.backgroundColor = .white
                self.readValues()
            })
            
            
            //UIAlertController에 UIAlertAtion 추가하기
            testAlert.addAction(actionDefault)
            testAlert.addAction(actionDestructive)
            
            
            //Alert 한 것을 화면에 띄우기
            present(testAlert, animated: true)
            
            
        }
    }
    
    
    
    
}//END


extension TableViewController: QueryModelProtocol{
    func itemDownloaded(item: [DBModel]) {
        todoList = item
        self.tvListView.reloadData()
    }
    
    
}







extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {  //사용자가 검색어를 입력할 때마다 호출되는 함수, 검색어 받아 필터링 작업 수행
        if searchText.isEmpty { //검색어가 비어있다면 필터링을 해제
            isFiltering = false
            filteredArr.removeAll()
        }  else { //todoList 배열에서 title 필터링해서 filteredArr 배열에 저장
            isFiltering = true
            filteredArr = todoList.filter { $0.ttitle.lowercased().contains(searchText.lowercased()) }.map { $0.ttitle }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { //취소 버튼을 클릭했을 때 호출되는 함수
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchText = ""
        isFiltering = false
        filteredArr.removeAll()
        tableView.reloadData()
    }
}


extension TableViewController: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



