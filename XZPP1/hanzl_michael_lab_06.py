def preved(znak):
  x = str(znak)
  if x.isupper():
    return x.lower()
  if x.islower():
    return x.upper()
  if x.isdigit():
    x = int(x)
    if x >= 5:
      x = x + (5 % 10) - 10
      return str(x)
    else:
      x += 5 % 10
      return str(x)
  else:
    return x

retezec = "Ahoj svete, 521."
print(f"Retezec: {retezec}")

upraveny = ""

for i in retezec:
  upraveny += preved(i)

print(f"Upraveny text: {upraveny}")