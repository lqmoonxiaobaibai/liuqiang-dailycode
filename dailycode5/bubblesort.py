#冒泡排序优化
#通过flag标记  例如[1,2,3,4] 这样的列表 已经本身排序好 就无需再次进入每次轮询趟数和判断比较大小  直接输出已经排序好的列表  节省了时间复杂度
#flag标记每次趟数 都不一样 需要重置
lst = [1,2,3,4]
n = len(lst)
count = 0
swap = 0
for i in range(n-1):
    flag = False
    count += 1   #比较趟数
    for j in range(n-1-i):
        if lst[j] > lst[j+1]:
            lst[j],lst[j+1] = lst[j+1],lst[j]
            swap += 1  #交换次数
            flag = True
    if not flag:
        break
print(lst)
print(count,swap)
lst.reverse()
print(lst)
