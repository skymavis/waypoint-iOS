# Mavis ID iOS SDK

iOS SDK use to interact with Mavis ID, use to develop in app Web3 wallet

## Features

- [x] Authorize
- [x] Sign message
- [x] Sign typed data
- [x] Send transaction
- [x] Call contract

## Prerequisites

- `iOS` : >= `13.0`
- Register your application with Sky Mavis to get `YOUR_APP_ID` and `YOUR_REDIRECT_URI`
- Request permission to use Mavis ID
- Go to Developer Console > your app > App Permission > Mavis ID > Request Access

[Go to developer portal](https://developers.skymavis.com/) to acquired `YOUR_APP_ID` and `YOUR_REDIRECT_URI`

## Installation

In `Xcode` -> `Target`-> `Add Package Dependency` -> Add package with Github url `https://github.com/skymavis/mavis-id-iOS`

## Initialization

Initial SDK `Client`

- `address` : The URL of Mavis ID. This is the base URL for all API calls.
- `clientId`: The client ID registered in Mavis ID. This is used to identify your application.
- `chainRpc` : Rpc URL of Ronin chain. In this example it's set for the `Ronin Testnet`.
- `chainId`: The ID of the blockchain network. In this example, it's set to `2021` for the `Ronin Testnet`.

```swift
import id

let id = Client(
    // The url of Mavis ID
    address: "https://id.skymavis.com",
    // The client ID registered in Mavis ID
    clientId: "{YOUR_CLIENT_ID}",
    // Ronin Testnet
    chainRpc: "https://saigon-testnet.roninchain.com/rpc",
    chainId: 2021
)
```

### Usage

- All function of SDK will return a `string` in format the deeplink which registered schema with `Mavis ID`
- Developer can parse string with `Utils` in SDK or manual.

#### Authorize

- This function authorizes a user with an existing Mavis ID account. If the user does not have an account, they will be prompted to create one.

```swift
func authorize(from viewController: UIViewController, state : String, redirect: String) async -> String

```

##### Params :

- `from` : The `UIViewController` of your app.
- `state`: Random UUID use to be request id.
- `redirect` : Redirect uri registed with `Mavis ID`.

##### Example

```swift

 // Implement the action for the Authorize
@objc func authorizeTapped() -> Void {
    // Use Utils of SDK to generate random state
    let state = Utils.generateRandomState()
    // Example : "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.authorize(from: self, state: state, redirect: redirect)
        // Optional to use Utils of SDK
        let response = Utils.parseDeepLink(deeplink: result)
    }
}
```

#### Send transaction

```swift
func sendTransaction(from viewController: UIViewController, state : String, redirect: String, to: String, value: String) async -> String
```

#### Params :

- `from` : The `UIViewController` of your app.
- `state`: Random UUID use to be request id.
- `redirect` : Redirect uri registed with `Mavis ID`.
- `to` : Receiver address
- `value` : Amount want to send in `Wei`

#### Example

```swift
@objc func sendTransactionTapped() -> Void {
    // Use Utils of SDK to generate random state
    let state = Utils.generateRandomState()
    // Receiver address
    let to = "${YOUR_RECEIVER_ADDRESS}"
    // 1 Ron in Wei
    let value = "100000000000000000"
    // Example : "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.sendTransaction(from: self, state: state, redirect: redirect, to: to, value: value)
        // Optional to use Utils of SDK to parse result
        let response = Utils.parseDeepLink(deeplink: result)
    }
}
```

#### Personal sign

```swift
public func personalsign(from viewcontroller: uiviewcontroller, state : string, redirect: string, message: string) async -> string
```

##### Param :

- `from` : The `UIViewController` of your app.
- `state`: Random UUID use to be request id.
- `redirect` : Redirect uri registed with `Mavis ID`.
- `message` : Message to sign.

##### Example

```swift
@objc func personalSignTapped() -> Void {
    // Use Utils of SDK to generate random state
    let state = Utils.generateRandomState()
    // Message to sign
    var message = "Hello Axie"
    // Example : "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.personalSign(from: self, state: state, redirect: redirect, message: message)
        // Optional to use Utils of SDK to parse result
        let response = Utils.parseDeepLink(deeplink: result)

    }
}
```

#### Sign Typed Data

- Signs the typed data value with types data structure for domain using the EIP-712 specification.
- Sign typed data of an Axie

```swift
func signTypeData(from viewController: UIViewController, state : String, redirect: String, typedData: String) async -> String
```

##### Param :

- `from` : The `UIViewController` of your app.
- `state`: Random UUID use to be request id.
- `redirect` : Redirect uri registed with `Mavis ID`.
- `typedData` : Types data structure for domain using the EIP-712 specification.

##### Example

```swift
@objc func signTypeDataTapped() -> Void {
    // Example of type data use EIP-721 specification.
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
    // Use Utils of SDK to generate random state
    let state = Utils.generateRandomState()
    // Example : "mydapp://callback"
    let redirect = "${YOUR_DEEPLINK_REDIRECT}"
    Task {
        let result = await id.signTypeData(from: self, state: state, redirect: redirect, typedData: typedData)
        // Optional to use Utils of SDK to parse result
        let response = Utils.parseDeepLink(deeplink: result)
    }
    }
```

#### Call contract

```swift
func callContract(from viewController: UIViewController, state : String, redirect: String, contractAddress: String, data: String, value : String? = nil) async -> String
```

##### Param :

- `from` : The `UIViewController` of your app.
- `state`: Random UUID use to be request id.
- `redirect` : Redirect uri registed with `Mavis ID`.
- `contractAddress` : Smart contract address to interact with.
- `data` : Encoded transaction data.
- `value` (Optional) : Value in `Wei`.

```swift
@objc func callContractTapped() -> Void {
    // Smart contract address
    let contractAddress = "0x3c4e17b9056272ce1b49f6900d8cfd6171a1869d"
    // Approve 1 RON
    let data = "0xa9059cbb000000000000000000000000edb40e7abaa613a0b06d86260dd55c7eb2df2447000000000000000000000000000000000000000000000000016345785d8a0000"
    // Use Utils of SDK to generate random state
    let state = Utils.generateRandomState()
    Task {
        let result = await id.callContract(from: self, state: state, redirect: redirect, contractAddress: contractAddress, data: data)
        // Optional to use Utils of SDK to parse result
        let response = Utils.parseDeepLink(deeplink: result)
    }
}
```

#### Utils

#### Generate random state

- Use to generate random UUID

```swift
    static func generateRandomState() -> String
```

#### Parse deeplink

- Use to parse deeplink, result from function and assign it to `Response` object.

```swift
 static func parseDeepLink(deeplink : String) -> Response
```

#### Reponse

- A setter, getter class to save result from `Mavis ID`

```swift
public class Response {
    private var success: Bool?
    private var method: String?
    private var data: String?
    private var address: String?
    private var state: String?
}
```
