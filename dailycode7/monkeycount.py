#猴子吃桃
def fib(n):
    return 1 if n < 2 else n * fib(n-1)
print(fib(4))

def fac1(n,p=1):
    if n == 1:
        return
    p *= n
    print(p)
    fac1(n-1,p)
fac1(4)


def fac1(n,p=1):
    if n == 1:
        return p
    p *= n
    #print(p)
    fac1(n-1,p)
    return p
#fac1(4)
#最终返回4 而不是24 facl（4）递归facl(1) 压栈 再反过来 出栈返回
#最后到facl(4)出栈时 return p  这时p的值是4
a = fac1(4)
print(a)


num = '12345'
length = len(num)
lst = []
def fib(stringlength):
    if stringlength > 0:
        lst.append(int(num[stringlength - 1]))
    else:
        return
    fib(stringlength - 1)
fib(length)
print(lst)
