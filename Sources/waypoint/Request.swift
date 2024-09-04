import Foundation

class Request {
    var method: String
    var params: [String: String]

    init(method: String, params: [String: String]) {
        self.method = method
        self.params = params
    }
}
