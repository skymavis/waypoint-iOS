import Foundation

public struct Response {
    private let success: Bool
    private let method: String?
    private let data: String?
    private let address: String?
    private let state: String?

    public init(
        success: Bool = false,
        method: String? = nil,
        data: String? = nil,
        address: String? = nil,
        state: String? = nil
    ) {
        self.success = success
        self.method = method
        self.data = data
        self.address = address
        self.state = state
    }

    public static func parseDeepLink(deeplink: String) -> Response {
        guard let url = URL(string: deeplink) else {
            return Response()
        }
        return parseDeepLink(deeplink: url)
    }

    public static func parseDeepLink(deeplink: URL) -> Response {
        guard let components = URLComponents(url: deeplink, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return Response()
        }

        var queryParams: [String: String] = [:]
        queryItems.forEach { item in
            if let value = item.value {
                queryParams[item.name] = value
            }
        }
        return Response(
            success: queryParams["type"] == "success",
            method: queryParams["method"],
            data: queryParams["data"],
            address: queryParams["address"],
            state: queryParams["state"]
        )
    }

    public func getSuccess() -> Bool {
        return success
    }

    public func getMethod() -> String? {
        return method
    }

    public func getData() -> String? {
        return data
    }

    public func getAddress() -> String? {
        return address
    }

    public func getState() -> String? {
        return state
    }
}
