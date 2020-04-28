print("Test de trillage du deck, deck non trié")
print(Deck.init(bool: false))

print("\nDeck trié")
var jeu = Deck.init(bool: true)
print(jeu)

print("\nOverride de description")
print(jeu)

print("\nMontrer la premiere carte du paquet")
var carte1 = jeu.draw()!
print(carte1)

print("\nMontrer la seconde carte du paquet")
var carte2 = jeu.draw()!
print(carte2)

print("\nMontrer la sortie out: ")
print(jeu.outs)

print("\nOn jette les cartes et on montre la sortie defausse: ")
jeu.fold(c : carte1)
jeu.fold(c : carte2)
print(jeu.discards)
