//
//  LJU_UpdateViewController.swift
//  TodoList_FireBase
//
//  Created by 이종욱 on 2023/08/27.
//

import UIKit
import PhotosUI // 앨범

class LJU_UpdateViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!     // Select Icon List
    @IBOutlet var tfTitle: UITextField!                 // Title Text Field
    @IBOutlet var tfTodo: UITextField!                  // Todo Text Field
    @IBOutlet var swPrivate: UISwitch!                  // PreivateStatus switch
    @IBOutlet var swTodoComplete: UISwitch!             // TodoCompleteStatus switch
    @IBOutlet var imgPreview: UIImageView!              // Preview Image View
    @IBOutlet var lblTitlePreview: UILabel!             // Preview Title Label
    @IBOutlet var lblTodoPreview: UILabel!              // Preview Todo Label
    @IBOutlet var lblTitleCount: UILabel!               // Title Text Count
    @IBOutlet var lblTodoCount: UILabel!                // Toodo Text Count
    
    var itemProviders: [NSItemProvider] = []            // 앨범이미지 담기
    var collectionImageList: [String] = []              // Select Icon List 담기
    var imageUrl: URL?                                  // URL 담기
    var otherImageCheck: Bool = false                   // 이미지가 앨범선택인지 컬렉션리스트선택 인지 체크
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // 처음 앞화면에서 가져온 데이터 넣기
        receiveDataSet()
        // 키보드위치에 따른 화면이동
        setKeyboardEvent()
        // Select Icon에 뿌려줄 이미지 가져오는 protocol 연결
        let collectionImage = LJU_CollectionImageCall()
        collectionImage.delegate = self
        collectionImage.imageUrlDownload()
        // CollectionView Delegate 연결
        collectionView.dataSource = self
        collectionView.delegate = self
        // TextFeild Delegate 연결
        tfTitle.delegate = self
        tfTodo.delegate = self
    
        // Do any additional setup after loading the view.
    }
    
    // update화면 시작시 앞화면에서 가져온 todo 데이터 넣기
    func receiveDataSet(){
        
        let message = LJU_Message.self
        
        
        lblTitlePreview.text = message.title
        lblTodoPreview.text = message.todo
        tfTitle.text = message.title
        tfTodo.text = message.todo
        swTodoComplete.isOn = message.todoStatus!
        swPrivate.isOn = message.privateStatus!
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/semitodolist.appspot.com/o/cart.png?alt=media&token=0771cc04-e718-4573-88df-57b7fc885c7f")
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!){
                DispatchQueue.main.async {
                    self.imgPreview.image = UIImage(data: data)
                }
            }else{
                    print("이미지불러오기실패")
                }
        }
        
    }
    
    
    @IBAction func swPrivateStatus(_ sender: UISwitch) {
        swPrivate.isOn = sender.isOn
    }
    @IBAction func swTodoStatus(_ sender: UISwitch) {
        swTodoComplete.isOn = sender.isOn
        
    }
    
    
    
    @IBAction func btnOtherImage(_ sender: UIButton) {
        // 앨범띄우기 함수
        presentPicker()
    }
    
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        
        
        callAlert(alert_title: "Check", alert_Message: "Are you sure you want to apply the changes?", tfName: "update", btn: 2)
    }
    
    func updateAction(){
        
        // UpdateModel 연결
        let updateDB = LJU_UpdateModel()
        
        // preview text 체크
        
        guard let titleText = lblTitlePreview.text else {return}
        guard let todoText = lblTodoPreview.text else {return}
        
        // Nil Check and InsertDataBase
        if titleText.trimmingCharacters(in: .whitespaces).isEmpty{
            callAlert(alert_title: "Error", alert_Message: "Plase Enter Title",tfName: "title",btn: 1)
        }else if(todoText.trimmingCharacters(in: .whitespaces).isEmpty){
            callAlert(alert_title: "Error", alert_Message: "Plase Enter Todo",tfName: "todo",btn: 1)
        }else{
            // 이미지 앨범에서 선택시
            if otherImageCheck{
                // 이미지업로드
                let imageData = self.imgPreview.image?.pngData()
                let upload = LJU_ImageUpload()
                upload.imageUpload(image: imageData!, titleText: titleText, todoText: todoText)
                
            }else{
                // 이미지의 URL을 String으로 바꾸기
                //let image:String  = imageUrl!.absoluteString
                let image:String = "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png"

                updateDB.updateItems(DocumentId: LJU_Message.documentId!, image: image, title: titleText, todo: todoText, todoStatus: swTodoComplete.isOn, privateStatus: swPrivate.isOn)

            }
           

            

        }
        
        callAlert(alert_title: "Update Complete", alert_Message: "Your todo has been Update", tfName: "add",btn: 1)
        
        
    }
    
    
    
    // Alert 띄우기
    func callAlert(alert_title:String, alert_Message: String, tfName: String,btn: Int){
        
        let alert = UIAlertController(title: alert_title, message: alert_Message, preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Ok", style: .default,handler: { [self]
            ACTION in
            switch tfName{
            case "title": self.tfTitle.becomeFirstResponder()
            case "add" : self.navigationController?.popViewController(animated: true)
            case "update" : self.updateAction()
            default: self.tfTodo.becomeFirstResponder()
                
            }
            
            
        } )
        
        if btn==2{
            let no = UIAlertAction(title: "Cancel", style: .cancel)
            
            no.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(no)
        }
        
        alert.addAction(yes)
        present(alert, animated: true)
    } // func callAlert End-
 
    // 앨범띄우기
    func presentPicker() {
        
        // PHPickerConfiguration 생성 및 정의
        var config = PHPickerConfiguration()
        
        // 라이브러리에서 보여줄 Assets을 필터를 한다. (기본값: 이미지, 비디오, 라이브포토)
        config.filter = .images
        
        // 다중 선택 갯수 설정 (0 = 무제한)
        config.selectionLimit = 1
        
        // 컨트롤러 연결
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        // 앨범띄우기
        self.present(imagePicker, animated: true)
        
    } // func presentPicker() End-

    // 앨범선택사진 img에 띄우기
    func addPreviewImage(){
        
        // 이미지가 앨범인지 컬렉션리스트인지 체크
        otherImageCheck = true
        
        // 사진이 한 개이므로 first로 접근하여 itemProvider를 생성
        guard let itemProvider = itemProviders.first else { return }
        
        // 만약 itemProvider에서 UIImage로 로드가 가능하다면?
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
        // 로드 핸들러를 통해 UIImage를 처리해 줍시다.
        itemProvider.loadObject(ofClass: UIImage.self) {
            [weak self] image, error in
                
            guard let self = self,
            let image = image as? UIImage else { return }
            
        // loadObject가 비동기적으로 처리되기 때문에 UI 업데이트를 위해 메인쓰레드로 변경
        DispatchQueue.main.async {
            self.imgPreview.image = image
        
                }
            }
        }
    } // func addPreviewImage() End-
    
    
    // 키보드 외부 클릭시 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    // 키보드에 따른 화면옮기기
    func setKeyboardEvent(){
            // 키보드가 생성될때
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
            // 키보드가 사라질때
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        
        }
        
        @objc func keyboardWillAppear(_ sender: NotificationCenter){
            // 본인의 뷰의 틀의 원본의 Y값 = -150
            self.view.frame.origin.y = -220
        }

        @objc func keyboardWillDisappear(_ sender:NotificationCenter){
            self.view.frame.origin.y = 0
        }
    // 키보드에 따른 화면 옮기기 끗
    
}


