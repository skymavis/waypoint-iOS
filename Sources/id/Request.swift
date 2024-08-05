//
//  Request.swift
//  id
//
//  Created by Thien Nguyen on 27/03/2024.
//

import Foundation

class Request {
    var method: String
    var params: [String: String]

    init(method: String, params: [String: String]) {
        self.method = method
        self.params = params
    }
}

