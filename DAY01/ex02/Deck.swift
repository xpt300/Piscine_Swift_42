import Foundation

class Deck: NSObject {
    static let allSpades = Value.allValues.map {
        return (Card(color: Color.Pique, value: $0))
    }
    static let allDiamonds = Value.allValues.map {
        return (Card(color: Color.Carreau, value: $0))
    }
    static let allHearts = Value.allValues.map {
        return (Card(color: Color.Coeur, value: $0))
    }
    static let allClubs = Value.allValues.map {
        return (Card(color: Color.Trefle, value: $0))
    }
    static let allCards = allSpades + allDiamonds + allHearts + allClubs
}
