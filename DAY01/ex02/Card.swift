import Foundation

class Card: NSObject {
    var value: Value
    var color: Color
    
    init (color: Color, value: Value) {
        self.value = value
        self.color = color
    }
    
    override var description: String {
        return "Valeur de la carte: \(value) de couleur: \(color)"
    }
    
    static func == (var1: Card, var2: Card) -> Bool {
        return (var1.value == var2.value) && (var1.color == var2.color)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Card {
            return self == object
        }
        return false
    }
}
