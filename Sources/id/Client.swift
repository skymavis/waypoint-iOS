import Foundation
import SafariServices

public class Client {
    var idOrigin : String
    var clientId : String
    var chainRpc : String
    var chainId : Int
    
    public init(idOrigin: String, clientId: String, chainRpc: String, chainId: Int) {
        self.idOrigin = idOrigin
        self.clientId = clientId
        self.chainRpc = chainRpc
        self.chainId = chainId
    }
    
    
    private func send(from viewController: UIViewController, redirect : String, request: Request) async -> String {
        var urlString = idOrigin
        
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
        return await self.send(from: viewController, redirect: redirect,  request: req)
    }
    
    public func sendTransaction(from viewController: UIViewController, state : String, redirect: String, to: String, value: String) async -> String {
        let params = [
            "clientId": self.clientId,
            "state": state,
            "redirect": redirect,
            "chainId": String(self.chainId),
            "value": value,
            "to": to
        ]
        let request = Request(method: "send", params: params)
        return await self.send(from: viewController, redirect: redirect, request: request)
        
    }
    
    public func callContract(from viewController: UIViewController, state : String, redirect: String, contractAddress: String, data: String, value : String? = nil) async -> String  {
        var params = [
            "state": state,
            "redirect": redirect,
            "clientId": self.clientId,
            "chainId": String(self.chainId),
            "to": contractAddress,
            "data": data
        ]
        if(value != nil) {
            params["value"] = value
        }
        
        let request = Request(method: "send", params: params)
        return await self.send(from: viewController, redirect: redirect, request: request)
    }
    
    public func personalSign(from viewController: UIViewController, state : String, redirect: String, message: String) async -> String {
        let params = ["state": state, "clientId": self.clientId, "message": message, "redirect": redirect]
        let request = Request(method: "sign", params: params)
        
        return await self.send(from: viewController, redirect: redirect, request: request)
        
    }
    
    public func signTypeData(from viewController: UIViewController, state : String, redirect: String, typedData: String) async -> String {
        let params = ["state": state, "clientId": self.clientId, "redirect": redirect, "typedData": typedData]
        let request = Request(method: "sign", params: params)
        return await self.send(from: viewController, redirect: redirect, request: request)
    }
}
