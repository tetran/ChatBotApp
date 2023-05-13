//
//  ApiRequest.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

struct APIRequest {
    
    let url: String
    
    let method: String
    
    let headers: [String: String]?
    
    let body: Data?
    
    init(url: String, method: String, headers: [String : String]?, body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}
