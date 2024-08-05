import Foundation

public class Response {
    private var success: Bool?
    private var method: String?
    private var data: String?
    private var address: String?
    private var state: String?
    
    init(success: Bool? = nil, method: String? = nil, data: String? = nil, address: String? = nil, state: String? = nil) {
        self.success = success
        self.method = method
        self.data = data
        self.address = address
        self.state = state
    }
    
    public func getSuccess() -> Bool? {
        return success
    }
    
    public func setSuccess(_ success: Bool?) {
        self.success = success
    }
    
    public func getMethod() -> String? {
        return method
    }
    
    public func setMethod(_ method: String?) {
        self.method = method
    }
    
    public func getData() -> String? {
        return data
    }
    
    public func setData(_ data: String?) {
        self.data = data
    }
    
    public func getAddress() -> String? {
        return address
    }
    
    public func setAddress(_ address: String?) {
        self.address = address
    }
    
    public func getState() -> String? {
        return state
    }
    
    public func setState(_ state: String?) {
        self.state = state
    }
}
