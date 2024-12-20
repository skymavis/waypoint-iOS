import Foundation
import UIKit

private func getOptionalString(cString pointer: UnsafePointer<Int8>?) -> String? {
    guard let pointer = pointer else { return nil }
    return String(cString: pointer)
}

private func executeOnMain<T>(completion: @escaping (Waypoint) async -> T) {
    DispatchQueue.main.async {
        guard let client = WaypointManager.shared.client else { return }
        
        Task {
            await completion(client)
        }
    }
}

@_cdecl("initClient")
public func initClient(waypointOrigin: UnsafePointer<Int8>, clientId: UnsafePointer<Int8>, redirectUri: UnsafePointer<Int8>, isTestnet: UnsafePointer<Bool>? = nil) {
    let normalizedWaypointOrigin = String(cString: waypointOrigin)
    let normalizedClientId = String(cString: clientId)
    let normalizedRedirectUri = String(cString: redirectUri)
    let normalizedIsTestnet = isTestnet?.pointee ?? false
    
    WaypointManager.shared.configure(
        waypointOrigin: normalizedWaypointOrigin,
        clientId: normalizedClientId,
        redirectUri: normalizedRedirectUri,
        isTestnet: normalizedIsTestnet
    )
}

@_cdecl("authorize")
public func authorize(state: UnsafePointer<Int8>, scope: UnsafePointer<Int8>? = nil) {
    let normalizedState = String(cString: state)
    let normalizedScope = getOptionalString(cString: scope)
    
    executeOnMain { client in
        await client.authorize(
            state: normalizedState,
            scope: normalizedScope
        )
    }
}

@_cdecl("personalSign")
public func personalSign(state: UnsafePointer<Int8>, message: UnsafePointer<Int8>, from: UnsafePointer<Int8>? = nil) {
    let normalizedState = String(cString: state)
    let normalizedMessage = String(cString: message)
    let normalizedFrom = getOptionalString(cString: from)
    
    executeOnMain { client in
        await client.personalSign(
            state: normalizedState,
            message: normalizedMessage,
            from: normalizedFrom
        )
    }
}

@_cdecl("signTypedData")
public func signTypedData(state: UnsafePointer<Int8>, typedData: UnsafePointer<Int8>, from: UnsafePointer<Int8>? = nil) {
    let normalizedState = String(cString: state)
    let normalizedTypedData = String(cString: typedData)
    let normalizedFrom = getOptionalString(cString: from)
    
    executeOnMain { client in
        await client.signTypedData(
            state: normalizedState,
            typedData: normalizedTypedData,
            from: normalizedFrom
        )
    }
}

@_cdecl("sendTransaction")
public func sendTransaction(state: UnsafePointer<Int8>, to: UnsafePointer<Int8>, data: UnsafePointer<Int8>? = nil, value: UnsafePointer<Int8>? = nil, from: UnsafePointer<Int8>? = nil) {
    let normalizedState = String(cString: state)
    let normalizedTo = String(cString: to)
    let normalizedData = getOptionalString(cString: data)
    let normalizedValue = getOptionalString(cString: value)
    let normalizedFrom = getOptionalString(cString: from)
    
    executeOnMain { client in
        await client.sendTransaction(
            state: normalizedState,
            to: normalizedTo,
            data: normalizedData,
            value: normalizedValue,
            from: normalizedFrom
        )
    }
}

@_cdecl("sendNativeToken")
public func sendNativeToken(state: UnsafePointer<Int8>, to: UnsafePointer<Int8>, value: UnsafePointer<Int8>, from: UnsafePointer<Int8>? = nil) {
    let normalizedState = String(cString: state)
    let normalizedTo = String(cString: to)
    let normalizedValue = String(cString: value)
    let normalizedFrom = getOptionalString(cString: from)
    
    executeOnMain { client in
        await client.sendNativeToken(
            state: normalizedState,
            to: normalizedTo,
            value: normalizedValue,
            from: normalizedFrom
        )
    }
}

@_cdecl("authAsGuest")
public func authAsGuest(state: UnsafePointer<Int8>, credential: UnsafePointer<Int8>, authDate: UnsafePointer<Int8>, hash: UnsafePointer<Int8>, scope: UnsafePointer<Int8>) {
    let normalizedState = String(cString: state)
    let normalizedCredential = String(cString: credential)
    let normalizedAuthDate = String(cString: authDate)
    let normalizedHash = String(cString: hash)
    let normalizedScope = String(cString: scope)
    
    executeOnMain { client in
        await client.authAsGuest(
            state: normalizedState,
            credential: normalizedCredential,
            authDate: normalizedAuthDate,
            hash: normalizedHash,
            scope: normalizedScope
        )
    }
}

@_cdecl("registerGuestAccount")
public func registerGuestAccount(state: UnsafePointer<Int8>) {
    let normalizedState = String(cString: state)
    
    executeOnMain { client in
        await client.registerGuestAccount(
            state: normalizedState
        )
    }
}

@_cdecl("createKeylessWallet")
public func createKeylessWallet(state: UnsafePointer<Int8>) {
    let normalizedState = String(cString: state)
    
    executeOnMain { client in
        await client.createKeylessWallet(
            state: normalizedState
        )
    }
}
