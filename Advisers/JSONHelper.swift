//
//  JSONHelper.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/20.
//

import Foundation

struct JSONHelper {
}

extension Dictionary {
    
    func toJSON() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
}
