//
//  NSThreadViewController.m
//  多线程学习
//
//  Created by 侯英格 on 16/4/27.
//  Copyright © 2016年 侯英格. All rights reserved.
//

#import "NSThreadViewController.h"

@interface NSThreadViewController ()
@property(nonatomic,strong)NSThread*myThread;

//--------------------demo---------------------
@property(nonatomic,assign)NSInteger busTicketNum;
@property(nonatomic,strong)NSThread*threadOne;
@property(nonatomic,strong)NSThread*threadTwo;

@end

@implementation NSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"NSThreadViewController";
    
    //[self creatThread];
    
    [self startDemo];
}

-(void)startDemo{
    //火车票还剩200张
    self.busTicketNum=200;
    self.threadOne=[[NSThread alloc] initWithTarget:self selector:@selector(buyTicketOneWay) object:nil];
    self.threadOne.name=@"threadOne";
    self.threadTwo=[[NSThread alloc] initWithTarget:self selector:@selector(buyTicketTwoWay) object:nil];
    self.threadTwo.name=@"threadTwo";
}

- (IBAction)startStartDemo:(id)sender {
    [self.threadOne start];
    [self.threadTwo start];
}

-(void)buyTicketOneWay{
    while (self.busTicketNum>0) {
        [NSThread sleepForTimeInterval:1.5];
        self.busTicketNum-=2;
        NSLog(@"线程1执行----当前火车票还剩%ld张",(long)self.busTicketNum);
    }
}

-(void)buyTicketTwoWay{
    while (self.busTicketNum>0) {
        [NSThread sleepForTimeInterval:0.5];
        self.busTicketNum-=1;
        NSLog(@"线程2执行----当前火车票还剩%ld张",(long)self.busTicketNum);
    }

}

-(void)creatThread{
    //普通的-方法创建 会返回一个thread对象 必须手动 start 一下才会执行方法
    self.myThread=[[NSThread alloc] initWithTarget:self selector:@selector(newThread:) object:@"lalal"];
    //设置名字
    self.myThread.name=@"hygThread";
    //设置优先级
    [self.myThread setThreadPriority:20];
    [self.myThread start];
    
    //是否正在运行
    //self.myThread.isExecuting;
    //是否已经结束
    //self.myThread.isFinished;
    //是否被干掉了
    //self.myThread.isCancelled;
    
    //类方法创建 不会翻译thread对象 直接执行对应方法
    //[NSThread detachNewThreadSelector:@selector(newThread:) toTarget:self withObject:nil];
    
    //除了主线程之外所有线程退出？ 不确定 也没有试验出来
    //[NSThread exit];
}

-(void)newThread:(id)object{
    //当前线程暂停 这个方法是主线程 或者子线程 都是暂停当前线程
    [NSThread sleepForTimeInterval:3];
    //[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    //获取当前线程 同样的这个方法 被那个线程执行 他就拿到这个线程
    NSThread*thread=[NSThread currentThread];
    NSLog(@"%d",[thread isEqual:self.myThread]);
    //获取主线程
    NSThread*mainThread=[NSThread mainThread];
    NSLog(@"%d",[mainThread isEqual:thread]);
    
    for (int i=0; i<100; i++) {
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"%d",i);
        if (self.myThread.isCancelled==YES) {
            break;
        }
    }
    
    //当前线程回归主线程执行对应的方法 waitUntilDone 并且是否要等待主线程方法执行完 再继续执行子线程的剩余方法
    [self performSelectorOnMainThread:@selector(returnToMainThread) withObject:nil waitUntilDone:NO];
    //和上边的方法一样只不过指定了模式
    //[self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#> modes:<#(nullable NSArray<NSString *> *)#>]
    
    //进入子线程执行某个方法
    [self performSelectorInBackground:@selector(backgroundThread) withObject:nil];
    //在某个指定线程里执行方法
    [self performSelector:@selector(backgroundThread) onThread:self.myThread withObject:nil waitUntilDone:YES];
    
    //在某个指定线程里执行方法 并且是一种模式
    //[self performSelector:<#(nonnull SEL)#> onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#> modes:<#(nullable NSArray<NSString *> *)#>];
    
    //这四个方法都是在当前线程执行一个方法 而已
    [self performSelector:@selector(returnToMainThread)];
    [self performSelector:@selector(returnToMainThread) withObject:nil];
    [self performSelector:@selector(returnToMainThread) withObject:nil withObject:nil];
    [self performSelector:@selector(returnToMainThread) withObject:nil afterDelay:0];

}


- (IBAction)cancelThread:(id)sender {
    //取消线程 注意并不能直接中断线程的方法 只能是给线程做一个标记 然后自己通过isCancelled 来判断中断方法 return
    [self.myThread cancel];
}


-(void)returnToMainThread{
    NSThread*thread=[NSThread currentThread];
    NSThread*mainThread=[NSThread mainThread];
    NSLog(@"%d",[mainThread isEqual:thread]);
}

-(void)backgroundThread{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
