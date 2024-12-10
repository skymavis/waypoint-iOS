import Foundation
import SafariServices

public class Waypoint {
    private let waypointOrigin: String
    private let clientId: String
    private let chainRpc: String
    private let chainId: Int

    public init(waypointOrigin: String, clientId: String, chainRpc: String, chainId: Int) {
        self.waypointOrigin = waypointOrigin
        self.clientId = clientId
        self.chainRpc = chainRpc
        self.chainId = chainId
    }

    private func constructEndpointURL(for method: String) -> String {
        let path: String

        switch method {
        case ServicePaths.authorize:
            path = "/\(ServicePaths.client)/\(clientId)/\(ServicePaths.authorize)"
        case ServicePaths.send:
            path = "/\(ServicePaths.wallet)/\(ServicePaths.send)"
        case ServicePaths.sign:
            path = "/\(ServicePaths.wallet)/\(ServicePaths.sign)"
        case ServicePaths.call:
            path = "/\(ServicePaths.wallet)/\(ServicePaths.call)"
        case ServicePaths.guests:
            path = "/\(ServicePaths.seamless)/\(ServicePaths.guests)/\(ServicePaths.start)"
        case ServicePaths.register:
            path = "/\(ServicePaths.guests)/\(ServicePaths.register)"
        default:
            path = ""
        }

        return waypointOrigin + path
    }

    private func executeRequest(from viewController: UIViewController, redirect: String, request: Request) async -> String {
        guard var components = URLComponents(string: constructEndpointURL(for: request.method)) else { return "" }
        components.queryItems = request.params.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let finalUrl = components.url else { return "" }

        let webSession = CustomTab()
        let callbackScheme = URL(string: redirect)?.scheme ?? ""

        do {
            let callbackURL = try await webSession.startSession(url: finalUrl, callbackURLScheme: callbackScheme)
            if await UIApplication.shared.canOpenURL(callbackURL) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(callbackURL)
                }
            }
            return callbackURL.absoluteString
        } catch let error as CustomTabError {
            print("Authentication failed with error: \(error.message), code: \(error.code)")
        } catch {
            print("Authentication failed with an unknown error")
        }
        return ""
    }

    private func createParams(state: String, redirect: String, additionalParams: [String: String?] = [:]) -> [String: String] {
        var params = [
            RequestParams.state: state,
            RequestParams.redirect: redirect,
            RequestParams.clientId: clientId,
            RequestParams.chainId: String(chainId)
        ]

        additionalParams.compactMapValues { $0 }.forEach { key, value in
            params[key] = value
        }

        return params
    }

    private func createRequest(for method: String, state: String, redirect: String, additionalParams: [String: String?]) -> Request {
        let params = createParams(state: state, redirect: redirect, additionalParams: additionalParams)
        return Request(method: method, params: params)
    }

    public func authorize(from viewController: UIViewController, state: String, redirect: String, scope: String? = nil) async -> String {
        let request = createRequest(for: ServicePaths.authorize, state: state, redirect: redirect, additionalParams: [RequestParams.scope: scope])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }

    public func personalSign(from viewController: UIViewController, state: String, redirect: String, message: String, from: String? = nil) async -> String {
        let request = createRequest(for: ServicePaths.sign, state: state, redirect: redirect, additionalParams: [
            RequestParams.message: message,
            RequestParams.expectAddress: from
        ])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }

    public func signTypedData(from viewController: UIViewController, state: String, redirect: String, typedData: String, from: String? = nil) async -> String {
        let request = createRequest(for: ServicePaths.sign, state: state, redirect: redirect, additionalParams: [
            RequestParams.typedData: typedData,
            RequestParams.expectAddress: from
        ])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }

    public func sendTransaction(from viewController: UIViewController, state: String, redirect: String, to: String, data: String? = nil, value: String? = nil, from: String? = nil) async -> String {
        let request = createRequest(for: ServicePaths.send, state: state, redirect: redirect, additionalParams: [
            RequestParams.to: to,
            RequestParams.data: data,
            RequestParams.value: value,
            RequestParams.expectAddress: from
        ])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }

    public func sendNativeToken(from viewController: UIViewController, state: String, redirect: String, to: String, value: String, from: String? = nil) async -> String {
        let request = createRequest(for: ServicePaths.send, state: state, redirect: redirect, additionalParams: [
            RequestParams.to: to,
            RequestParams.value: value,
            RequestParams.expectAddress: from
        ])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }

    public func authAsGuest(from viewController: UIViewController, state: String, redirect: String, credential: String, authDate: String, hash: String, scope: String) async -> String {
        let request = createRequest(for: ServicePaths.guests, state: state, redirect: redirect, additionalParams: [
            RequestParams.credential: credential,
            RequestParams.authDate: authDate,
            RequestParams.hash: hash,
            RequestParams.scope: scope
        ])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }

    public func registerGuestAccount(from viewController: UIViewController, state: String, redirect: String) async -> String {
        let request = createRequest(for: ServicePaths.register, state: state, redirect: redirect, additionalParams: [:])
        return await executeRequest(from: viewController, redirect: redirect, request: request)
    }
}
