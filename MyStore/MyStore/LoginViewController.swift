//
//  LoginViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 17/07/23.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Login"
    }

    @IBAction func onRememberme(_ sender: Any) {
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        let email = editEmail.text!
        let password = editPassword.text!
        
        if email.count == 0 {
            showWarning(message: "email is mandatory")
        } else if password.count == 0 {
            showWarning(message: "password is mandatory")
        } else {
            
            // create url
            let url = createUrl(path: "/user/login")
            
            // create request body
            let body = [
                "email": email,
                "password": password
            ]
            
            // create a reqeust
            let request = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
            
            // send the request and get the response
            request.response(completionHandler: { response in
                
                // check if the response is success or failure
                switch response.result {
                    
                    // the response is success and data is giving the actual response (sent by server)
                    case let .success(data):
                        if let data = data {
                            
                            // convert the data to dictionary which will have the keys from JSON object
                            // because the server is always going to send JSON formatted response the JSON conversion will never fail
                            // so instead of getting Optional Dictionary using try! we are getting valid Dictionary
                            let result = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
                            
                            // check the status
                            if result["status"] as! String == "success" {
                                // self.showSuccess(message: "Welcome to the application")
                                
                                // capture the logged in user's info
                                let info = result["data"] as! [String: Any]
                                let id = info["id"] as! Int
                                let name = info["name"] as! String
                                let mobile = info["mobile"] as! String
                                
                                // persist the user information using UserDefaults
                                let userDefaults = UserDefaults.standard
                                userDefaults.setValue(id, forKey: "id")
                                userDefaults.setValue(name, forKey: "name")
                                userDefaults.setValue(mobile, forKey: "mobile")
                                userDefaults.setValue(self.editEmail.text!, forKey: "email")
                                userDefaults.set(true, forKey: "loginStatus")
                                
                                // similar apply() in android
                                userDefaults.synchronize()
                                
                                
                                // launch tab bar
                                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                                
                                sceneDelegate.launchAuthencatedUserWorkflow()
                                
                            } else {
                                self.showError(message: "Invalid user name or password")
                            }
                            
                        }
                    
                    
                    // the response is failure and error is giving the actual error
                    case let .failure(error):
                        print(error)
                }
                
            })
        }
        
    }
}
