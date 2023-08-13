//
//  commonFunctions.swift
//  MyStore
//
//  Created by Amit Kulkarni on 18/07/23.
//

import Foundation
import Alamofire
import UIKit

func loadImage(imageName: String, imageView: UIImageView) {
    let url = createUrl(path: "/\(imageName)")
    let request = AF.request(url, method: .get)
    request.response(completionHandler: {response in
        switch response.result {
        case let .success(data):
            
            // convert the response to the UIImage
            let image = UIImage(data: data!)
            
            // render the image into image View
            imageView.image = image
            
        case let .failure(error):
            print(error)
        }
    })
}
