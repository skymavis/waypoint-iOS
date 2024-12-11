import Foundation
import SafariServices

public struct Network {
    public static let Mainnet = Network(
        chainId: 2020,
        rpcUrl: "https://api.roninchain.com/rpc"
    )

    public static let Testnet = Network(
        chainId: 2021,
        rpcUrl: "https://saigon-testnet.roninchain.com/rpc"
    )

    public let chainId: Int
    public let rpcUrl: String
}

public class Waypoint {
    private let waypointOrigin: String
    private let clientId: String
    private let redirectUri: String
    private let rpcUrl: String
    private let chainId: Int

    public init(waypointOrigin: String, clientId: String, redirectUri: String, isTestnet: Bool = false) {
        self.waypointOrigin = waypointOrigin
        self.clientId = clientId
        self.redirectUri = redirectUri

        let network = isTestnet ? Network.Testnet : Network.Mainnet
        self.chainId = network.chainId
        self.rpcUrl = network.rpcUrl
    }

    private func constructWaypointEndpoint(for method: String) -> String {
        let path: String
        switch method {
        case ServicePaths.authorize:
            path = "/\(ServicePaths.client)/\(clientId)/\(ServicePaths.authorize)"
        case ServicePaths.send, ServicePaths.sign:
            path = "/\(ServicePaths.wallet)/\(method)"
        case ServicePaths.guests:
            path = "/\(ServicePaths.seamless)/\(ServicePaths.guests)/\(ServicePaths.start)"
        case ServicePaths.register:
            path = "/\(ServicePaths.guests)/\(ServicePaths.register)"
        case ServicePaths.setup:
            path = "/\(ServicePaths.wallet)/\(ServicePaths.setup)/\(ServicePaths.introduce)"
        default:
            path = ""
        }
        return waypointOrigin + path
    }

    private func constructWaypointParams(_ params: [String: String?]) -> [String: String?] {
        return [
            RequestParams.clientId: clientId,
            RequestParams.redirect: redirectUri,
            RequestParams.chainId: String(chainId),
        ].merging(params, uniquingKeysWith: { (_, new) in new })
    }

    public func authorize(state: String, scope: String? = nil) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.authorize)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state,
                RequestParams.scope: scope
            ])
        )
        return await request.execute()
    }

    public func personalSign(state: String, message: String, from: String? = nil) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.sign)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state,
                RequestParams.message: message,
                RequestParams.expectAddress: from
            ])
        )
        return await request.execute()
    }

    public func signTypedData(state: String, typedData: String, from: String? = nil) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.sign)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state,
                RequestParams.typedData: typedData,
                RequestParams.expectAddress: from
            ])
        )
        return await request.execute()
    }

    public func sendTransaction(state: String, to: String, data: String? = nil, value: String? = nil, from: String? = nil) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.send)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state,
                RequestParams.to: to,
                RequestParams.data: data,
                RequestParams.value: value,
                RequestParams.expectAddress: from
            ])
        )
        return await request.execute()
    }

    public func sendNativeToken(state: String, to: String, value: String, from: String? = nil) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.send)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state,
                RequestParams.to: to,
                RequestParams.value: value,
                RequestParams.expectAddress: from
            ])
        )
        return await request.execute()
    }

    public func authAsGuest(state: String, credential: String, authDate: String, hash: String, scope: String) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.guests)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state,
                RequestParams.credential: credential,
                RequestParams.authDate: authDate,
                RequestParams.hash: hash,
                RequestParams.scope: scope
            ])
        )
        return await request.execute()
    }

    public func registerGuestAccount(state: String) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.register)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state
            ])
        )
        return await request.execute()
    }

    public func createKeylessWallet(state: String) async -> String {
        let endpoint = constructWaypointEndpoint(for: ServicePaths.setup)
        let request = Request(
            endpoint: endpoint,
            redirectUri: redirectUri,
            params: constructWaypointParams([
                RequestParams.state: state
            ])
        )
        return await request.execute()
    }
}
