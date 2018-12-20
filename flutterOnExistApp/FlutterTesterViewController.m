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
    
    
    [self createButton:@"加载boundle资源" frame:CGRectMake(80.0, 210.0, 160.0, 40.0) action:@selector(handleBoundleResource )];

    [self createButton:@"加载doc资源" frame:CGRectMake(80.0, 260.0, 160.0, 40.0) action:@selector(handleDocumentButtonAction:)];

    [self createButton:@"加载网络资源" frame:CGRectMake(80.0, 310.0, 160.0, 40.0) action:@selector(handleNetWorkResource:)];

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"flutter_assets"] ;
    NSLog(@"path: %@",path);
    
}

-(void)handleNetWorkResource:(UIButton *)button{

  /*  //https://file.io/L6Ogcg
    button.enabled = NO;
    __weak __typeof(self)weakSelf = self;
    void (^unzipCompleteBlock)(NSString * tempZipDir) = ^(NSString *tempZipDir) {
           NSString * unZipDir  = [tempZipDir stringByAppendingPathComponent:@"flutter_assets"];
              NSURL * url = [NSURL URLWithString:unZipDir ];
            FlutterDartProject * dart = [[FlutterDartProject alloc] initWithFlutterAssets:url dartMain:nil packages:nil];
            FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:dart nibName:nil bundle:nil];
            [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
        
            [weakSelf addBackButton:flutterViewController];
 
             [flutterViewController setInitialRoute:@"route1"];
            [weakSelf presentViewController:flutterViewController animated:YES completion:nil];
        };
    
    [self get_remote_flutterassets:@"http://phe7wo0ui.bkt.clouddn.com/flutter_assets.zip" progress:^(float progress) {
        button.enabled = NO;
        [button setTitle:[NSString stringWithFormat:@"%.2f%%",100*progress] forState:UIControlStateDisabled];
    } complete:^(NSString *localpath) {
        button.enabled = YES;
        unzipCompleteBlock(localpath);
    }];
  */
}

/** 
* 加载boundle资源 
*/
- (void)handleBoundleResource {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"flutter_assets" ofType:@""];
    NSURL * url = [NSURL URLWithString:path];
    FlutterDartProject * dart = [[FlutterDartProject alloc] init];
    if (!self.engine) {
        FlutterEngine * engine = [[FlutterEngine alloc] initWithName:path.lastPathComponent project:dart];
        [engine runWithEntrypoint:nil];
        self.engine = engine;
    }
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithEngine:self.engine nibName:nil bundle:nil];
    
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    
    [self addBackButton:flutterViewController];
 
     [flutterViewController setInitialRoute:@"route1"];
    [self presentViewController:flutterViewController animated:YES completion:nil];
    
}

- (void)handleDocumentButtonAction:(UIButton *)button {

    
    NSString * url = @"https://static.moschat.com/mobilePlugin/mobilePlugin_1545200622670.zip";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"flutter_assets_download/%@/flutter_assets",url.lastPathComponent]] ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSURL * url = [NSURL fileURLWithPath:path];
       FlutterDartProject * dart =  [[FlutterDartProject alloc] initWithFlutterAssets:url dartMain:nil packages:nil];
        FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:dart nibName:nil bundle:nil];
        self.engine = [flutterViewController getEngine];
        [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];

        [self addBackButton:flutterViewController];
     
         [flutterViewController setInitialRoute:@"score_query/detail"];
        [self presentViewController:flutterViewController animated:YES completion:nil];
    }
    else{
    
        [self get_remote_flutterassets:url progress:^(float progress) {
            button.enabled = NO;
            [button setTitle:[NSString stringWithFormat:@"下载中%.2f%%",100*progress] forState:UIControlStateDisabled];
        } complete:^(NSString *localpath) {
            button.enabled = YES;
        }];
    }
 
    
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
        
        [weakSelf.engine clearChannels];
        weakSelf.engine = nil;
//        if ([weakSelf.ctr canPerformAction:@selector(clearChannels) withSender:nil]) {
  //              [weakSelf.ctr performSelector:@selector(clearChannels) withObject:nil afterDelay:0];
    //    }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)get_remote_flutterassets:(NSString *)url progress:(void (^)(float progress))progressblock complete:(void (^)(NSString * localpath))complete{
  [[SMDHttpEngine sharedInstance] downloadwithurl:url progress:^(CGFloat progress) {
        NSLog(@"progress:%.2f",progress);
        progressblock(progress);
     } error:^(NSError *error, NSString *filePath) {
        
//        button.enabled = YES;
        if (!error) {
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"flutter_assets_download"] ;
            //解压
            NSString *tempZipDir = [path stringByAppendingPathComponent:url.lastPathComponent];
            [SSZipArchive unzipFileAtPath:filePath toDestination:tempZipDir progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    complete(tempZipDir);
                }
            }];
        }
    }];
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
