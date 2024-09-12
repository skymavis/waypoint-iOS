public class ClientManager {
    static let shared = ClientManager()
    private var client: Waypoint?

    private init() {}

    func initClient(waypointOrigin: String, clientId: String, chainRpc: String, chainId: Int) {
        if client == nil {
            client = Waypoint(waypointOrigin: waypointOrigin, clientId: clientId, chainRpc: chainRpc, chainId: chainId)
        } else {
            client!.waypointOrigin = waypointOrigin
            client!.clientId = clientId
            client!.chainRpc = chainRpc
            client!.chainId = chainId
        }
    }

    func getClient() -> Waypoint? {
        return client
    }
}
