//
//  WookAddViewController.swift
//  Semi_SQLite_Todo
//
//  Created by WOOKHYUN on 2023/08/26.
//

import UIKit

class WookAddViewController: UIViewController {

    
    @IBOutlet weak var tfTitle: UITextField!
    
    @IBOutlet weak var tfContent: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    
    var selectedImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    

    @IBAction func btnInsert(_ sender: UIButton) {
        
        insertImage(selectedImage!)
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnAlbum(_ sender: UIButton) {
        enrollAlertEvent()
    }
    
    
    // Mark : - function
    func enrollAlertEvent() {
        
        let alertController = UIAlertController(title: "앨범", message: "선택", preferredStyle: .alert)
        
            let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
                (action) in
                self.openAlbum()
            }
            let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(photoLibraryAlertAction)
            alertController.addAction(cancelAlertAction)
        
            present(alertController, animated: true)
    }
    
    
    
    
    func openAlbum() {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true)
    }
    
    
    func insertImage(_ image : UIImage){
        let database_Handler = DataBase_Handler_Wook()
        
        guard let title = tfTitle.text?.trimmingCharacters(in: .whitespaces) else {return}
        guard let content = tfContent.text?.trimmingCharacters(in: .whitespaces) else {return}
        
        let changer = ImageTypeChanger()
        
        let imageData = changer.uiImageToData(image: image) //UIImage -> Data
           
        
        database_Handler.insertAction(title, content, imageData)
    }

} // WookAddViewController


// image tap gesture
extension WookAddViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        
        imgView.image = selectedImage
        self.selectedImage = selectedImage
        dismiss(animated: true)
    }
    
}
