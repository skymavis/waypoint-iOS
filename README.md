# Mavis ID iOS SDK

The Mavis ID iOS SDK lets developers integrate Mavis ID into mobile apps developed for the iOS platform. After the integration, users can sign in to your app with Mavis ID and create an embedded Web3 wallet to interact with the blockchain to send and receive tokens, sign messages, and more.

## Features

* Authorize users: sign in to your app with Mavis ID.
* Send transactions: transfer tokens to other addresses.
* Sign messages: sign plain text messages.
* Sign typed data: sign structured data according to the EIP-712 standard.
* Call contracts: execute custom transactions on smart contracts.

## Prerequisites

* [iOS 13.0](https://developer.apple.com/ios/) or later and [Xcode](https://developer.apple.com/xcode/).
* An app created in the [Developer Console](https://developers.skymavis.com/console/applications/).
* Permission to use Mavis ID. Request in **Developer Console > your app > App Permission > Sky Mavis Account (OAuth 2.0) > Request Access**.
* A client ID that you can find in **Developer Console > Products > ID Service > CLIENT ID (APPLICATION ID)**.
* A redirect URI registered in **Developer Console > Products > ID Service > REDIRECT URI**.

For more information about the initial setup, see [Get started](https://docs.skymavis.com/mavis/mavis-id/guides/get-started).

## Installation

In Xcode, select your target, then go to **General > + > Add Other > Add Package Dependency**, and then enter this repository URL: `https://github.com/skymavis/mavis-id-iOS`.

## Initialization

Initialize the client:

```swift
import id

let id = Client(
    // Base URL of Mavis ID
    address: "https://id.skymavis.com",
    // Client ID from the Mavis ID settings in the Developer Console
    clientId: "{YOUR_CLIENT_ID}",
    // Saigon testnet parameters
    chainRpc: "https://saigon-testnet.roninchain.com/rpc",
    chainId: 2021
)
```

Parameters:

* `address`: the URL of Mavis ID, serving as the base URL for all API calls.
* `clientId`: the client ID registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications).
* `chainRpc`: the RPC endpoint through which you want to connect to Ronin: `https://saigon-testnet.roninchain.com/rpc` is a public endpoint for the Saigon testnet. For other endpoints, see [RPC endpoints](https://docs.skymavis.com/ronin/rpc/overview#rpc-endpoints).
* `chainId`: the ID of the Ronin chain you want to connect to: `2021` for the Saigon testnet and `2020` for the Ronin mainnet.

## Usage

* All functions of the SDK return a `string` in the format of the deeplink schema that you registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications).
* You can parse strings using the `parseDeepLink` utility function or do it manually. For more information, see [Utilities](#utilities).

### Authorize users

Authorizes a user with an existing Mavis ID account, returning an ID token and the user's wallet address. If the user does not have an account, they will be prompted to create one.

```swift
func authorize(from viewController: UIViewController, state: String, redirect: String) async -> String
```

Parameters:

* `from`: the `UIViewController` of your app.
* `state`: a unique random identifier used to manage requests from the client to Mavis ID.
* `redirect`: the redirect URI registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications).

Example:

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

Transfers RON tokens to a recipient's address, returning a transaction hash.

```swift
func sendTransaction(from viewController: UIViewController, state: String, redirect: String, to: String, value: String) async -> String
```

Parameters:

* `from`: the `UIViewController` of your app.
* `state`: a unique random identifier used to manage requests from the client to Mavis ID.
* `redirect`: the redirect URI registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications).
* `to`: the recipient's address.
* `value`: the amount to send, in wei.

Example:

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

### Sign messages

Sign a plain text message, returning a signature in hex format.

```swift
public func personalsign(from viewcontroller: uiviewcontroller, state: string, redirect: string, message: string) async -> string
```

Parameters:

* `from`: the `UIViewController` of your app.
* `state`: a unique random identifier used to manage requests from the client to Mavis ID.
* `redirect`: the redirect URI registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications).
* `message`: the message to sign.

Example:

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

Signs data structured according to the [EIP-712](https://eips.ethereum.org/EIPS/eip-712) standard, returning a signature in hex format. Also signs typed data of an axie.

```swift
func signTypeData(from viewController: UIViewController, state: String, redirect: String, typedData: String) async -> String
```

Parameters:

* `from`: the `UIViewController` of your app.
* `state`: a unique random identifier used to manage requests from the client to Mavis ID.
* `redirect`: the redirect URI registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications/).
* `typedData`: typed data structured using EIP-712.

Example:

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

Executes a custom transaction on a specified smart contract, returning a transaction hash.

```swift
func callContract(from viewController: UIViewController, state: String, redirect: String, contractAddress: String, data: String, value: String? = nil) async -> String
```

Parameters:

* `from`: the `UIViewController` of your app.
* `state`: a unique random identifier used to manage requests from the client to Mavis ID.
* `redirect`: the redirect URI registered in the Mavis ID settings in the [Developer Console](https://developers.skymavis.com/console/applications/).
* `contractAddress`: the address of the smart contract to interact with.
* `data`: encoded transaction data.
* `value`: optionally, the value in wei.

Example:

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

### Parse deeplinks

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

## See also

For more information about Mavis ID, see the [official documentation](https://docs.skymavis.com/mavis/mavis-id/overview).
