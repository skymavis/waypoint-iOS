import Foundation
import SafariServices

class Request {
    private let endpoint: String
    private let redirectUri: String
    private let params: [String: String]

    init(endpoint: String, redirectUri: String, params: [String: String?] = [:]) {
        self.endpoint = endpoint
        self.redirectUri = redirectUri
        self.params = params.compactMapValues { $0 }
    }

    private func constructURLWithParams(for urlString: String, with params: [String: String]) -> URL? {
        guard var components = URLComponents(string: urlString) else { return nil }
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }

    private func handleCustomTabError(error: CustomTabError, callbackScheme: String) -> String {
        guard let errorCallbackUrl = constructURLWithParams(for: callbackScheme, with: [
            "state": params["state"] ?? "",
            "type": "fail",
            "message": error.message,
            "code": String(error.code)
        ]) else { return "" }
        return errorCallbackUrl.absoluteString
    }

    public func execute() async -> String {
        guard let url = constructURLWithParams(for: endpoint, with: params) else { return "" }
        let webSession = CustomTab()
        let callbackScheme = URL(string: redirectUri)?.scheme ?? ""

        do {
            let callbackURL = try await webSession.startSession(url: url, callbackURLScheme: callbackScheme)
            if await UIApplication.shared.canOpenURL(callbackURL) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(callbackURL)
                }
            }
            return callbackURL.absoluteString
        } catch let error as CustomTabError {
            return handleCustomTabError(error: error, callbackScheme: redirectUri)
        } catch {
            print("Execute request failed with an unknown error")
            return ""
        }
    }
}
