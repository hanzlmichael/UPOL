def whatIsThisSymbol(arg):
    x = str(arg)
    if x.isupper():
        print("Velke pismeno")
    elif x.islower():
        print("Male pismeno")
    elif x.isdigit():
        print("Cislice")
    elif x == '!':
        print("Vykricnik")
    elif x == '@':
        print("Zavinac")
    elif x == '#':
        print("Krizek")
    elif x == '?':
        print("Otaznik")
    elif x == '*':
        print("Hvezdicka")
    else:
        print("Jiny znak")

# -------------------------------------------------------------

userInput = input("Zadejte znak: ")
whatIsThisSymbol(userInput)
