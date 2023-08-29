//
//  KangTableViewController.swift
//  Semi-Sqlite-TodoList
//
//  Created by 맥찡 on 2023/08/27.
//

import UIKit

class KangTableViewController: UITableViewController {

    @IBOutlet var tvTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // 서치바를 통해 arr가 필터링 되어졌는 지에 대한 bool 값 변수
    var isFiltering: Bool = false
    
    var todoListData:[TodoListKang] = []
    // filter(서치바를 통해 작성한 무언가)를 담는 리스트
    var searchList:[TodoListKang] = []
    let searchController = UISearchController(searchResultsController: nil)
    var password = "1234"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
      
    override func viewWillAppear(_ animated: Bool) {
        readValues()
        setSearchControllerUI()
    }
    
    func readValues(){
        let hendler = SqliteServer()
        hendler.delegate = self
        hendler.downloadItems()
    }
    
    func setSearchControllerUI() {
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "검색어를 입력하세요"

    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering ? searchList.count :todoListData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellKang", for: indexPath) as! KangTableViewCell

        // Configure the cell...
        if self.isFiltering {
            cell.imgView.image = UIImage(data: searchList[indexPath.row].image)
            cell.lblTitle.text = searchList[indexPath.row].title
            cell.lblInsertDate.text = searchList[indexPath.row].insertDate
            
            // 셀의 배경색 변경
             if searchList[indexPath.row].swich == 0 {
                 cell.contentView.backgroundColor = .gray
             } else {
                 cell.contentView.backgroundColor = .white
             }
        }else{
            cell.imgView.image = UIImage(data: todoListData[indexPath.row].image)
            cell.lblTitle.text = todoListData[indexPath.row].title
            cell.lblInsertDate.text = todoListData[indexPath.row].insertDate
            
            // 셀의 배경색 변경
             if todoListData[indexPath.row].swich == 0 {
                 cell.contentView.backgroundColor = .gray
             } else {
                 cell.contentView.backgroundColor = .white
             }
        }


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
            let id = todoListData[indexPath.row].id
            deleteAction(id)
            readValues()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // 삭제
    func deleteAction(_ id: Int){
        let sqldb = SqliteServer()
        sqldb.todoDelete(id: id)
        readValues()
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // 이동할 Item의 복사
        let itemToMove = todoListData[fromIndexPath.row]
        // seq 번호 to.row로 옮긴 번호 값
        let sqldb = SqliteServer()
        sqldb.todoupdateList(id: itemToMove.id, num1: to.row, num2: itemToMove.seq)
        readValues()
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // 세그 화면 전환
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sgDetailKang" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvTableView.indexPath(for: cell)
                if todoListData[indexPath!.row].swich == 0 {
                    showPasswordAlert(for: indexPath!)
                    return false // 세그 실행 안함
                }
            }
        return true
    }
    
    func showPasswordAlert(for indexPath: IndexPath) {
        let addAlert = UIAlertController(title: "암호입력", message: "비활성 내용을 보려면 암호를 입력하세요", preferredStyle: .alert)

        addAlert.addTextField{ACTION in
            ACTION.placeholder = "비밀번호"
            ACTION.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let okAction = UIAlertAction(title: "입력", style: .default, handler: {ACTION in
            if self.password == addAlert.textFields?.first?.text{
                self.performSegue(withIdentifier: "sgDetailKang", sender: indexPath)
            } else {
                let errorAlert = UIAlertController(title: "오류", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(errorAlert, animated: true, completion: nil)
            }
        })
        addAlert.addAction(cancelAction)
        addAlert.addAction(okAction)
        
        present(addAlert, animated: true)
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgDetailKang"{
            let detailView = segue.destination as! KangDetailViewController
            // 셀이 잠겨있을경우
            if let indexPath = sender as? IndexPath {
                // search 했을경우
                if isFiltering{
                    detailView.receiveImage = searchList[indexPath.row].image
                    detailView.receiveTitle = searchList[indexPath.row].title
                    detailView.receiveMemo = searchList[indexPath.row].memo
                    detailView.receiveId = searchList[indexPath.row].id
                    detailView.receiveStatus = searchList[indexPath.row].swich
                }else{
                    detailView.receiveImage = todoListData[indexPath.row].image
                    detailView.receiveTitle = todoListData[indexPath.row].title
                    detailView.receiveMemo = todoListData[indexPath.row].memo
                    detailView.receiveId = todoListData[indexPath.row].id
                    detailView.receiveStatus = todoListData[indexPath.row].swich
                }
            // 셀이 열려있을때
            }else{
                let cell = sender as! UITableViewCell
                let indexPath1 = tvTableView.indexPath(for: cell)
                if isFiltering{
                    detailView.receiveImage = searchList[indexPath1!.row].image
                    detailView.receiveTitle = searchList[indexPath1!.row].title
                    detailView.receiveMemo = searchList[indexPath1!.row].memo
                    detailView.receiveId = searchList[indexPath1!.row].id
                    detailView.receiveStatus = searchList[indexPath1!.row].swich
                }else{
                    detailView.receiveImage = todoListData[indexPath1!.row].image
                    detailView.receiveTitle = todoListData[indexPath1!.row].title
                    detailView.receiveMemo = todoListData[indexPath1!.row].memo
                    detailView.receiveId = todoListData[indexPath1!.row].id
                    detailView.receiveStatus = todoListData[indexPath1!.row].swich
                }
            }
        }else{
            let listCount =  todoListData.count
            let addView = segue.destination as! KangAddViewController
            addView.seq = listCount
        }
    }
    
}// End

extension KangTableViewController: QueryModelProtocol{
    func itemDownloaded(items: [TodoListKang]) {
        todoListData = items
        self.tvTableView.reloadData()
    }
}

extension KangTableViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.tvTableView.reloadData()
    }
    
    // 사용자가 친 데이터로 검색
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isFiltering = true
        self.searchList = self.todoListData.filter { $0.title.hasPrefix(searchText) }
        self.tvTableView.reloadData()
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let text = searchBar.text?.lowercased() else { return }
        self.searchList = self.todoListData.filter { $0.title.hasPrefix(text) }

        self.tvTableView.reloadData()
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.isFiltering = false
        self.tvTableView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tvTableView.reloadData()
    }
    
    // 서치바 키보드 내리기
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}



