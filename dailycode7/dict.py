s = {'a':{'b':1,'c':2},'d':{'e':3,'f':{'g':4}},'g':5}
k2 = ''
def fib(dic:dict,d = {},k1=''):
    for k,v in dic.items():
        if isinstance(v,dict):
            k2 = k1 + k + '.'
            fib(v,k1=k2)
        else:
            d[k1 + k] = v
    return d
print(fib(s))
