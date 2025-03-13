import Foundation

public struct ResponseError: Error {
    let message: String
    let code: Int
}

public struct Response {
    public let success: Bool
    public let state: String?
    public let error: ResponseError?
    public let data: [String: String]

    public init(
        success: Bool = false,
        state: String? = nil,
        error: ResponseError? = nil,
        data: [String: String] = [:]
    ) {
        self.success = success
        self.state = state
        self.error = error
        self.data = data
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

        let queryParams = Dictionary(uniqueKeysWithValues: queryItems.compactMap { item in
            item.value.map { (item.name, $0) }
        })

        let state = queryParams["state"]
        let isSuccess = queryParams["type"] == "success"

        if !isSuccess {
            let error = ResponseError(
                message: queryParams["message"] ?? "Unknown error",
                code: Int(queryParams["code"] ?? "0") ?? 0
            )
            return Response(
                success: false,
                state: state,
                error: error
            )
        }

        return Response(
            success: true,
            state: state,
            data: queryParams
        )
    }

    public func getValue(for key: String) -> String? {
        return data[key]
    }
}
