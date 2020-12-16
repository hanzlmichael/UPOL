myNumber = 1234

a = myNumber // 1000
b = myNumber // 100
b = b % 10
c = myNumber // 10
c = c % 10
d = myNumber // 1
d = d % 10

print(f"Prvni cislo je {a}")

print(f"Druhe cislo je {b}")

print(f"Treti cislo je {c}")

print(f"Ctvrte cislo je {d}")