import Foundation
import SafariServices

public class Waypoint {
    var waypointOrigin : String
    var clientId : String
    var chainRpc : String
    var chainId : Int
    
    public init(waypointOrigin: String, clientId: String, chainRpc: String, chainId: Int) {
        self.waypointOrigin = waypointOrigin
        self.clientId = clientId
        self.chainRpc = chainRpc
        self.chainId = chainId
    }
    
    
    private func request(from viewController: UIViewController, redirect : String, request: Request) async -> String {
        var urlString = waypointOrigin
        
        switch request.method {
        case "authorize":
            urlString += "/client/\(clientId)/authorize"
        case "send":
            urlString += "/wallet/send"
        case "sign":
            urlString += "/wallet/sign"
        case "call":
            urlString += "/wallet/call"
        default:
            break
        }
        
        // Append parameters as query string
        var components = URLComponents(string: urlString)!
        components.queryItems = request.params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            return ""
        }
        
        let webSession = CustomTab()
        
        let callbackScheme = Utils.getDeepLinkScheme(deepLink: redirect)
        
        var result : String = ""
        
        do {
            let callbackURL = try await webSession.startSession(url: url, callbackURLScheme: callbackScheme)
            DispatchQueue.main.async {
                if(UIApplication.shared.canOpenURL(callbackURL)) {
                    UIApplication.shared.open(callbackURL)
                }
            }
            result = callbackURL.absoluteString
            
        } catch let error as CustomTabError {
            DispatchQueue.main.async {
                print("Authentication failed with error: \(error.message), code: \(error.code)")
            }
        } catch {
            DispatchQueue.main.async {
                print("Authentication failed with an unknown error")
            }
            
        }
        return result
    }
    
    public func authorize(from viewController: UIViewController, state : String, redirect: String) async -> String {
        let params = ["state": state, "redirect": redirect]
        let req = Request(method: "authorize", params: params)
        return await self.request(from: viewController, redirect: redirect,  request: req)
    }
    
    public func sendTransaction(from viewController: UIViewController,state : String, redirect: String, from: String? = nil, to: String, value: String) async -> String {
        var params = [
            "clientId": self.clientId,
            "state": state,
            "redirect": redirect,
            "chainId": String(self.chainId),
            "value": value,
            "to": to
        ]
        // Use for multiple wallet
        if (from != nil) {
            params["expectAddress"] = from
        }
        let request = Request(method: "send", params: params)
        return await self.request(from: viewController, redirect: redirect, request: request)
    }
    
    public func callContract(from viewController: UIViewController, state : String, redirect: String, from : String? = nil, contractAddress: String, data: String, value : String? = nil) async -> String  {
        var params = [
            "state": state,
            "redirect": redirect,
            "clientId": self.clientId,
            "chainId": String(self.chainId),
            "to": contractAddress,
            "data": data
        ]
        // If interact with the contract require value
        if(value != nil) {
            params["value"] = value
        }
        // Use for multiple wallet
        if(from != nil) {
            params["expectAddress"] = from
        }
        
        let request = Request(method: "send", params: params)
        return await self.request(from: viewController, redirect: redirect, request: request)
    }
    
    public func personalSign(from viewController: UIViewController, state : String, redirect: String, from: String? = nil, message: String) async -> String {
        var params = ["state": state, "clientId": self.clientId, "message": message, "redirect": redirect]
        // Use for multiple wallet
        
        if(from != nil) {
            params["expectAddress"] = from
        }
        
        let request = Request(method: "sign", params: params)
        return await self.request(from: viewController, redirect: redirect, request: request)
        
    }
    
    public func signTypedData(from viewController: UIViewController, state : String, redirect: String, from: String? = nil, typedData: String) async -> String {
        var params = ["state": state, "clientId": self.clientId, "redirect": redirect, "typedData": typedData]
        // Use for multiple wallet
        if(from != nil) {
            params["expectAddress"] = from
        }
        let request = Request(method: "sign", params: params)
        return await self.request(from: viewController, redirect: redirect, request: request)
    }
}