// 앨범
extension LJU_UpdateViewController: PHPickerViewControllerDelegate{

        // picker가 종료되면 동작 함
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // picker가 선택이 완료되면 화면 내리기
            picker.dismiss(animated: true)
            
            // 만들어준 itemProviders에 Picker로 선택한 이미지정보를 전달
            itemProviders = results.map(\.itemProvider)
            
            // 앨범에서 이미지 선택시 imgview에 보이기
            if !itemProviders.isEmpty {
                        addPreviewImage()
                    }
        }
} // 앨범끗

extension LJU_UpdateViewController: LJU_ImageDownProtocol{
    func imagesDownLoaded(images: URL) {
        
 
        DispatchQueue.global().async {
           let data = try? Data(contentsOf: images)
            
            DispatchQueue.main.async {
                self.imgPreview.image = UIImage(data: data!)
                
            }
        }
    }
    
 
}

// CollectionViewDataSource
extension LJU_UpdateViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    // Cell 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImageList.count
    }
    // cell 구성, 이미지 넣기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionMyCell", for: indexPath) as! LJU_UpdateCollectionViewCell
                
        let url = URL(string: collectionImageList[indexPath.row])
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!){
                DispatchQueue.main.async {
                    cell.updateCollectionImage.image = UIImage(data: data)
                }
            }else{
                print("add이미지 실패")
            }

        }
                return cell
    }
    // CollectionView 클릭 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: collectionImageList[indexPath.row])
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.imgPreview.image = UIImage(data: data!)    // 이미지 preview에 넣기
                self.imageUrl = url                             // 이미지 URL 복사해두기
                self.otherImageCheck = false                    // 이미지가 앨범인지 컬렉션리스트인지 체크
            }
        }
        }
    
    
} // CollectionViewDataSource, UICollectionViewDelegate End-

// 컬렉션 이미지 불러오기
extension LJU_UpdateViewController:LJU_CollectionImageCallProtocol{
    func imageUrlPath(urlPath: [String]) {
        collectionImageList = urlPath
        self.collectionView.reloadData()
    }
    
    
}

// 텍스트필드 return시 preview에 글넣어주기
extension LJU_UpdateViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 20글자이상 막기
        if textField.text!.count > 20 {
            self.callAlert(alert_title: "Sorry", alert_Message: "Text cannot exceed 20 characters",tfName: "titleText20",btn: 1)
        }else{
            if textField == tfTitle{ // Title
                
                self.lblTitlePreview.text = tfTitle.text
                
            }else{ // Todo
                
                self.lblTodoPreview.text = tfTodo.text
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == tfTitle{
            self.lblTitleCount.text = "(\(String(describing: textField.text!.count))/20)"
        }else{
            self.lblTodoCount.text = "(\(String(describing: textField.text!.count))/20)"
        }
        
        
        if textField.text!.count > 20{
            textField.textColor = .red
        }else{
            textField.textColor = .black
        }
    }
    
}


