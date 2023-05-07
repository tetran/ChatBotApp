//
//  ApiResponse.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

struct APIResponse {
    let statusCode: Int
    let headers: [String: String]
    let body: Data
}
