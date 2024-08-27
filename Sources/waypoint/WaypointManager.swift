public class WaypointManager {
    static let shared = WaypointManager()
    private var client: Waypoint?

    private init() {}

    func initWaypoint(address: String, clientId: String, chainRpc: String, chainId: Int) {
        if client == nil {
            client = Waypoint(waypointOrigin: address, clientId: clientId, chainRpc: chainRpc, chainId: chainId)
        } else {
            client!.waypointOrigin = address
            client!.clientId = clientId
            client!.chainRpc = chainRpc
            client!.chainId = chainId
        }
    }

    func getClient() -> Waypoint? {
        return client
    }
}
