import Foundation
import AuthenticationServices

struct CustomTabError: Error {
    let message: String
    let code: Int
}

class CustomTab: NSObject {

    func startSession(url: URL, callbackURLScheme: String) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            var session: ASWebAuthenticationSession? = nil
            session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { callbackURL, error in
                if let error = error as NSError? {
                    let authError = CustomTabError(message: error.localizedDescription, code: error.code)
                    continuation.resume(throwing: authError)
                } else if let callbackURL = callbackURL {
                    continuation.resume(returning: callbackURL)
                    // Cancel the session after receiving a successful callback
                    session?.cancel()
                } else {
                    let authError = CustomTabError(message: "Unknown error", code: -1)
                    continuation.resume(throwing: authError)
                }
            }

            session?.presentationContextProvider = self
            // Indicates whether the session should ask the browser for a private authentication session
            session?.prefersEphemeralWebBrowserSession = false
            // Start the session
            session?.start()
        }
    }
}

extension CustomTab: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        var presentationAnchor: ASPresentationAnchor?
        DispatchQueue.main.sync {
            presentationAnchor = UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
        }
        return presentationAnchor!
    }
}
