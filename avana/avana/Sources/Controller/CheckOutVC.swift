//
//  CheckOutVC.swift
//  avana
//
//  Created by Sarath NS on 07/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit

class CheckOutVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var paymentProofImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var uploadPaymentProofButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var product : Product? = nil
    var isPaymentProofUploaded = false
    
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        uploadPaymentProofButton.layer.cornerRadius = uploadPaymentProofButton.frame.size.height / 2
    }
    
    //MARK:- Action Methods -

    @IBAction func submitAction(_ sender: Any) {
        if isPaymentProofUploaded {
            if let image = paymentProofImageView.image {
                let base64String = self.convertImageToBase64(image: image)
                DataManager.shared.uploadBill(dataString: base64String)
                let alert = UIAlertController(title: "Hurray", message: "Order placed successfully", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "Please upload payment proof to continue", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadPaymentProofAction(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    //MARK:- Custom Methods -

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have perission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- ImagePicker delegate -
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            paymentProofImageView.image = image
            isPaymentProofUploaded = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }


}
