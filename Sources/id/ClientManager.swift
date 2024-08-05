public class ClientManager {
    static let shared = ClientManager()
    private var client: Client?

    private init() {}

    func initClient(address: String, clientId: String, chainRpc: String, chainId: Int) {
        if client == nil {
            client = Client(address: address, clientId: clientId, chainRpc: chainRpc, chainId: chainId)
        } else {
            client!.address = address
            client!.clientId = clientId
            client!.chainRpc = chainRpc
            client!.chainId = chainId
        }
    }

    func getClient() -> Client? {
        return client
    }
}
