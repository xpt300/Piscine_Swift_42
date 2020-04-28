var card1 = Card(color: Color.Coeur, value: Value.As)

print(card1.description)

var card2 = Card(color: Color.Coeur, value: Value.Roi)

print(card2.description)

print(card1.isEqual(card2))

card1 = Card(color: Color.Carreau, value: Value.Dame)

print(card1.description)
card2 = Card(color: Color.Carreau, value: Value.Dame)

print(card2.description)

print(card1.isEqual(card2))
