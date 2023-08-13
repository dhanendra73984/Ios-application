//
//  ProfileViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 18/07/23.
//

import UIKit
import Alamofire

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // TODO: remove this hardcoding
    let userId = 1

    var email = ""
    var userName = ""
    var profileImage: String? = nil
    var mobile = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProfile()
    }
    
    func loadProfile() {
        // create url
        let url = createUrl(path: "/user/\(userId)")
        let request = AF.request(url, method: .get)
        request.response(completionHandler: {response in
            switch response.result {
            case let .success(data):
                
                let result = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
                
                if result["status"] as! String == "success" {
                    
                    // get the data
                    let info = result["data"] as! [String: Any]
                    self.userName = info["name"] as! String
                    self.mobile = info["mobile"] as! String
                    self.email = info["email"] as! String
                    self.profileImage = info["profileImage"] as? String
                    
                    self.tableView.reloadData()
                    
                } else {
                    self.showError(message: "Error while loading profile")
                }
                
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // profile image
                
                let x = (cell.contentView.frame.width / 2) - 75
                
                let imageView = UIImageView(frame: CGRectMake(x, 25, 150, 150))
                
                if let profileImage = profileImage {
                    loadImage(imageName: profileImage, imageView: imageView)
                }
                imageView.image = UIImage(named: "defaultProfile.png")
                imageView.layer.cornerRadius = 75
                imageView.layer.masksToBounds = true
                
                // add the imageview in the tableview cell
                cell.contentView.addSubview(imageView)
                
            } else if indexPath.row == 1 {
                // user name
                cell.textLabel?.text = userName
                cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
            } else if indexPath.row == 2 {
                // email
                cell.textLabel?.text = email
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
            } else if indexPath.row == 3 {
                // mobile
                cell.textLabel?.text = mobile
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
            }
        } else if indexPath.section == 1 {
           if indexPath.row == 0 {
               cell.textLabel?.text = "My Orders"
               cell.accessoryType = .disclosureIndicator
           } else if indexPath.row == 1 {
               cell.textLabel?.text = "Change Password"
               cell.accessoryType = .disclosureIndicator
           }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Logout"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if (indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3) {
                return 25
            } else if indexPath.row == 0 {
                return 200
            }
        }
        
        return 44
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // change the image by letting user to select from photo library
                
                let alert = UIAlertController(title: "confirmation", message: "select image source", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    
                    // this will allow user to click photo using camera
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: {action in
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
                present(alert, animated: true)
            }
            
        } else if indexPath.section == 1 {
           if indexPath.row == 4 {
               // show my orders screen
           } else if indexPath.row == 5 {
               // show change my password screen
           }
        } else if indexPath.section == 2 {
            let alert = UIAlertController(title: "confirmation", message: "Are you sure to logout from the application?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                
                // remove all the info from user defaults
                let defaults = UserDefaults.standard
                // defaults.removeObject(forKey: "loginStatus")
                // defaults.removeObject(forKey: "name")
                // defaults.removeObject(forKey: "mobile")
                // defaults.removeObject(forKey: "email")
                
                defaults.setValue(false, forKey: "loginStatus")
                defaults.setValue("", forKey: "name")
                defaults.setValue("", forKey: "mobile")
                defaults.setValue("", forKey: "email")
                defaults.setValue("", forKey: "id")
                defaults.synchronize()
                
                // launch login navigation controller
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                
                sceneDelegate.launchLoginWorkflow()
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get the image selected by user
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // upload the image to server
        let url = createUrl(path: "/user/upload-profile-image/\(userId)")
        
        // create a request
        let request = AF.upload(multipartFormData: {formData in
            
            // convert the image to Data (sequence of bytes)
            let data = image.jpegData(compressionQuality: 100)
            print(data!)
            
            // image here is the key which is configured in the API
            formData.append(data!, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")

        }, to: url)
        
        request.response(completionHandler: {response in
            // remove the picker controller
            self.dismiss(animated: true)
            
            // load the profile again
            self.loadProfile()
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
