#斐波那契数列
#递归效率低下
def fib(n):
    return 1 if n < 2 else fib(n-1) + fib(n-2)
for i in range(5):
    print(fib(i),end='')

#递归效率改进版
pre = 0
cur = 1
print(pre,cur)
def fib(n,pre=0,cur=1):
    pre,cur = cur,pre + cur
    print(cur,end=' ')
    if n == 2:
        return
    fib(n-1,pre,cur)
fib(5)

#lru缓存机制 提升效率
import functools
@functools.lru_cache(maxsize=200)
def fib(n):
    if n < 3:
        return 1
    return fib(n-1) + fib(n-2)
print(fib(35))

