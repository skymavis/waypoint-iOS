import Foundation

struct ServicePaths {
    static let authorize = "authorize"
    static let register = "register"
    static let send = "send"
    static let sign = "sign"
    static let call = "call"
    static let guests = "guests"
    static let client = "client"
    static let wallet = "wallet"
    static let seamless = "seamless"
    static let start = "start"
}

struct RequestParams {
    static let state = "state"
    static let scope = "scope"
    static let redirect = "redirect"
    static let clientId = "clientId"
    static let chainId = "chainId"
    static let to = "to"
    static let data = "data"
    static let value = "value"
    static let typedData = "typedData"
    static let message = "message"
    static let expectAddress = "expectAddress"
    static let credential = "credential"
    static let authDate = "authDate"
    static let hash = "hash"
}
