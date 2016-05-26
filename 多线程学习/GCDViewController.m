//
//  GCDViewController.m
//  多线程学习
//
//  Created by 侯英格 on 16/4/27.
//  Copyright © 2016年 侯英格. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()
@property(nonatomic,assign)NSInteger totalCount;
@property(nonatomic,strong)NSLock*lock;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"GCDViewController";
    self.totalCount=10;
    
    
    //队列 的 串行并行 是对于我的任务而言的
    //队列只是一种 执行顺序 并不会新开线程
    //只有异步任务 才会开一个新的线程
    //串行的本质 就是  执行 下一个任务 总是依赖与 上一个 任务是否开始执行
    //并行的本质 就是  执行 下一个任务 并不依赖于 上一个 任务
    
    
    //dispatch_sync(ax_queue, ^{
    //});
    
    
    //同步的本质 就是  执行 任务是否是 dispatch_sync +block里的代码一起执行完 不开线程执行block里的代码
    //异步的本质 就是  执行 任务是否是 dispatch_async +block里的代码不是一起执行完 新开一个线程来执行block里的代码
    
    
    //本质就是   队列(queue) --> 任务dispatch_sync//dispatch_sync
    
    //a->串行队列  x->同步任务
    //b->并行队列  y->异步任务
    
    //ax 串行同步, ay 串行异步, bx 并行同步, by 并行异步
    
    //拿到主线程 队列
    dispatch_queue_t main_queue=dispatch_get_main_queue();
    NSLog(@"%@",main_queue);
    
    //拿到全局队列 通过下边的参数来决定队列是串行 还是并行
    //DISPATCH_QUEUE_SERIAL 串行
    //DISPATCH_QUEUE_CONCURRENT 并行
    
    //队列优先级
    //QOS_CLASS_USER_INTERACTIVE
    //QOS_CLASS_USER_INITIATED
    //QOS_CLASS_DEFAULT
    //QOS_CLASS_UTILITY
    //QOS_CLASS_BACKGROUND
    //QOS_CLASS_UNSPECIFIED
    
    //队列优先级
    //DISPATCH_QUEUE_PRIORITY_HIGH
    //DISPATCH_QUEUE_PRIORITY_DEFAULT
    //DISPATCH_QUEUE_PRIORITY_LOW
    //DISPATCH_QUEUE_PRIORITY_BACKGROUND
    
    dispatch_queue_t global_queue=dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE,0);
    NSLog(@"%@",global_queue);
    
    //创建一个并发队列
    dispatch_queue_t create_queue=dispatch_queue_create("hyg", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"%@",create_queue);
    
    //创建一个组
    dispatch_group_t create_group_queue=dispatch_group_create();
    NSLog(@"%@",create_group_queue);
    
    //同步异步 串行并行 组合
    //[self ax];
    //[self ay];
    //[self bx];
    //[self by];
    
    //单例创建方法
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
    //});
    
    //线程同步
    //[self threadSynchronization];
    
    //线程死锁
    //[self threadDeadlock];
    
    //例子一
    //[self exampleOne];
    
    //通过信号量 来决定 能有几个异步任务 同时执行
    //[self exampleTwo];
    
    //线程延时
    [self exampleThree];
    
    //dispatch_barrier_async 异步中的同步
    //[self exampleFour];
    
    //代替for操作
    //[self exampleFive];
}

//串行同步 一个一个执行 同步任务 下一个任务依赖于上一个任务执行完成 就在主线程执行 所以会卡线程
-(void)ax{
    //串行队列
    dispatch_queue_t ax_queue=dispatch_queue_create("ax", DISPATCH_QUEUE_SERIAL);
    //同步任务
    dispatch_sync(ax_queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //同步任务
    dispatch_sync(ax_queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2");
    });
    
    //同步任务
    dispatch_sync(ax_queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3");
    });
}

