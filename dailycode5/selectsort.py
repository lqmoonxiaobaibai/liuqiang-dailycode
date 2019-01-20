#选择排序
import  random
lst = []
for _  in range(10):
    lst.append(random.randint(1,10))
print(lst)
for i in range(len(lst) - 1):
    maxindex = i
    for j in range(i,len(lst) - 1):
        if lst[maxindex] < lst[j+1]:
            maxindex = j+1
    if maxindex != i:
        lst[maxindex],lst[i] = lst[i],lst[maxindex]
print(lst)
