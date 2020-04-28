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
    
	var cards : [Card] = allSpades + allDiamonds + allHearts + allClubs
    var discards : [Card] = []
    var outs : [Card] = []
    
    init (bool: Bool) {
        if (bool) {
            cards = cards.random()
        }
    }
    
    override var description: String {
        var array : [String] = [String]()
        for card in self.cards {
            array.append("\(card)")
        }
        return "\(array)"
    }
    
    func draw() -> Card? {
        let firstCard : Card? = self.cards.first
        if (firstCard != nil) {
            outs.append(cards[0])
            cards.remove(at: 0)
            return firstCard
        }
        return nil
    }
    
    func fold(c : Card) {
        var bool: Bool = false
        for card in outs {
            if (c.value == card.value && c.color == card.color) {
                bool = true
            }
        }
        if (bool) {
            discards.append(c)
        }
    }
}

extension Array {
    func random() -> [Element] {
        var cardsArray = self
        var newArray: [Element] = [Element]()
        var i = 0
        while i < 52 {
            let number = Int(arc4random_uniform(UInt32(cardsArray.count)))
            newArray.append(self[number])
            cardsArray.remove(at: number)
            i += 1
        }
        return newArray
    }
}
