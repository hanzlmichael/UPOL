euro = 27.14
dollar = 23.08

userInput = input("Zadej částku v korunách: ")

value = float(userInput)

print(f"{value} Kč = {value/dollar:.2f} USD")
print(f"{value} Kč = {value/euro:.2f} EUR")