//
//  FlutterLuaPlugin.m
//  Runner
//
//  Created by wen william on 2018/10/18.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "FlutterLuaPlugin.h"
//#import "oc_helpers.h"

@implementation FlutterLuaPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
{
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"luakit"
                                binaryMessenger:[registrar messenger]];
    
    FlutterLuaPlugin* instance = [[FlutterLuaPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
     
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    id params = [call.arguments objectForKey:@"params"];
//    if (params) {
//        call_lua_function([call.arguments objectForKey:@"moduleName"], [call.arguments objectForKey:@"methodName"], params, ^(NSString *s){
//            result(s);
//        });
//    } else {
//        call_lua_function([call.arguments objectForKey:@"moduleName"], [call.arguments objectForKey:@"methodName"], ^(NSString *s){
//            result(s);
//        });
//    }
}

@end
