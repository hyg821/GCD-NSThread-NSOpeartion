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
    
    
    
    
    //创建一个同步任务
    dispatch_sync(global_queue, ^{
        
        //创建一个异步任务
        dispatch_async(global_queue, ^{
            [NSThread sleepForTimeInterval:2];
            [self doSomthing];
        });
        
        //创建一个异步任务
        dispatch_async(global_queue, ^{
            [self dotamax];
        });
        
        //创建一个异步主线程 回调
        dispatch_async(main_queue, ^{
            [self returnMainQueue];
        });
        
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

@end
