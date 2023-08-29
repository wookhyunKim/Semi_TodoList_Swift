//
//  KangAddViewController.swift
//  Semi-Sqlite-TodoList
//
//  Created by 맥찡 on 2023/08/27.
//

import UIKit

class KangAddViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvMemo: UITextView!
    
    // 카메라, 앨범에서 사진을 고를 수 있도록 하는 뷰 컨틀롤러
    let imgPicker = UIImagePickerController()
    var seq = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
        tvMemo.layer.borderColor = UIColor.black.cgColor
        tvMemo.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnPhoto(_ sender: UIButton) {
        let alert =  UIAlertController(title: "사진 선택", message: "버튼을 눌러주세요", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "앨범에서 가져오기", style: .default, handler: {ACTION in
            self.openLibrary()
        })
//        let camera =  UIAlertAction(title: "카메라", style: .default, handler: {ACTION in
//            self.openCamera()
//        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
//        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        let sqldb = SqliteServer()
        let image : UIImage = imgView.image!
        let imageData:NSData = image.pngData()! as NSData
        let title: String = tfTitle.text!
        let memo: String = tvMemo.text!
        
        print(seq)
        sqldb.todoInsert(image: imageData, title: title, memo: memo, status: 1, seq: self.seq)
        
        let resultAlert = UIAlertController(title: "결과", message: "입력 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
            self.navigationController?.popViewController(animated: true)
        })
        
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true)

    }
    
    // 라이브러리(앨범)
    func openLibrary(){
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: false, completion: nil)
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

// 선택한 이미지를 가져와 이미지 뷰에 설정
extension KangAddViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgView.image = image
            //print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}
