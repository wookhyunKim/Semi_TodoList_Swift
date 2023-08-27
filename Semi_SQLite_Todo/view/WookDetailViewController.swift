//
//  WookDetailViewController.swift
//  Semi_SQLite_Todo
//
//  Created by WOOKHYUN on 2023/08/26.
//

import UIKit

class WookDetailViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tfContent: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    var todoImageList : [UIImage] = []
    
    var img : [String] = ["cart.png","clock.png","pencil.png"]
    
    var givenContent : String = ""
    var givenTitle : String = ""
    var givenImage : UIImage?
    
    var givenId : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTitle.text = givenTitle
        tfContent.text = givenContent
        imgView.image = givenImage
        
        
        for i in 0..<img.count{
            todoImageList.append(UIImage(named: img[i])!)
        }
        
        
        
        
        // 연결
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
     

    @IBAction func btnUpdate(_ sender: UIButton) {
        
        update()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnDelete(_ sender: UIButton) {
        deleteAction()
        navigationController?.popViewController(animated: true)
    }
    
    func update(){
        guard let title = tfTitle.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let content = tfContent.text?.trimmingCharacters(in: .whitespaces) else {return}

        let changer = ImageTypeChanger()
        let imageData = changer.uiImageToData(image: imgView.image!) //UIImage -> Data
        
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.updateAction(givenId, title, content, imageData)
    }
    
    func deleteAction(){
        let database_Handler = DataBase_Handler_Wook()
        database_Handler.deleteAction(givenId)
    }
    
    
}//WookDetailViewController



// picker View 모양결정 => DataSource
extension WookDetailViewController : UIPickerViewDataSource{
    // pickerView 의 컬럼 갯수 => number control space
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // pickerView 의 row 갯수 => number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return todoImageList.count
    }
}


// picker view 기능추가
extension WookDetailViewController : UIPickerViewDelegate{
    // pickerView에 파일명 배치 => title
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return todoImageList[row]
//    }
    
    
    // pickerview에 이미지 썸네일 보여주기 => view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(image: todoImageList[row])
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        return imageView
    }
   
    // picker 높이조절 => rowHeight
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
    
    // 선택된 파일명을 이미지로 보이기 didselectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imgView.image = todoImageList[row]
        //lblImageName.text = imageFileName[row]
    }
}


