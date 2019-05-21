//
//  HJBPayHttpEngine.h
//  HJBPaySDK
//
//  Created by boob on 16/9/26.
//  Copyright © 2016年 YY.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface SMDHttpEngine : AFHTTPSessionManager

@property (nonatomic, strong) NSString * m_baseurl;
+ (instancetype)sharedInstance;
 

-(void)req_post_url:(NSString *)urlkey
              prama:(NSDictionary *)prama
       responsedata:(void (^)(NSData * jsondata))response
       errorHandler:(void (^)(NSError * err))err;

-(void)req_post_url:(NSString *)urlkey
              prama:(NSDictionary *)prama
           response:(void (^)(NSString * jsonstring))response
       errorHandler:(void (^)(NSError * err))err;

-(void)req_get_url:(NSString *)urlkey
          response:(void (^)(NSString * jsonstring))response
      errorHandler:(void (^)(NSError * err))err;


-(void)req_get_url:(NSString *)urlkey
             prama:(NSDictionary *)prama
      responsedata:(void (^)(NSData * jsondata))response
      errorHandler:(void (^)(NSError * err))err;

-(NSURLSessionDownloadTask *)downloadwithurl:(NSString *)urlkey
            progress:(void(^)(CGFloat progress))progress
             error:(void(^)(NSError * error,NSString * localfilepath))derror;
             
@end
