import Foundation
import UIKit

private func initViewController() -> UIViewController? {
    if #available(iOS 13.0, *) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let viewController = windowScene.windows
            .first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        return viewController
    } else {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}

private func getString(from pointer: UnsafePointer<Int8>) -> String {
    return String(cString: pointer)
}

private func getOptionalString(from pointer: UnsafePointer<Int8>?) -> String? {
    guard let pointer = pointer else { return nil }
    return String(cString: pointer)
}

private func executeOnMain<T>(completion: @escaping (UIViewController, Waypoint) async -> T) {
    DispatchQueue.main.async {
        guard let viewController = initViewController(),
              let client = WaypointManager.shared.client else { return }

        Task {
            await completion(viewController, client)
        }
    }
}

@_cdecl("initClient")
public func initClient(address: UnsafePointer<Int8>, clientId: UnsafePointer<Int8>, chainRpc: UnsafePointer<Int8>, chainId: Int32) {
    let addressString = getString(from: address)
    let clientIdString = getString(from: clientId)
    let chainRpcString = getString(from: chainRpc)
    let chainIdInt = Int(chainId)

    WaypointManager.shared.configure(
        waypointOrigin: addressString,
        clientId: clientIdString,
        chainRpc: chainRpcString,
        chainId: chainIdInt
    )
}

@_cdecl("authorize")
public func authorize(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, scope: UnsafePointer<Int8>? = nil) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)
    let scopeString = getOptionalString(from: scope)

    executeOnMain { viewController, client in
        await client.authorize(
            from: viewController,
            state: stateString,
            redirect: redirectString,
            scope: scopeString
        )
    }
}

@_cdecl("personalSign")
public func personalSign(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, message: UnsafePointer<Int8>, from: UnsafePointer<Int8>? = nil) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)
    let messageString = getString(from: message)
    let fromString = getOptionalString(from: from)

    executeOnMain { viewController, client in
        await client.personalSign(
            from: viewController,
            state: stateString,
            redirect: redirectString,
            message: messageString,
            from: fromString
        )
    }
}

@_cdecl("signTypedData")
public func signTypedData(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, typedData: UnsafePointer<Int8>, from: UnsafePointer<Int8>? = nil) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)
    let typedDataString = getString(from: typedData)
    let fromString = getOptionalString(from: from)

    executeOnMain { viewController, client in
        await client.signTypedData(
            from: viewController,
            state: stateString,
            redirect: redirectString,
            typedData: typedDataString,
            from: fromString
        )
    }
}

@_cdecl("sendTransaction")
public func sendTransaction(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, to: UnsafePointer<Int8>, data: UnsafePointer<Int8>? = nil, value: UnsafePointer<Int8>? = nil, from: UnsafePointer<Int8>? = nil) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)
    let toString = getString(from: to)
    let dataString = getOptionalString(from: data)
    let valueString = getOptionalString(from: value)
    let fromString = getOptionalString(from: from)

    executeOnMain { viewController, client in
        await client.sendTransaction(
            from: viewController,
            state: stateString,
            redirect: redirectString,
            to: toString,
            data: dataString,
            value: valueString,
            from: fromString
        )
    }
}

@_cdecl("sendNativeToken")
public func sendNativeToken(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, to: UnsafePointer<Int8>, value: UnsafePointer<Int8>, from: UnsafePointer<Int8>? = nil) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)
    let toString = getString(from: to)
    let valueString = getString(from: value)
    let fromString = getOptionalString(from: from)

    executeOnMain { viewController, client in
        await client.sendNativeToken(
            from: viewController,
            state: stateString,
            redirect: redirectString,
            to: toString,
            value: valueString,
            from: fromString
        )
    }
}

@_cdecl("authAsGuest")
public func authAsGuest(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, credential: UnsafePointer<Int8>, authDate: UnsafePointer<Int8>, hash: UnsafePointer<Int8>, scope: UnsafePointer<Int8>) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)
    let credentialString = getString(from: credential)
    let authDateString = getString(from: authDate)
    let hashString = getString(from: hash)
    let scopeString = getString(from: scope)

    executeOnMain { viewController, client in
        await client.authAsGuest(
            from: viewController,
            state: stateString,
            redirect: redirectString,
            credential: credentialString,
            authDate: authDateString,
            hash: hashString,
            scope: scopeString
        )
    }
}

@_cdecl("registerGuestAccount")
public func registerGuestAccount(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>) {
    let stateString = getString(from: state)
    let redirectString = getString(from: redirect)

    executeOnMain { viewController, client in
        await client.registerGuestAccount(
            from: viewController,
            state: stateString,
            redirect: redirectString
        )
    }
}
