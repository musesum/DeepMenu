enum BorderType {

    case node    // either icon or text
    case polar  // branch with 2d radians, value control
    case rect   // branch with 2d rectangular XY control
    case branch   // branch with nodes
    case root    // branch as root for pilot

    public var description: String {
        get {
            switch self {
                case .node   : return "z⃝"
                case .polar : return "⬈⃝"
                case .rect  : return "⬈⃞"
                case .branch  : return "⠇⃝"
                case .root   : return "⦿⃝"
            }
        }
    }
}

enum FlightStatus {

    case hover   // staying put or moving inward
    case explore // exlporing branch or subbranches
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

    case space // flightAbove neither hori or vert
    case limb  // flightAbove over a limb's branch

    public var description: String {
        get {
            switch self {
                case .space : return "▢⃞"
                case .limb : return "━"
            }
        }
    }
}

