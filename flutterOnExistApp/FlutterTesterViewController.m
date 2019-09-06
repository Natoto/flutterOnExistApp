//
//  ViewController.m
//  flutterOnExistApp
//
//  Created by boob on 2018/10/9.
//  Copyright © 2018年 YY.Inc. All rights reserved.
//

#import "FlutterTesterViewController.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
#import "SMDNetWork.h"
#import <SSZipArchive/SSZipArchive.h>

//#import <FLEX/FLEX.h>

@interface FlutterTesterViewController ()
@property (nonatomic, weak) FlutterViewController * ctr;
@property (nonatomic, weak) FlutterEngine * engine;
@end

@implementation FlutterTesterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
 
    float Y = 210;
    [self createButton:@"加载boundle资源" frame:CGRectMake(80.0, Y, 160.0, 40.0) action:@selector(handleBoundleResource )];
  
    Y += 40.0 + 10;
    [self createButton:@"autorelease" frame:CGRectMake(80.0, Y, 160.0, 40.0) action:@selector(handleAutoRelase)];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"flutter_assets"] ;
    NSLog(@"path: %@",path);
    
}

-(void)handleNetWorkResource:(UIButton *)button{
 
}

/** 
* 加载boundle资源 
*/
- (void)handleBoundleResource {
    
    FlutterDartProject * dart = [[FlutterDartProject alloc] init];
    FlutterEngine * engine = [[FlutterEngine alloc] initWithName:@"ios.dart.flutter"
                                                         project:dart];
    [engine runWithEntrypoint:nil];
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    [self addBackButton:flutterViewController];
     [flutterViewController setInitialRoute:@"route1"];
    [self presentViewController:flutterViewController animated:YES completion:nil];
    self.engine = engine;
}

-(void)handleAutoRelase{
 /*
     FlutterBasicMessageChannel* channel;
     FlutterEngine * engine; 
   __weak  FlutterViewController* vc ;
    NSArray * array;
    @autoreleasepool {
        NSMutableArray * ary = [NSMutableArray arrayWithArray:@[@1,@2,@3]];
        array = ary; 
        FlutterViewController* flutterViewController = [FlutterViewController new];
        vc = flutterViewController;
        engine = flutterViewController.engine; 
        NSLog(@"engine111:%@",engine);
        channel = flutterViewController.engine.systemChannel;         
    }
    NSLog(@"engine222:%@",engine);
    NSLog(@"array:%@",array);
    NSLog(@"vc:%@",vc);
    [channel sendMessage:@"Hello!"];
    [channel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) { }];
    
    */
}

-(void)addBackButton:(UIViewController *)flutterViewController{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, 100, 50, 30);
        [btn addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [flutterViewController.view addSubview:btn];
        self.ctr = flutterViewController;
    });
}

-(void)buttonTap:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    
    __weak __typeof(self)weakSelf = self;
    [self.ctr dismissViewControllerAnimated:YES completion:^{
        
        //[weakSelf.engine destroyContext];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UIButton *)createButton:(NSString *)title frame:(CGRect)frame action:(SEL)selector{
 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    UIColor * bgcolor = [UIColor colorWithRed:arc4random()%256/255. green:arc4random()%256/255. blue:arc4random()%256/255. alpha:1];
    [button setBackgroundColor:bgcolor];
    button.frame = frame;
    [self.view addSubview:button];
    return button;
}

@end
