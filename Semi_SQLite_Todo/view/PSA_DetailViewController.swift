//
//  PSA_DetailViewController.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/27.
//

import UIKit

class PSA_DetailViewController: UIViewController {
    
    
    @IBOutlet weak var pickerImage: UIPickerView!
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    var selectedImage: UIImage?
    
    
    var receiveCode = ""
    var receiveTitle = ""
    var receiveContent = ""
    var receiveImage = ""
    
    
    var imageFileName = ["cart.png","clock.png","pencil.png"]
    var imageArray: [UIImage?] = []
    var fileName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfTitle.text = receiveTitle
        tfContent.text = receiveContent
        imageView.image = UIImage(named: receiveImage)
        fileName = receiveImage
        setKeyboardEvent()
        
        
        
        for i in 0..<imageFileName.count{
            let image = UIImage(named: imageFileName[i])
            imageArray.append(image)
        }
        
        
        
        // picker 연결
        pickerImage.dataSource = self
        pickerImage.delegate = self
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setKeyboardEvent(){
        //keyboard가 올라올때 일하는 observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //keyboard가 내려갈때 일하는 observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisAppear(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillAppear(_ sender: NotificationCenter){ //keyboard가 올라올때 발생하는거,keyboard 올라오면 화면 위로 올라가는거 보여줌
        self.view.frame.origin.y = -70
        
    }
    @objc func keyboardWillDisAppear(_ sender: NotificationCenter){
        self.view.frame.origin.y = 0
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        // 사용자가 입력 한 데이터 가져오기
        let title = tfTitle.text?.trimmingCharacters(in: .whitespaces)
        let content = tfContent.text?.trimmingCharacters(in: .whitespaces)
        
        let update = UpdateModel()
        let result = update.updateItems(code: receiveCode, title: title!, content: content!, image: fileName)
        
        if result{
            let resultAlert = UIAlertController(title: "결과", message: "수정 되었습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }
        
    }
    
    
    
    
}//PSA_DetailViewController



extension PSA_DetailViewController: UIPickerViewDataSource{
    //pickerView의 컬럼 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //pickerView의 로우 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageFileName.count
    }
}

extension PSA_DetailViewController: UIPickerViewDelegate{ //ViewController에 UIPickerViewDelegate를 줄거야
    ////    pickerView에 파일명 보여주기
    //        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //            return imageFileName[row]
    //        }
    
    
    //pickerView에 썸네일처럼 이미지로 보여주기
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(image: imageArray[row]) //썸네일에 넣을 사이즈만들려고 바꾸는거
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return imageView
        
    }
    
    //pickerView의 행높이 간격두기
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        selectedImage = imageArray[row]
        imageView.image = imageArray[row]
        fileName = imageFileName[row]
    }
    
    
    
    
}
