#插入排序
lst = [2,9,8,1,7,1,3,0,2,5,6]
num = [0]
lst1 = num + lst
length = len(lst1)
for i in range(2,length):
    lst1[0] = lst1[i]
    j = i - 1
    if lst1[j] > lst1[0]:
        while lst1[j] > lst1[0]:
            lst1[j+1] = lst1[j]
            j -= 1
        lst1[j+1] = lst1[0]
#打印时  需要从1开始 索引0的位置元素为哨兵元素
for i in range(1,length):
    print(lst1[i],end='')
