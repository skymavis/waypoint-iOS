import Foundation

public struct Utils {
    /// Handles a deep link and extracts relevant information from it.
    /// - Parameter deeplink: The deep link URL as a string.
    /// - Returns: A `Response` object containing the extracted information from the deep link.
    public static func parseDeepLink(deeplink : String) -> Response {
        guard let url = URL(string : deeplink) else {
            return Response(success: false, method: nil, data: nil, address: nil, state: nil)
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        var queryParams = [String: String]()
        
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                queryParams[queryItem.name] = queryItem.value
            }
        }
        let isSuccess = queryParams["type"] == "success"
        let method = queryParams["method"]
        let data = queryParams["data"]
        let state = queryParams["state"]
        let address = queryParams["address"]
        return Response(success: isSuccess, method: method, data: data, address: address, state: state)
    }
    
    public static func getDeepLinkScheme(deepLink: String) -> String {
        guard let url = URL(string: deepLink), let scheme = url.scheme else {
            return ""
        }
        return scheme
    }
    
    public static func generateRandomState() -> String {
        return NSUUID().uuidString.lowercased();
    }
}
