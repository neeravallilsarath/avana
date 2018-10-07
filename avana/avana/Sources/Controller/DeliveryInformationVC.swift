//
//  DeliveryInformationVC.swift
//  avana
//
//  Created by Sarath NS on 07/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit

class DeliveryInformationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var flatNoTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var localityTF: UITextField!
    @IBOutlet weak var landMarkTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    var product : Product? = nil
    
    //MARK:- View Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Custom Methods -
    
    func setupUI() {
        self.title = "Delivery Details"
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        nameTF.becomeFirstResponder()
        nameTF.delegate         = self
        mobileNumberTF.delegate = self
        flatNoTF.delegate       = self
        cityTF.delegate         = self
        localityTF.delegate     = self
        landMarkTF.delegate     = self
        
        if let product = self.product {
            if let facebookData = product.fbData {
                if let name = facebookData["first_name"] {
                    nameTF.text = name as? String
                }
            }
        }
        
        continueButton.layer.cornerRadius = continueButton.frame.size.height / 2
        self.scrollView.keyboardDismissMode = .onDrag
        self.hideKeyboard()
    }
    
    func validateData() -> Bool {
        var isDataValid = true
        
        let title = "Oops.."
        var message = "Please enter valid data"
        
        if (nameTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter name"
        } else if (mobileNumberTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter mobile number"
        }
        else if (flatNoTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter flat no"
        }
        else if (cityTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter city"
        }
        else if (localityTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter locality"
        }
        else if (landMarkTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter landmark"
        }
        
        if !isDataValid {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return isDataValid
    }
    
    //MARK:- UITextField Delegate Methods -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTF {
            textField.resignFirstResponder()
            mobileNumberTF.becomeFirstResponder()
        } else if textField == mobileNumberTF {
            textField.resignFirstResponder()
            flatNoTF.becomeFirstResponder()
        } else if textField == flatNoTF {
            textField.resignFirstResponder()
            cityTF.becomeFirstResponder()
        } else if textField == cityTF {
            textField.resignFirstResponder()
            localityTF.becomeFirstResponder()
        } else if textField == localityTF {
            textField.resignFirstResponder()
            landMarkTF.becomeFirstResponder()
        }
        else if textField == landMarkTF {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK:- Action Methods -

    @IBAction func continueAction(_ sender: Any) {
        if validateData() {
            view.endEditing(true)
            ViewManager.shared.showCheckoutVC(product: product, on:self.navigationController)
        }
    }
    
    //MARK:- Keypad Notification
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}
