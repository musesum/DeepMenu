enum BorderType {

    case pod    // either icon or text
    case polar  // dock with 2d radians, value control
    case rect   // dock with 2d rectangular XY control
    case dock   // dock with pods
    case hub    // dock as hub for pilot

    public var description: String {
        get {
            switch self {
                case .pod   : return "z⃝"
                case .polar : return "⬈⃝"
                case .rect  : return "⬈⃞"
                case .dock  : return "⠇⃝"
                case .hub   : return "⦿⃝"
            }
        }
    }
}

enum FlightStatus {

    case hover   // staying put or moving inward
    case explore // exlporing dock or subdocks
    case engage  // acting on a leaf

    public var description: String {
        get {
            switch self {
                case .hover   : return "⌂"
                case .explore : return "✶"
                case .draw    : return "✎"
            }
        }
    }
}

enum MuFlightAbove: String  {

    //?? case hub   // unknown at beginning
    case space // flightAbove neither hori or vert
    case spoke  // flightAbove over a spoke's dock

    public var description: String {
        get {
            switch self {
                //?? case .hub   : return "◯"
                case .space : return "▢⃞"
                case .spoke : return "━"
            }
        }
    }
}

