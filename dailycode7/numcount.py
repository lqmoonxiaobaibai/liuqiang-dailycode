#最高效算法 采取awk关联数组思想
#字符串中的0-9这十个数字 作为列表索引
#同时这个数字 累加的次数 作为列表的元素
#下次打印列表时  索引就是每位的数字 元素就是每位出现的次数
stringnum = input('Please input your num:')
stringnum1 = stringnum.lstrip('0')
print('该数字位数为：',len(stringnum1))
lst1 = ('个位','十位','百位','千位','万位','十万','百万','千万','亿')
lst = [0] * 10
for i in range(1,len(stringnum1)+1):  #效率 就是一趟n  直接累计次数
    print('{}:{}'.format(lst1[i-1],stringnum1[-i]))
    lst[int(stringnum1[-i])] += 1
print()
print('打印每一位及其出现的次数：')
for j in range(10):
    if lst[j]:
        print('数字{} 次数{}'.format(j,lst[j]))
