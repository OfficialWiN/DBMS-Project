import csv
import random
from itertools import combinations, product

with open("candidate.csv") as r:
    reader = csv.reader(r)
    next(reader)
    first = set()
    last = set()
    for line in reader:
        try:
            ln, fn = tuple(i.strip() for i in line[0].split(","))
            first.add(fn.split()[0])
            last.add(ln)
        except:
            pass

joint_second_names = random.sample(last, 85)
c = combinations(joint_second_names, 2)
# c = combinations(last, 2)
last.update(list("-".join(i) for i in c))

final_names = []
# cnt=  0
for i in product(first, last):
    # cnt+=1
    final_names.append(f"{i[0]} {i[1]}")
random.shuffle(final_names)
# print(cnt)

with open("candidate_names.txt", "w") as w:
    for i in final_names:
        w.write("{}\n".format(i))


