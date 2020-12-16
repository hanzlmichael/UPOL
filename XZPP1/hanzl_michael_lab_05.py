userInput = input("Zadej text: ") 
key = input("Zadej klic k zasifrovani: ")

encryptedText = ""

for c in userInput:
  if c.isupper():
    encryptedText += chr((ord(c) + int(key) - 65) % 26 + 65)
  else: 
    encryptedText += c

print(f"Zasifrovany text: {encryptedText}")
keyToEncrypt = input("Zadej klic k desifrovani: ")

decryptedText = ""

for c in encryptedText:
  if c.isupper():
    decryptedText += chr((ord(c) - int(key) - 65) % 26 + 65)
  else:
    decryptedText += c

print(f"Desifrovany text: {decryptedText}")