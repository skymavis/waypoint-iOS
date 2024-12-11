public final class WaypointManager {
    // Singleton instance
    public static let shared = WaypointManager()
    private var waypointClient: Waypoint?

    private init() {}

    public func configure(
        waypointOrigin: String,
        clientId: String,
        redirectUri: String,
        isTestnet: Bool = false
    ) {
        guard waypointClient == nil else { return }

        waypointClient = Waypoint(
            waypointOrigin: waypointOrigin,
            clientId: clientId,
            redirectUri: redirectUri,
            isTestnet: isTestnet
        )
    }

    public var client: Waypoint? {
        return waypointClient
    }
}
