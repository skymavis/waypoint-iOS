import Foundation

struct Request {
    let method: String
    let params: [String: String]

    init(method: String, params: [String: String] = [:]) {
        self.method = method
        self.params = params
    }
}
