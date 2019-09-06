//
//  ViewController.m
//  Test2flutter
//
//  Created by boob on 2019/9/3.
//  Copyright © 2019 boob. All rights reserved.
//
#import <Flutter/Flutter.h>
#import "ViewController.h" 
#import "GeneratedPluginRegistrant.h"

@interface ViewController ()
@property (nonatomic, weak) FlutterViewController * ctr;
@property (nonatomic, strong) FlutterEngine * engine;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


-(IBAction)launchFlutter:(id)sender{
    if (!self.engine) {
        FlutterDartProject * dart = [[FlutterDartProject alloc] init];
        FlutterEngine * engine = [[FlutterEngine alloc] initWithName:@"ios.dart.flutter"
                                                             project:dart];
        [engine runWithEntrypoint:nil];
        self.engine = engine;     
    }

    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithEngine:self.engine nibName:nil bundle:nil];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    [self addBackButton:flutterViewController];
    self.ctr = flutterViewController;
     
    [self presentViewController:flutterViewController animated:YES completion:nil];
    [self addBackButton:flutterViewController];
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
    __weak __typeof(self)weakSelf = self;
    [self.ctr dismissViewControllerAnimated:YES completion:^{ 
    }];

}
@end
