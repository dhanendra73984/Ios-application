//
//  config.swift
//  MyStore
//
//  Created by Amit Kulkarni on 17/07/23.
//

import Foundation

let BASE_URL = "http://192.168.165.136:4000"

func createUrl(path: String) -> String {
    return "\(BASE_URL)\(path)"
}
