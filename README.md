# Mavis ID iOS SDK

The Mavis ID iOS SDK lets developers integrate Mavis ID into mobile apps developed for the iOS platform. After the integration, users can sign in to your app with Mavis ID and create an embedded Web3 wallet to interact with the blockchain to send and receive tokens, sign messages, and more.

## Features

- Authorize users: sign in to your app with Mavis ID.
- Send transactions: transfer tokens to other addresses.
- Sign messages: sign plain text messages.
- Sign typed data: sign structured data according to the EIP-712 standard.
- Call contracts: execute custom transactions on smart contracts.

## Prerequisites

- [iOS 13.0](https://developer.apple.com/ios/) or later and [Xcode](https://developer.apple.com/xcode/).
- An app created in the [Developer Console](https://developers.skymavis.com/console/applications/).
- Permission to use Mavis ID. Request in **Developer Console > your app > App Permission > Sky Mavis Account (OAuth 2.0) > Request Access**.
- A client ID located in **Developer Console > Products > ID Service > Client ID**.
- A registered redirect URI **Developer Console > Products > ID Service > Redirect URI**.

For more information about the initial setup, see [Get started](https://docs.skymavis.com/mavis/mavis-id/guides/get-started).

## Installation

In Xcode, select your target, then go to **General > + > Add Other > Add Package Dependency**, and then enter this repository URL: `https://github.com/skymavis/mavis-id-iOS`.

## Initialization

```swift
import id

let id = Client(
    // Base URL of Mavis ID for all API calls
    idOrigin : "https://id.skymavis.com",
    // Client ID registered in the Mavis ID settings in the Developer Console
    clientId: "{YOUR_CLIENT_ID}",
    // Saigon testnet public RPC endpoint 
    chainRpc: "https://saigon-testnet.roninchain.com/rpc",
    // Saigon testnet chain ID
    chainId: 2021
)
```

## Usage

- All functions of the SDK return a `string` in the format of the deeplink schema that you registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications).
- You can parse strings using the `parseDeepLink` utility function or do it manually. For more information, see [Utilities](#utilities).

### Authorize users

Authorizes a user with an existing Mavis ID account, returning an ID token and the user's wallet address. If the user does not have an account, they will be prompted to create one.

```swift
// Implement the action for authorization
@objc func authorizeTapped() -> Void {
    // Use the SDK utility to generate a random state
    let state = Utils.generateRandomState()
    // Example: "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.authorize(from: self, state: state, redirect: redirect)
        // Optionally, use this utility to parse the result
        let response = Utils.parseDeepLink(deeplink: result)
    }
}
```

### Send transactions

Transfers 1 RON to another address, returning a transaction hash.

```swift
@objc func sendTransactionTapped() -> Void {
    // Use the SDK utility to generate a random state
    let state = Utils.generateRandomState()
    // Receiver address
    let to = "${YOUR_RECEIVER_ADDRESS}"
    // 1 RON in wei
    let value = "100000000000000000"
    // Example: "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.sendTransaction(from: self, state: state, redirect: redirect, to: to, value: value)
        // Optionally, use this utility to parse the result
        let response = Utils.parseDeepLink(deeplink: result)
    }
}
```

### Sign message

Signs a plain text message, returning a signature.

```swift
@objc func personalSignTapped() -> Void {
    // Use the SDK utility to generate a random state
    let state = Utils.generateRandomState()
    // Message to sign
    var message = "Hello Axie"
    // Example: "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.personalSign(from: self, state: state, redirect: redirect, message: message)
        // Optionally, use this utility to parse the result
        let response = Utils.parseDeepLink(deeplink: result)

    }
}
```

### Sign typed data

Signs [EIP-712](https://eips.ethereum.org/EIPS/eip-712) typed data for an order on Axie Marketplace, returning a signature.

```swift
@objc func signTypeDataTapped() -> Void {
    // Example of type data using the EIP-712 standard.
    let typedData = """
    {
        "types": {
            "Asset": [
                {"name": "erc", "type": "uint8"},
                {"name": "addr", "type": "address"},
                {"name": "id", "type": "uint256"},
                {"name": "quantity", "type": "uint256"}
            ],
            "Order": [
                {"name": "maker", "type": "address"},
                {"name": "kind", "type": "uint8"},
                {"name": "assets", "type": "Asset[]"},
                {"name": "expiredAt", "type": "uint256"},
                {"name": "paymentToken", "type": "address"},
                {"name": "startedAt", "type": "uint256"},
                {"name": "basePrice", "type": "uint256"},
                {"name": "endedAt", "type": "uint256"},
                {"name": "endedPrice", "type": "uint256"},
                {"name": "expectedState", "type": "uint256"},
                {"name": "nonce", "type": "uint256"},
                {"name": "marketFeePercentage", "type": "uint256"}
            ],
            "EIP712Domain": [
                {"name": "name", "type": "string"},
                {"name": "version", "type": "string"},
                {"name": "chainId", "type": "uint256"},
                {"name": "verifyingContract", "type": "address"}
            ]
        },
        "domain": {
            "name": "MarketGateway",
            "version": "1",
            "chainId": 2021,
            "verifyingContract": "0xfff9ce5f71ca6178d3beecedb61e7eff1602950e"
        },
        "primaryType": "Order",
        "message": {
            "maker": "0xd761024b4ef3336becd6e802884d0b986c29b35a",
            "kind": "1",
            "assets": [
                {
                    "erc": "1",
                    "addr": "0x32950db2a7164ae833121501c797d79e7b79d74c",
                    "id": "2730069",
                    "quantity": "0"
                }
            ],
            "expiredAt": "1721709637",
            "paymentToken": "0xc99a6a985ed2cac1ef41640596c5a5f9f4e19ef5",
            "startedAt": "1705984837",
            "basePrice": "500000000000000000",
            "endedAt": "0",
            "endedPrice": "0",
            "expectedState": "0",
            "nonce": "0",
            "marketFeePercentage": "425"
        }
    }
    """
    // Use the SDK utility to generate a random state
    let state = Utils.generateRandomState()
    // Example: "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.signTypeData(from: self, state: state, redirect: redirect, typedData: typedData)
        // Optionally, use this utility to parse the result
        let response = Utils.parseDeepLink(deeplink: result)
    }
    }
```

### Call contracts

Allows another contract to spend 1 RON on user's behalf, returning a transaction hash.

```swift
@objc func callContractTapped() -> Void {
    // Smart contract address
    let contractAddress = "0x3c4e17b9056272ce1b49f6900d8cfd6171a1869d"
    // Approve 1 RON
    let data = "0xa9059cbb000000000000000000000000edb40e7abaa613a0b06d86260dd55c7eb2df2447000000000000000000000000000000000000000000000000016345785d8a0000"
    // Use the SDK utility to generate a random state
    let state = Utils.generateRandomState()
    Task {
        let result = await id.callContract(from: self, state: state, redirect: redirect, contractAddress: contractAddress, data: data)
        // Optionally, use this utility to parse the result
        let response = Utils.parseDeepLink(deeplink: result)
    }
}
```

## Utilities

### Generate random state

Use to generate a random UUID.

```swift
static func generateRandomState() -> String
```

### Parse deeplink

Use to parse a deeplink returned by a function, and assign it to a `Response` object.

```swift
static func parseDeepLink(deeplink: String) -> Response
```

### Response

A setter, getter class to save the result from Mavis ID.

```swift
public class Response {
    private var success: Bool?
    private var method: String?
    private var data: String?
    private var address: String?
    private var state: String?
}
```

## Documentation

For more information, see the [Mavis ID iOS SDK]([https://docs.skymavis.com/mavis/mavis-id/overview](https://docs.skymavis.com/mavis/mavis-id/guides/ios-sdk) integration guide.
