a = 6
b = 2**6
c = 5000//b
print(b)
for d in range(b):
    print(f'{d:06b} - {d*c-c//2:04} - {d*c} - {d*c+c//2:04}')