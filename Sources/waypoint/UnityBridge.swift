import Foundation
import UIKit

private func initViewController() -> UIViewController? {
    var viewController: UIViewController?
    // KeyWindow deprecate in iOS 13
    if #available(iOS 13.0, *) {
        // Use the first connected scene that is of type UIWindowScene and has a window property
        let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        viewController = windowScene?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController
    } else {
        // Fallback on earlier versions
        viewController = UIApplication.shared.keyWindow?.rootViewController
    }
    return viewController
}

@_cdecl("initClient")
public func initClient(address: UnsafePointer<Int8>, clientId: UnsafePointer<Int8>, chainRpc: UnsafePointer<Int8>, chainId: Int32) {
    // Convert to string match with c# primitive
    let addressString = String(cString: address)
    let clientIdString = String(cString: clientId)
    let chainRpcString = String(cString: chainRpc)
    let chainIdInt = Int(chainId)
    WaypointManager.shared.initWaypoint(address: addressString, clientId: clientIdString, chainRpc: chainRpcString, chainId: chainIdInt)
}

@_cdecl("authorize")
public func authorize(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>) {
    // Convert to string match with C# primitive
    let redirectString = String(cString: redirect)
    let stateString = String(cString: state)
    // Anything relate to UI should be in main thread
    DispatchQueue.main.async {
        guard let viewController = initViewController() else { return }
        guard let client = WaypointManager.shared.getClient() else { return }
        Task {
            await client.authorize(from: viewController, state: stateString, redirect: redirectString)
        }
    }
}

@_cdecl("personalSign")
public func personalSign(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, message: UnsafePointer<Int8>) {
    // Convert to string match with c# primitive type
    let stateString = String(cString: state)
    let redirectString = String(cString: redirect)
    let messageString = String(cString: message)
    
    DispatchQueue.main.async {
        guard let viewController = initViewController() else { return }
        guard let client = WaypointManager.shared.getClient() else { return }
        Task {
            await client.personalSign(from: viewController, state: stateString, redirect: redirectString,  message: messageString)
        }
    }
}

@_cdecl("signTypeData")
public func signTypeData(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, typedData: UnsafePointer<Int8>) {
    // Convert to string match with c# primitive type
    let stateString = String(cString: state)
    let redirectString = String(cString: redirect)
    let typedDataString = String(cString: typedData)
    DispatchQueue.main.async {
        guard let viewController = initViewController() else { return }
        guard let client = WaypointManager.shared.getClient() else { return }
        Task {
            await client.signTypedData(from: viewController, state: stateString, redirect: redirectString,  typedData: typedDataString)
        }
    }
}


@_cdecl("sendTransaction")
public func sendTransaction(state: UnsafePointer<Int8>,redirect: UnsafePointer<Int8>, to: UnsafePointer<Int8>, value: UnsafePointer<Int8>) {
    // Convert to string match with c# primitive type
    let stateString = String(cString: state)
    let redirectString = String(cString: redirect)
    let toString = String(cString: to)
    let valueString = String(cString: value)
    DispatchQueue.main.async {
        guard let viewController = initViewController() else { return }
        guard let client = WaypointManager.shared.getClient() else { return }
        Task {
            await client.sendTransaction(from: viewController, state: stateString, redirect: redirectString,  to: toString, value: valueString)
        }
    }
}
@_cdecl("callContract")
public func callContract(state: UnsafePointer<Int8>, redirect: UnsafePointer<Int8>, contractAddress: UnsafePointer<Int8>, data: UnsafePointer<Int8>, value : UnsafePointer<Int8>? = nil ) {
    // Convert to string match with c# primitive type
    let stateString = String(cString: state)
    let redirectString = String(cString: redirect)
    let contractAddressString = String(cString: contractAddress)
    let dataString = String(cString: data)
    var valueString: String? = nil
    
    if let value = value {
        valueString = String(cString: value)
    }
    DispatchQueue.main.async {
        guard let viewController = initViewController() else { return }
        guard let client = WaypointManager.shared.getClient() else { return }
        
        if let valueString = valueString {
            Task {
                await client.callContract(from: viewController, state: stateString,  redirect: redirectString,  contractAddress: contractAddressString, data: dataString, value: valueString)
            }
        } else {
            Task {
                await client.callContract(from: viewController, state: stateString, redirect: redirectString,  contractAddress: contractAddressString, data: dataString)
            }
        }
    }
    
}
