//
//  BaseReq.m
//  hjb
//
//  Created by boob on 16/3/30.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "Base_Req.h"
//#import "NSObject+ObjectMap.h"
@implementation Base_Req

 
+(NSString*)getJsonStringWith:(NSDictionary*)request
{
    
    [request enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj class] isSubclassOfClass:[NSArray class]]) {
            
        }
    }];
    
    NSError* error = nil;
    NSData *result= [NSJSONSerialization dataWithJSONObject:request
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    NSString *strJson = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    strJson =  [strJson stringByReplacingOccurrencesOfString:@"hb_new" withString:@"new"];
    return strJson;
    
//    NSMutableDictionary *ndic = [request mutableCopy];
//    
//    NSData *nsData = [NSJSONSerialization dataWithJSONObject:ndic options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *strJson = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
//    strJson=[strJson stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    strJson=[strJson stringByReplacingOccurrencesOfString:@">" withString:@""];
//    return [NSString stringWithFormat:@"%@", strJson];
 
}
@end


@implementation NSObject(HJBBASERESP)
 

@end
