//
//  OnboardVC.swift
//  avana
//
//  Created by Sarath NS on 06/10/18.
//  Copyright © 2018 Sarath NS. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import FacebookCore

class OnboardVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var facebookSignInButton: LoginButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var facebookDataDictionary : [String : AnyObject]?
    
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
    
    func setupUI() {
        facebookSignInButton.layer.cornerRadius = facebookSignInButton.frame.size.height / 2
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        emailTF.delegate = self
        passwordTF.delegate = self
        self.hideKeyboard()
    }
    
    func validateData() -> Bool {
        var isDataValid = true
        
        let title = "Oops.."
        var message = "Please enter valid data"
        
        if (emailTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter email Id"
        } else if (passwordTF.text?.isEmpty)! {
            isDataValid = false
            message = "Please enter password"
        }
        else if !(emailTF.text?.isValidEmail())! {
            isDataValid = false
            message = "Invalid email address"
        }
        
        if !isDataValid {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return isDataValid
    }
    
    //MARK:- Action Methods -
    
    @IBAction func loginAction(_ sender: Any) {
        if validateData() {
            view.endEditing(true)
            if let email = emailTF.text, let password = passwordTF.text {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Oops", message: "Somethig went wrong", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        ViewManager.shared.showProductList(fbData: self.facebookDataDictionary, on: self, modal: true, animated: true)
                    }
                }
            }
        }
    }

    @IBAction func signInWithFacebook(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.email, .publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! -> \(accessToken)")
                print(declinedPermissions)
                print(grantedPermissions)
                let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"first_name,email"], accessToken: accessToken, httpMethod: .GET)
                graphRequest.start({ (response, result) in
                    switch result {
                    case .failed(let error):
                        print(error)
                    case .success(let result):
                        if let data = result.dictionaryValue as [String : AnyObject]? {
                            self.facebookDataDictionary = data
                        }
                    }
                })
                self.loginFireBase()
            }
        }
    }
    
    func loginFireBase() {
        let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if error != nil {
                let alert = UIAlertController(title: "Oops", message: "Somethig went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                ViewManager.shared.showProductList(fbData: self.facebookDataDictionary, on: self, modal: true, animated: true)
            }
        }
    }
    
    //MARK:- UITextField Delegate Methods -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTF {
            textField.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            textField.resignFirstResponder()
        }
        return true
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
