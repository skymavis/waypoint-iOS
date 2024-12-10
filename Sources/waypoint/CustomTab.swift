import Foundation
import AuthenticationServices

enum CustomTabError: Error {
    case sessionStartFailed
    case userRejected
    case noUrlReturned
    case other(message: String, code: Int)

    var message: String {
        switch self {
        case .sessionStartFailed:
            return "Failed to start session"
        case .userRejected:
            return "User rejected"
        case .noUrlReturned:
            return "No URL returned"
        case .other(let message, _):
            return message
        }
    }

    var code: Int {
        switch self {
        case .userRejected:
            return 1000
        case .sessionStartFailed:
            return 1001
        case .noUrlReturned:
            return 1002
        case .other(_, let code):
            return code
        }
    }
}

final class CustomTab: NSObject {
    func startSession(url: URL, callbackURLScheme: String) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { callbackURL, error in
                if let error = error {
                    if (error as? ASWebAuthenticationSessionError)?.code == ASWebAuthenticationSessionError.canceledLogin {
                        continuation.resume(throwing: CustomTabError.userRejected)
                        return
                    }
                    let nsError = error as NSError
                    continuation.resume(throwing: CustomTabError.other(
                        message: nsError.localizedDescription,
                        code: nsError.code
                    ))
                    return
                }

                guard let callbackURL = callbackURL else {
                    continuation.resume(throwing: CustomTabError.noUrlReturned)
                    return
                }

                continuation.resume(returning: callbackURL)
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false

            if !session.start() {
                continuation.resume(throwing: CustomTabError.sessionStartFailed)
            }
        }
    }
}

extension CustomTab: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = DispatchQueue.main.sync {
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }

        guard let presentationAnchor = window else {
            return ASPresentationAnchor()
        }

        return presentationAnchor
    }
}