//串行异步 一个一个执行 异步任务 下一个任务依赖于上一个任务执行完成 会新开一个线程来执行任务
-(void)ay{
    //串行队列
    dispatch_queue_t ax_queue=dispatch_queue_create("ay", DISPATCH_QUEUE_SERIAL);
    //异步任务
    dispatch_async(ax_queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //异步任务
    dispatch_async(ax_queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //异步任务
    dispatch_async(ax_queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
}

//并行同步 本来应该是 并行执行任务的 但是 因为执行的是同步任务 dispatch_sync+block里的代码是一起执行的 所以才会 一个任务执行完成之后 下一个任务才开始执行 因为是同步任务 所以不会开新线程 所以 在主线程
-(void)bx{
    //并行队列
    dispatch_queue_t bx_queue=dispatch_queue_create("bx", DISPATCH_QUEUE_CONCURRENT);
    //同步任务
    dispatch_sync(bx_queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);

    });
    
    //同步任务
    dispatch_sync(bx_queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //同步任务
    dispatch_sync(bx_queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
}

//并行异步 并行执行dispatch_async 开若干个线程 来执行不同的任务 最常用
-(void)by{
    //并行队列
    dispatch_queue_t by_queue=dispatch_queue_create("by", DISPATCH_QUEUE_CONCURRENT);
    //异步任务
    dispatch_async(by_queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //异步任务
    dispatch_async(by_queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //异步任务
    dispatch_async(by_queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
}

-(void)doSomthing{
    NSLog(@"doSomthing");
}

-(void)dotamax{
    NSLog(@"dotamax");
}

-(void)returnMainQueue{
    NSLog(@"returnMainQueue");
}

-(void)dealloc{
    NSLog(@"2");
}

-(void)threadSynchronization{
    dispatch_group_t group=dispatch_group_create();
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i=1; i<7; i++) {
        dispatch_group_async(group, backgroundQueue, ^{
            int a=1;
            for (int j=0; j<800; j++) {
                a+=i;
                if (a>800) {
                    NSLog(@"我是线程%d 我完成了",i);
                    return ;
                }
            }
        });
    }
    //等group的任务都完成了 才会执行下方block的任务
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"全都完成了");
    });
}

-(void)threadDeadlock{
    //为什么会发生死锁
    //首先队列是串行队列 在一个并发任务里 执行一个同步任务  串行队列是一个任务一个任务的执行 所以 同步任务需要等待异步任务执行完成 但是同步任务又是在异步任务里边 所以 异步执行同步 同步又依赖异步  所以形成死锁
    
    
    //串行队列
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    //并行任务
    dispatch_async(myQueue, ^{
        NSLog(@"1----");
        /**
         *  线程死锁
         */
        //串行任务
        dispatch_sync(myQueue, ^{
            NSLog(@"-%@",[[NSThread currentThread] isMainThread]?@"--主线程":@"分线程");
        });
        NSLog(@"2------");
    });
}

-(void)exampleOne{
    //queue1 是串行队列 queue2是并行
    //开了三个异步任务 queue1 是串行 所以会执行完block1 才执行block2
    //queue2 是并行队列 再加上异步任务 所以他会和block1 并行执行
    //所以出现了 + - 交互出现 最后出现=
    
    
    dispatch_queue_t queue1=dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2=dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue1, ^{    // block1
        for (int i = 0; i < 5; i ++) {
            NSLog(@"+++++");
        }
    });
    
    dispatch_async(queue1, ^{ // block2
        for (int i = 0; i < 5; i ++) {
            NSLog(@"=====");
        }
    });
    
    dispatch_async(queue2, ^{    // block3
        for (int i = 0; i < 5; i ++) {
            NSLog(@"----");
        }
    });
}


-(void)exampleTwo{
    //创建信号量  信号量的大小决定了 线程同时能开几个 如果信号量不够大 那么新线程就会被阻塞 等待老线程结束 才能继续执行
    dispatch_semaphore_t semaphore= dispatch_semaphore_create(1);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //为什么信号量要 -1 之后再+1 因为 如果我们想让3个线程同时执行 这时候有四个线程准备执行 那么我在执行任务的时候 显然信号量 -1 三个线程都-1 那么信号量=0 第四个线程准备创建的时候 发现信号量=0 所以不能创建 随后三个线程都执行到dispatch_semaphore_signal 信号量+1 这时候信号量恢复了3 又能重新创建三个线程  这样就能保证 有且仅有三个或者三个一下的线程同时运行
        //在yykit 里他在创建单例的时候 使用了这种方式 作用等同于锁 为了只能有一个线程执行操作
        
        
        //dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"hyg 开始行动");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"hyg 行动结束");
        //是信号量 +1 当这个任务执行到这里的时候 信号量+1 新线程不被继续阻塞 所以位置二号那个线程 能继续执行
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"未知一号 开始行动");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"未知一号 行动结束");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"未知二号 开始行动");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"未知二号 行动结束");
        dispatch_semaphore_signal(semaphore);
    });
}

-(void)exampleThree{
    //1.第一种用法
    /* NSEC_PER_SEC 秒
     * NSEC_PER_MSEC 毫秒
     * NSEC_PER_USEC 微秒
     */
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 3ull *NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //执行操作
        NSLog(@"after 3s");
    });
    
    //2.第二种用法
    //<#dispatch_function_t work#> --执行的c语言方法
    dispatch_after_f(dispatch_time(DISPATCH_TIME_NOW, 3ull *NSEC_PER_SEC), dispatch_get_main_queue(), NULL, fun1);
    
    
    //3.第三种用法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5ull * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after 5s");
    });
    
    
    //1.不是一定时间后执行相应的任务，而是一定时间后，将执行的操作加入到队列中（队列里面再分配执行的时间）
    //2.主线程 RunLoop 1/60秒检测时间，追加的时间范围 3s~(3+1/60)s
    
    
}

void fun1(){
    NSLog(@"after 3s");
}


-(void)exampleFour{
    dispatch_queue_t queue = dispatch_queue_create("gcdtest", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"dispatch_async1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async2");
    });
    
    //dispatch_barrier_async是一种同步操作，在其前面的任务执行结束后它才执行，而且其后面的任务等它执行完成之后才会执行。 也就是说 它的执行 一定是 前边的任务执行完了 他才执行  他后边的任务 一定等他执行完了 才执行  多个异步之间 放入一个 同步任务
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:8];
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");
    });
}

-(void)exampleFive{
    int count=10;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(count, queue, ^(size_t i) {
        printf("%zu\n",i);
    });
}

@end
