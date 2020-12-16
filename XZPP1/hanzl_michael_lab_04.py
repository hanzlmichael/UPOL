print('Prvocisla: ', end='')
for n in range(2, 100):
  for x in range(2, n):
    if n % x == 0:
      break
  else:
   print(n, end=' ')
