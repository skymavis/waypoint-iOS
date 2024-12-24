public final class WaypointManager {
    // Singleton instance
    public static let shared = WaypointManager()
    private var waypointClient: Waypoint?

    private init() {}

    public func configure(
        waypointOrigin: String,
        clientId: String,
        redirectUri: String,
        rpcUrl: String,
        chainId: Int
    ) {
        guard waypointClient == nil else { return }

        waypointClient = Waypoint(
            waypointOrigin: waypointOrigin,
            clientId: clientId,
            redirectUri: redirectUri,
            rpcUrl: rpcUrl,
            chainId: chainId
        )
    }

    public var client: Waypoint? {
        return waypointClient
    }
}
