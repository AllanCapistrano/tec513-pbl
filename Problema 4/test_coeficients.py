v = []
with open("coe.txt", "r") as file:
    for line in file.readlines():
        # v.append(int(float(line)*10000))
        v.append(float(line))
# print(v)

with open("result_coe.txt", "a") as file:
    for line in v:
        file.write(f"{line}, ")