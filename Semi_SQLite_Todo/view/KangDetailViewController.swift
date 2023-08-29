//
//  KangDetailViewController.swift
//  Semi-Sqlite-TodoList
//
//  Created by 맥찡 on 2023/08/27.
//

import UIKit

class KangDetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UITextField!
    @IBOutlet weak var tvMemo: UITextView!
    @IBOutlet weak var swStatus: UISwitch!
    
    var receiveImage:Data = Data()
    var receiveTitle = ""
    var receiveMemo = ""
    var receiveId = 0
    var receiveStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvMemo.layer.borderColor = UIColor.black.cgColor
        tvMemo.layer.borderWidth = 1.0
        imgView.image = UIImage(data: receiveImage)
        lblTitle.text = receiveTitle
        tvMemo.text = receiveMemo
        swStatus.isOn = (receiveStatus != 0)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnModify(_ sender: UIBarButtonItem) {
        let sqldb = SqliteServer()
        sqldb.todoUpdate(title: lblTitle.text!, memo: tvMemo.text!, id: receiveId)
        
        let resultAlert = UIAlertController(title: "결과", message: "수정 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
            self.navigationController?.popViewController(animated: true)
        })
        
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true)
    }
    

    @IBAction func btnDelete(_ sender: UIBarButtonItem) {
        let sqldb = SqliteServer()
        sqldb.todoDelete(id: receiveId)
        
        let resultAlert = UIAlertController(title: "결과", message: "삭제 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
            self.navigationController?.popViewController(animated: true)
        })
        
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true)
    }
    
    @IBAction func btnSwitch(_ sender: UISwitch) {
        let sqldb = SqliteServer()
        
        let newDataValue = sender.isOn ? 1 : 0
        sqldb.todoSwitchUpdate(switchValue: newDataValue, id: receiveId)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
