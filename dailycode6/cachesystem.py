# 简单实现cache装饰器函数 且 有过期被清除的功能
import inspect
import time
from collections import OrderedDict
import datetime
from functools  import wraps

def cache(duration):
    def locache(fn):
        # 字典数据结构用于缓存的键值对
        local_cache = {}
        @wraps(fn)
        def wrapper(*args, **kwargs):
            # 清除过期key函数
            def clear_expire(cache):
                # 如果缓存为空 就立即停止  否则检查缓存的key
                if cache == {}:
                    print('null')
                    return
                else:
                    print('not null')
                    expire_keys = []
                    for k, (_, stamp) in cache.items():
                        now = datetime.datetime.now().timestamp()
                        if now - stamp > duration:
                            expire_keys.append(k)
                    for k in expire_keys:
                        cache.pop(k)
                    # 检查缓存中过期的key全部清除

            #执行过期清除函数
            clear_expire(local_cache)

            #定义生成key的函数
            def make_key(fn):
                sig = inspect.signature(fn)
                params = sig.parameters  # 有序字典
                keys = list(params.keys())  # 把函数签名的参数变量取出来 放入字典中
                params_dict = OrderedDict()  # 定义有字典 存放位置参数 关键字参数 缺省值
                # 位置参数 add(4,5,z=6) add(4,y=5,z=6)
                for i, val in enumerate(args):
                    k = keys[i]
                    params_dict[k] = val  # {'x':4,'y':5}
                # 缺省值和关键字参数 传递实参 会漏掉 需要从fn函数签名 拿出所有参数
                for k, param in params.items():
                    # 判断k是否在有序字典中 即key的字典中
                    if k not in params_dict.keys():
                        # 如果不在  判断k是否在关键字参数字典中
                        if k in kwargs.keys():
                            params_dict[k] = kwargs[k]
                        # 不在关键字参数字典中  而是缺省值 需要从函数签名中取值
                        else:
                            params_dict[k] = param.default
                # 把k,v放入到元组中
                return tuple(params_dict.items())

            #调用包装的函数make_key 把函数fn送进去 把实参 x y z 和 数值全部生成key 再查缓存
            key = make_key(fn)
            # 查询缓存
            # 如果有缓存 直接返回   反之 则加入缓存
            if key not in local_cache.keys():
                #创建k,v 增加时间戳到value中
                local_cache[key] =  (fn(*args, **kwargs),datetime.datetime.now().timestamp())
            return key,local_cache[key]
        return wrapper
    return locache


# 测试运行效果时间
def logger(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        start = datetime.datetime.now()
        ret = fn(*args, **kwargs)
        delta = (datetime.datetime.now() - start).total_seconds()
        print(fn.__name__, delta)
        return ret

    return wrapper


@logger
#过期时间设定为5s
@cache(5)
def add(x, y=5, z=6):
    time.sleep(5)
    return x + y + z


# 以下运行效果是一致的 均被缓存
add(4, 5, z=6)
time.sleep(6)
add(4, y=5, z=6)
#add(4, 5, 6)
#add(x=4, z=6, y=5)
add(4, z=6)
#print(add.__name__)