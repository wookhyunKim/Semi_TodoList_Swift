//
//  PSA_AddViewController.swift
//  SemiTodoList
//
//  Created by ⠀ᙏ̤̫ ⠀ on 2023/08/27.
//

import UIKit

class PSA_AddViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfAddTitle: UITextField!
    @IBOutlet weak var tfAddContent: UITextField!
    
    
    
    let imagePickerController = UIImagePickerController()
    var selectedImage :UIImage?
    
    //var fileName : NSData? = nil
    var fileName : String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        setKeyboardEvent()

        // Do any additional setup after loading the view.
    }
    
    

    // 데이터 넣기
      func tempInsert(){
          
          // 사용자가 입력 한 데이터 가져오기
        
          let title = tfAddTitle.text?.trimmingCharacters(in: .whitespaces)
          let content = tfAddContent.text?.trimmingCharacters(in: .whitespaces)
          
          
       
          let insertModel = InsertModel()
          let result = insertModel.insertItems(title: title!, content: content!, image: fileName )
          
          if result{
              let resultAlert = UIAlertController(title: "결과", message: "입력 되었습니다.", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "네, 알겠습니다", style: .default, handler: {ACTION in
                  self.navigationController?.popViewController(animated: true)
              })

              resultAlert.addAction(okAction)
              present(resultAlert, animated: true)
          }else{
              let resultAlert = UIAlertController(title: "결과", message: "입력을 실패했습니다.", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "다시 시도해주세요", style: .default)

              resultAlert.addAction(okAction)
              present(resultAlert, animated: true)
          }
          

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
    @objc func keyboardWillAppear(_ sender: NotificationCenter){ 
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
    
    
    @IBAction func btnChoice(_ sender: UIButton) {
        enrollAlertEvent()
        
    }
    
    
    @IBAction func btnInsert(_ sender: UIButton) {
        tempInsert()
    }
    
    func enrollAlertEvent() {
          
          let alertController = UIAlertController(title: "사진을", message: "선택해 주세요.", preferredStyle: .alert)
          
              let photoLibraryAlertAction = UIAlertAction(title: "사진 선택", style: .default) {
                  (action) in
                  self.openAlbum()
              }
              let cancelAlertAction = UIAlertAction(title: "취소", style: .destructive)
              alertController.addAction(photoLibraryAlertAction)
              alertController.addAction(cancelAlertAction)
          
              present(alertController, animated: true)
      }
  

      
      func openAlbum() {
              imagePickerController.sourceType = .photoLibrary
              present(imagePickerController, animated: false)
      }
    
    // URL Session
    
    

}//END


// image tap gesture
extension PSA_AddViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // let the user pick media from his photo library
        //let imagePickerController = UIImagePickerController()
        
        // Allows to picked photos
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
        
        //
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following : \(info)")
        }
        
        imageView.image = selectedImage
        self.selectedImage = selectedImage
        // 이미지의 URL 가져오기
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let imageName = imageURL.lastPathComponent
                self.fileName = imageName
                print("선택된 이미지의 파일 이름: \(imageName)")
            }

        dismiss(animated: true)
    }
    
}
