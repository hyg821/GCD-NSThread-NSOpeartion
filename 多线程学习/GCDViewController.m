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
    //[self bx];
    //[self by];
    
    //单例创建方法
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
    //});
    
    //线程同步
    [self threadSynchronization];
}

//串行同步 一个一个执行 同步任务 下一个任务依赖于上一个任务执行完成 就在主线程执行
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
    });
    
    //异步任务
    dispatch_async(ax_queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3");
    });
}

//并行同步 串行执行 不会新开线程 任务回一个一个执行完成 在主线程
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
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
    
    //同步任务
    dispatch_sync(bx_queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"3");
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"%@",[NSThread mainThread]);
    });
}

//并行异步 并行开若干个线程 来执行不同的任务 最常用
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
    });
    
    //异步任务
    dispatch_async(by_queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3");
        NSLog(@"%@",[NSThread currentThread]);
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

@end
