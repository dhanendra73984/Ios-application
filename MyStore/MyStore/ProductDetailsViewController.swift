//
//  ProductDetailsViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 18/07/23.
//

import UIKit
import Alamofire

class ProductDetailsViewController: BaseViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textDescriptin: UITextView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    
    var productId: Int!
    var price: String!
    
    //TODO: remove this hardcoded id
    let userId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Details"
        let image = UIImage(named: "cart.png")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(addToCart))
    }
    
    @objc func addToCart() {
        let url = createUrl(path: "/cart/\(userId)")
        let body: [String: Any] = [
            "productId": productId!,
            "quantity": 1,
            "price": price!
        ]
        
        let request = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
        
        request.response(completionHandler: {response in
            
            switch response.result {
            case let .success(data):
                let result = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
                if result["status"] as! String == "success" {
                    self.showSuccess(message: "Successfully added this product to your cart")
                }
            case let .failure(error):
                self.showError(message: "error while adding product to cart")
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProductDetails()
    }
    

    func loadProductDetails() {
        let url = createUrl(path: "/product/\(productId!)")
        let request = AF.request(url, method: .get)
        request.response(completionHandler: {response in
            
            switch response.result {
            case let .success(data):
                
                let result = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
                
                if result["status"] as! String == "success" {
                    
                    let product = result["data"] as! [String: Any]
                    
                    self.labelTitle.text = product["title"] as? String
                    self.textDescriptin.text = product["description"] as? String
                    self.labelCompany.text = product["company"] as? String
                    self.labelPrice.text = product["price"] as? String
                    
                    let image = product["image"] as! String
                    loadImage(imageName: image, imageView: self.imageView)
                    
                } else {
                    self.showError(message: "Error while loading product details")
                }
                
                
            case let .failure(error):
                self.showError(message: "Error while loading product details")
            }
            
        })
    }
}
