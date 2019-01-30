#九九乘法表
for i in range(1,10):
    for j in range(1,i+1):
        print("%d*%d=%d\t" % (i,j,i*j),end='')
    print('')

#第二种写法： 字符串拼接 每一行 都是一个字符串拼接 打印
for i in range(1,10):
    s = ""
    for j in range(1,i+1):
        s += str(j) + '*' + str(i) + '=' + str(i*j) + '\t'
    print(s)

#第三种写法：format格式
for i in range(1,10):
    for j in range(1,i+1):
        print('{}*{}={:<2}\t'.format(j,i,j*i),end="")
    print()

for i in range(1,10):
    for j in range(1,i+1):
        product = i*j
        if j > 1 and product < 10:
            product = str(product) + ' '
        else:
            product = str(product)
        print(str(j)+'*'+str(i)+"="+product,end=' ')
    print()

#上三角九九乘法表
for i in range(1,10):
    for j in range(1,10):
            if j < i:
                print('        ',end='')
            else:
                print('{}*{}={:<2}\t'.format(i,j,i*j),end='')
    print('')

for a in range(1, 10):
    tmp = ''
    for b in range(a, 10):
        tmp += '{} * {}={:<{}}'.format(a, b, a*b, 2 if b < 4 else 3)
    print('{:>80}'.format(tmp))

for a in range(1, 10):
    tmp = ''
    for b in range(a, 10):
        tmp += '{}*{}={:<3}'.format(a, b, a*b)
    print('{:>70}'.format(tmp))
