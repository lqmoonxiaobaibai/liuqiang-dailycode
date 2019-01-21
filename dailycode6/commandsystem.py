#建立空字典 用于存放命令与函数的映射关系
#ls => ls()
#grep => grep()
cmds = {}

#用户输入命令界面
def runnergui():
    # 装饰器-注册函数
    def reg(cmd):
        def _reg(fn):
            cmds[cmd] = fn
            return fn
        return _reg
    # 默认函数
    def default_func():
        def default():
            print('未知命令!')
        while True:
            cmd = input('>>').strip()
            if cmd == 'quit':
                break
            #从字典中获取k,v
            #如果没有对应的k值 则返回默认函数default_ func
            #必须加() 因为get返回是函数名  必须加()才能函数调用 输出结果
            cmds.get(cmd,default)()
    return  reg,default_func

reg,runner = runnergui()

@reg('mag')#等价  reg('mag')(mag)
def mag():
    print("magedu")

@reg('py')
def py():
    print('python')

runner()
