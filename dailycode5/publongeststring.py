#寻找最长公共子串
s1 = 'abcd1321546dee'
s2 = '783jjd32154666babcd'
def sublongest(s1,s2):
    for i in range(len(s1),0,-1):
        for j in range(0,len(s1) - i + 1):
            substr = s1[j:i + j]
            if s2.find(substr) > -1:
                    return substr
print(sublongest(s1,s2))
