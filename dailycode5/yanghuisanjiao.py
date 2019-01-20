#一次性开辟最大元素空间 + 折半计算
#[m : ] 代表列表中的第m+1项到最后一项
#[ : n] 代表列表中的第一项到第n项
#list[start:end:step]
#start:起始位置
#end:结束位置
#step:步长
n = 6
row = [1] * n
for i in range(n):
    offset = n - i
    z = 1
    for j in range(1,i//2+1):
        val = z + row[j]
        row[j],z = val,row[j]
        if i != 2*j:
            row[-j-offset] = val
    print(row[:i+1])
