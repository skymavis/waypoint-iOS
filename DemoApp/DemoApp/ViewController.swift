import UIKit

// Import ID SDK
import id

class ViewController: UIViewController {
    
    let id = Client(
        address: "https://id.skymavis.com",
        // Replace with your client id registered with ID on https://developer.skymavis.com
        clientId: "${YOUR_CLIENT_ID}",
        chainRpc: "https://saigon-testnet.roninchain.com/rpc",
        chainId: 2021
    )
    
    let redirect = "mydapp://callback"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ronin")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground // Set the view's background color
        
        
        let buttonTitles = ["Authorize", "Send Transaction", "Personal Sign", "Sign Type Data", "Call Contract"]
        let buttonSelectors: [Selector] = [#selector(authorizeTapped), #selector(sendTransactionTapped), #selector(personalSignTapped), #selector(signTypeDataTapped), #selector(callContractTapped)]
        
        for (index, title) in buttonTitles.enumerated() {
            let button = createButton(title: title)
            
            self.view.addSubview(button)
            
            // Set the button's action
            button.addTarget(self, action: buttonSelectors[index], for: .touchUpInside)
            
            // Position the button
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(index * 60)),
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            self.view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                imageView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    public func handleDeepLink(result : String) {
        
        let response = Utils.parseDeepLink(deeplink: result)
        let message = """
                   Address: \(String(describing: response.getAddress()))
                   Success: \(String(describing: response.getSuccess()))
                   Data: \(String(describing: response.getData()))
                   Method: \(String(describing: response.getMethod()))
                   State: \(String(describing: response.getState()))
                   """
        // Create and configure the alert controller
        let alertController = UIAlertController(title: "Mavis ID response", message: message, preferredStyle: .alert)
        
        // Add an OK action to dismiss the alert
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Present the alert
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
        
    }
    
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        
        // Button styling
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        
        return button
    }
    
    
    
    
    @objc func authorizeTapped() -> Void {
        // Implement the action for the Authorize
        let state = Utils.generateRandomState()
        let redirect = "mydapp://callback"

        Task {
            let result = await id.authorize(from: self, state: state, redirect: redirect)
            print("Auth result : " + result)
            // Optional
            self.handleDeepLink(result: result)
        }
    }
    
    @objc func sendTransactionTapped() -> Void {
        // Implement the action for the Send Transaction button
        let state = Utils.generateRandomState()
        let to = "0xD36deD8E1927dCDD76Bfe0CC95a5C1D65c0a807a"
        let value = "100000000000000000"
        Task {
            let result = await id.sendTransaction(from: self, state: state, redirect: redirect, to: to, value: value)
            self.handleDeepLink(result: result)
        }
    }
    
    @objc func personalSignTapped() -> Void {
        let state = Utils.generateRandomState()
        // Implement the action for the Personal Sign button
        Task {
            let result = await id.personalSign(from: self, state: state, redirect: redirect, message: "Hello Axie")
            self.handleDeepLink(result: result)
        }
    }
    
    @objc func signTypeDataTapped() -> Void {
        // Implement the action for the Sign Type Data button
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
        let state = Utils.generateRandomState()
        Task {
            let result = await id.signTypeData(from: self, state: state, redirect: redirect, typedData: typedData)
            self.handleDeepLink(result: result)
        }
    }
    
    @objc func callContractTapped() -> Void {
        // Implement the action for the Call Contract button
        let contractAddress = "0x3c4e17b9056272ce1b49f6900d8cfd6171a1869d"
        let data = "0xa9059cbb000000000000000000000000edb40e7abaa613a0b06d86260dd55c7eb2df2447000000000000000000000000000000000000000000000000016345785d8a0000"
        let state = Utils.generateRandomState()
        Task {
            let result = await id.callContract(from: self, state: state, redirect: redirect, contractAddress: contractAddress, data: data)
            self.handleDeepLink(result: result)
        }
    }
}
