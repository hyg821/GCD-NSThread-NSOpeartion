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
    dispatch_queue_t global_queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    NSLog(@"%@",global_queue);
    
    //创建一个并发队列
    dispatch_queue_t create_queue=dispatch_queue_create("hyg", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"%@",create_queue);
    
    //创建一个组
    dispatch_group_t create_group_queue=dispatch_group_create();
    NSLog(@"%@",create_group_queue);
    
    
    //[self ax];
    //[self ay];
    [self bx];
    //[self by];
    
    //单例创建方法
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
    //});
    
    //线程同步
    //[self threadSynchronization];
    
    //线程死锁
    //[self threadDeadlock];
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

@end
