#求素数最优算法
#把所有偶数去掉
#10以后的素数 结尾是1 3 7 9  5不行  去掉
#取余时 循环开方一半即可   并且把偶数去掉
#因为 所有奇数 不能整除偶数 只算奇数即可
count = 1
for x  in range(3,100000,2):
    if x > 10 and x % 10 == 5:
        continue
    for i in range(3,int(x ** 0.5 ) + 1,2):
        if x % i == 0:
            break
    else:
        count +=  1
        print(x,count)
