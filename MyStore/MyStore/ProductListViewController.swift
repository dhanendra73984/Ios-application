//
//  ProductListViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 18/07/23.
//

import UIKit
import Alamofire

class ProductListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Products"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadProducts))
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProducts()
    }
    
    @objc func loadProducts() {
        let url = createUrl(path: "/product/")
        let request = AF.request(url, method: .get)
        request.response(completionHandler: { response in
            switch response.result {
            case let .success(data):
                let result = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
                if result["status"] as! String == "success" {
                    
                    // clear the existing list of products
                    self.products.removeAll()
                    
                    // get all products
                    let tmpProducts = result["data"] as! [[String: Any]]
                    for item in tmpProducts {
                        // create an object of Product
                        let product = Product()
                        
                        // parse the data and set the values
                        product.id = item["id"] as? Int
                        product.title = item["title"] as? String
                        product.description = item["description"] as? String
                        product.price = item["price"] as? String
                        product.company = item["company"] as? String
                        product.image = item["image"] as? String
                        
                        // add the product to products array
                        self.products.append(product)
                    }
                    
                    // reload data once you get all the products
                    self.tableView.reloadData()
                    
                } else {
                    self.showError(message: "Error while getting list of products")
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let product = products[indexPath.row]
        cell.textLabel?.text = product.title
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = products[indexPath.row]
        
        // launch details view controller
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        
        vc.productId = product.id
        vc.price = product.price
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
