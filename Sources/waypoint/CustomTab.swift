import Foundation
import AuthenticationServices

enum CustomTabError: Error {
    case sessionStartFailed
    case userRejected
    case noUrlOrErrorReturned
    case presentationError
    case other(message: String, code: Int)

    var message: String {
        switch self {
        case .sessionStartFailed:
            return "Failed to start authentication session"
        case .userRejected:
            return "User rejected request"
        case .noUrlOrErrorReturned:
            return "No URL or error returned"
        case .presentationError:
            return "Failed to present authentication window"
        case .other(let message, _):
            return message
        }
    }

    var code: Int {
        switch self {
        case .userRejected:
            return -1
        case .sessionStartFailed:
            return -2
        case .noUrlOrErrorReturned:
            return -3
        case .presentationError:
            return -4
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
                    if ((error as? ASWebAuthenticationSessionError)?.code) == ASWebAuthenticationSessionError.canceledLogin {
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
                    continuation.resume(throwing: CustomTabError.noUrlOrErrorReturned)
                    return
                }

                continuation.resume(returning: callbackURL)
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false

            guard session.start() else {
                continuation.resume(throwing: CustomTabError.sessionStartFailed)
                return
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
