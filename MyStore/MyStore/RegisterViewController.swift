//
//  RegisterViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 17/07/23.
//

import UIKit
import Alamofire

class RegisterViewController: BaseViewController {

    @IBOutlet weak var editPhone: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    @IBOutlet weak var editFirstName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Register"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(onRegister))
    }
    
    @objc func onRegister() {
        let firstName = editFirstName.text!
        let lastName = editLastName.text!
        let email = editEmail.text!
        let password = editPassword.text!
        let phone = editPhone.text!
        
        if firstName.count == 0 {
            showWarning(message: "first name is mandatory")
        } else if lastName.count == 0 {
            showWarning(message: "last name is mandatory")
        } else if email.count == 0 {
            showWarning(message: "email is mandatory")
        } else if password.count == 0 {
            showWarning(message: "password is mandatory")
        } else if phone.count == 0 {
            showWarning(message: "phone number is mandatory")
        } else {
            
            // create the request body
            let body = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "password": password,
                "mobile": phone
            ]
            
            // create the url
            let url = createUrl(path: "/user/register")
        
            // create a request
            let request = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
            
            // call the api and get the response
            request.response(completionHandler: { response in
                
                switch response.result {
                case let .success(data):
                    self.showSuccess(message: "Successfully registered a new user")
                    self.navigationController?.popViewController(animated: true)
                case let .failure(error):
                    self.showError(message: "Error while registering a user")
                    
                }
                
            })
        }
        
    }

}
