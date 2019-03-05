// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/platform/darwin/ios/framework/Headers/FlutterChannels.h"
#import <objc/runtime.h>

#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify( x )    autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else    // #if __has_feature(objc_arc)
#define weakify( x )    autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif    // #if __has_feature(objc_arc)
#endif    // #ifndef    weakify

#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify( x )    try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else    // #if __has_feature(objc_arc)
#define strongify( x )    try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif    // #if __has_feature(objc_arc)
#endif    // #ifndef    @normalize


#pragma mark - Basic message channel

@implementation FlutterBasicMessageChannel {
    NSObject<FlutterBinaryMessenger>* _messenger;
    NSString* _name;
    NSObject<FlutterMessageCodec>* _codec;
}
+ (instancetype)messageChannelWithName:(NSString*)name
                       binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    NSObject<FlutterMessageCodec>* codec = [FlutterStandardMessageCodec sharedInstance];
    return [FlutterBasicMessageChannel messageChannelWithName:name
                                              binaryMessenger:messenger
                                                        codec:codec];
}
+ (instancetype)messageChannelWithName:(NSString*)name
                       binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                                 codec:(NSObject<FlutterMessageCodec>*)codec {
    return
    [[[FlutterBasicMessageChannel alloc] initWithName:name binaryMessenger:messenger codec:codec]
     autorelease];
}

- (instancetype)initWithName:(NSString*)name
             binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                       codec:(NSObject<FlutterMessageCodec>*)codec {
    self = [super init];
    NSAssert(self, @"Super init cannot be nil");
    _name = [name retain];
    _messenger = [messenger retain];
    _codec = [codec retain];
    return self;
}

- (void)dealloc {
    [self destory];
    [super dealloc];
}

- (void)destory {
    if (_name) {
        [_name release];
        _name = nil;
    }
    if (_messenger) {
        [_messenger release];
        _messenger = nil;
    }
    if (_codec) {
        [_codec release];
        _codec = nil;
    }
}

-(NSObject<FlutterMessageCodec>*)getCodec {
    return _codec;
}

-(NSString*)getName {
    return _name;
}

- (void)sendMessage:(id)message {
    [_messenger sendOnChannel:_name message:[_codec encode:message]];
}

- (void)sendMessage:(id)message reply:(FlutterReply)callback {
    __block FlutterBasicMessageChannel *blockSelf = self;
    FlutterBinaryReply reply = ^(NSData* data) {
        if (callback)
            callback([[blockSelf getCodec] decode:data]);
    };
    [_messenger sendOnChannel:[blockSelf getName] message:[[blockSelf getCodec] encode:message] binaryReply:reply];
}


- (void)setMessageHandler:(FlutterMessageHandler)handler {
    if (!handler) {
        [_messenger setMessageHandlerOnChannel:_name binaryMessageHandler:nil];
        return;
    }
    __block FlutterBasicMessageChannel *blockSelf = self;
    FlutterBinaryMessageHandler messageHandler = ^(NSData* message, FlutterBinaryReply callback) {
        handler([[blockSelf getCodec] decode:message], ^(id reply) {
            callback([[blockSelf getCodec] encode:reply]);
        });
    };
    [_messenger setMessageHandlerOnChannel:_name binaryMessageHandler:messageHandler];
}
@end

#pragma mark - Method channel

@implementation FlutterError
+ (instancetype)errorWithCode:(NSString*)code message:(NSString*)message details:(id)details {
    return [[[FlutterError alloc] initWithCode:code message:message details:details] autorelease];
}

- (instancetype)initWithCode:(NSString*)code message:(NSString*)message details:(id)details {
    NSAssert(code, @"Code cannot be nil");
    self = [super init];
    NSAssert(self, @"Super init cannot be nil");
    _code = [code retain];
    _message = [message retain];
    _details = [details retain];
    return self;
}


- (void)dealloc {
    [self destory];
    [super dealloc];
}

- (void)destory {
    if (_code) {
        [_code release];
        _code = nil;
    }
    if (_message) {
        [_message release];
        _message = nil;
    }
    if (_details) {
        [_details release];
        _details = nil;
    }
}


- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if (![object isKindOfClass:[FlutterError class]])
        return NO;
    FlutterError* other = (FlutterError*)object;
    return [self.code isEqual:other.code] &&
    ((!self.message && !other.message) || [self.message isEqual:other.message]) &&
    ((!self.details && !other.details) || [self.details isEqual:other.details]);
}

- (NSUInteger)hash {
    return [self.code hash] ^ [self.message hash] ^ [self.details hash];
}
@end

@implementation FlutterMethodCall
+ (instancetype)methodCallWithMethodName:(NSString*)method arguments:(id)arguments {
    return [[[FlutterMethodCall alloc] initWithMethodName:method arguments:arguments] autorelease];
}

- (instancetype)initWithMethodName:(NSString*)method arguments:(id)arguments {
    NSAssert(method, @"Method name cannot be nil");
    self = [super init];
    NSAssert(self, @"Super init cannot be nil");
    _method = [method retain];
    _arguments = [arguments retain];
    return self;
}


- (void)dealloc {
    NSLog(@"%@ %@ %s",self,NSStringFromClass(self.class),__FUNCTION__);
    [self destory];
    [super dealloc];
    self = nil;
}

- (void)destory {
    NSLog(@"%@ %s",self,__FUNCTION__);
    if (_method) {
        [_method release];
        _method = nil;
    }
    if (_arguments) {
        [_arguments release];
        _arguments = nil;
    }
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if (![object isKindOfClass:[FlutterMethodCall class]])
        return NO;
    FlutterMethodCall* other = (FlutterMethodCall*)object;
    return [self.method isEqual:[other method]] &&
    ((!self.arguments && !other.arguments) || [self.arguments isEqual:other.arguments]);
}

- (NSUInteger)hash {
    return [self.method hash] ^ [self.arguments hash];
}
@end

NSObject const* FlutterMethodNotImplemented = [NSObject new];

@implementation FlutterMethodChannel {
    NSObject<FlutterBinaryMessenger>* _messenger;
    NSString* _name;
    NSObject<FlutterMethodCodec>* _codec;
    
}

+ (instancetype)methodChannelWithName:(NSString*)name
                      binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    NSObject<FlutterMethodCodec>* codec = [FlutterStandardMethodCodec sharedInstance];
    return [FlutterMethodChannel methodChannelWithName:name binaryMessenger:messenger codec:codec];
}

+ (instancetype)methodChannelWithName:(NSString*)name
                      binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                                codec:(NSObject<FlutterMethodCodec>*)codec {
    return [[FlutterMethodChannel alloc] initWithName:name binaryMessenger:messenger codec:codec] ;
}

- (instancetype)initWithName:(NSString*)name
             binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                       codec:(NSObject<FlutterMethodCodec>*)codec {
    self = [super init];
    NSAssert(self, @"Super init cannot be nil");
    _name = [name retain];
    _messenger = messenger;// [messenger retain];
    _codec = [codec retain];
    return self;
}


- (void)dealloc {
    NSLog(@"%@ %s",self,__FUNCTION__);
    [self destory];
    [super dealloc];
}

- (void)destory {
    if (!self) {
        return;
    }
    NSLog(@"%@ %s",self,__FUNCTION__);
    if (_messenger) {
        [_messenger setMessageHandlerOnChannel:_name binaryMessageHandler:nil];
    }
    if (_name) {
        [_name release];
        _name = nil;
    }
    if (_messenger) {
//        [_messenger release];
        _messenger = nil;
    }
    if (_codec) {
        [_codec release];
        _codec = nil;
    }
}

-(NSObject<FlutterMethodCodec>*)getCodec {
    return _codec;
}

-(NSString*)getName {
    return _name;
}


- (void)invokeMethod:(NSString*)method arguments:(id)arguments {
    FlutterMethodCall* methodCall =
    [FlutterMethodCall methodCallWithMethodName:method arguments:arguments];
    NSData* message = [_codec encodeMethodCall:methodCall];
    [_messenger sendOnChannel:_name message:message];
}

- (void)invokeMethod:(NSString*)method arguments:(id)arguments result:(FlutterResult)callback {
    FlutterMethodCall* methodCall = [FlutterMethodCall methodCallWithMethodName:method
                                                                      arguments:arguments];
    NSData* message = [_codec encodeMethodCall:methodCall];
    __block FlutterMethodChannel *blockSelf = self;
    FlutterBinaryReply reply = ^(NSData* data) {
        if (callback) {
            callback((data == nil) ? FlutterMethodNotImplemented : [[blockSelf getCodec] decodeEnvelope:data]);
        }
    };
    [_messenger sendOnChannel:_name message:message binaryReply:reply];
}

-(void)flutterBinaryMessageHandler:(FlutterMethodCallHandler)handler message:(NSData* )message callback:(FlutterBinaryReply)callback{
    
    if (![self isKindOfClass:[FlutterMethodChannel class]]) {
        return ;
    }
    NSLog(@"method callback: %@",self);
    FlutterMethodCall* call = [[self getCodec] decodeMethodCall:message];
    @weakify(self)
    handler(call, ^(id result) {
        @strongify(self);
        if (result == FlutterMethodNotImplemented)
            callback(nil);
        else if ([result isKindOfClass:[FlutterError class]])
            callback([[self getCodec] encodeErrorEnvelope:(FlutterError*)result]);
        else
            callback([[self getCodec] encodeSuccessEnvelope:result]);
    });
}
- (void)setMethodCallHandler:(FlutterMethodCallHandler)handler {
    if (!handler) {
        [_messenger setMessageHandlerOnChannel:_name binaryMessageHandler:nil];
        return;
    }
    NSLog(@"set method: %@",self);
    @weakify(self)
    FlutterBinaryMessageHandler messageHandler = ^(NSData* message, FlutterBinaryReply callback) {
        @strongify(self);

        Class  cls = object_getClass(self);
        if (![cls isSubclassOfClass:FlutterMethodChannel.class]) {
            return ;
        }
        [self flutterBinaryMessageHandler:handler message:message callback:callback];
    };
    [_messenger setMessageHandlerOnChannel:_name binaryMessageHandler:messageHandler];
}

@end


#pragma mark - Event channel

NSObject const* FlutterEndOfEventStream = [NSObject new];

@implementation FlutterEventChannel {
    NSObject<FlutterBinaryMessenger>* _messenger;
    NSString* _name;
    NSObject<FlutterMethodCodec>* _codec;
}
+ (instancetype)eventChannelWithName:(NSString*)name
                     binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    NSObject<FlutterMethodCodec>* codec = [FlutterStandardMethodCodec sharedInstance];
    return [FlutterEventChannel eventChannelWithName:name binaryMessenger:messenger codec:codec];
}

+ (instancetype)eventChannelWithName:(NSString*)name
                     binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                               codec:(NSObject<FlutterMethodCodec>*)codec {
    return [[[FlutterEventChannel alloc] initWithName:name binaryMessenger:messenger codec:codec]
            autorelease];
}

-(NSObject<FlutterMethodCodec>*)getCodec {
    return _codec;
}

-(NSString*)getName {
    return _name;
}
-(NSObject<FlutterBinaryMessenger>*)getmessenger{
    return _messenger;
}

- (void)dealloc {
    [self destory];
    [super dealloc];
}

- (void)destory {
    
    if (_name) {
        [_name release];
        _name = nil;
    }
    if (_messenger) {
        [_messenger release];
        _messenger = nil;
    }
    if (_codec) {
        [_codec release];
        _codec = nil;
    }
}
- (instancetype)initWithName:(NSString*)name
             binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                       codec:(NSObject<FlutterMethodCodec>*)codec {
    self = [super init];
    NSAssert(self, @"Super init cannot be nil");
    _name = [name retain];
    _messenger = [messenger retain];
    _codec = [codec retain];
    return self;
}

- (void)setStreamHandler:(NSObject<FlutterStreamHandler>*)handler {
    if (!handler) {
        [_messenger setMessageHandlerOnChannel:_name binaryMessageHandler:nil];
        return;
    }
    __block FlutterEventSink currentSink = nil;
    __block FlutterEventChannel *blockSelf = self;
    FlutterBinaryMessageHandler messageHandler = ^(NSData* message, FlutterBinaryReply callback) {
        FlutterMethodCall* call = [[blockSelf getCodec] decodeMethodCall:message];
        if ([call.method isEqual:@"listen"]) {
            if (currentSink) {
                FlutterError* error = [handler onCancelWithArguments:nil];
                if (error)
                    NSLog(@"Failed to cancel existing stream: %@. %@ (%@)", error.code, error.message,
                          error.details);
            }
            currentSink = ^(id event) {
                if (event == FlutterEndOfEventStream)
                    [[blockSelf getmessenger] sendOnChannel:[blockSelf getName] message:nil];
                else if ([event isKindOfClass:[FlutterError class]])
                    [[blockSelf getmessenger] sendOnChannel:[blockSelf getName]
                                                    message:[[blockSelf getCodec] encodeErrorEnvelope:(FlutterError*)event]];
                else
                    [[blockSelf getmessenger]  sendOnChannel:[blockSelf getName] message:[[blockSelf getCodec] encodeSuccessEnvelope:event]];
            };
            FlutterError* error = [handler onListenWithArguments:call.arguments eventSink:currentSink];
            if (error)
                callback([[blockSelf getCodec] encodeErrorEnvelope:error]);
            else
                callback([[blockSelf getCodec] encodeSuccessEnvelope:nil]);
        } else if ([call.method isEqual:@"cancel"]) {
            if (!currentSink) {
                callback(
                         [[blockSelf getCodec] encodeErrorEnvelope:[FlutterError errorWithCode:@"error"
                                                                                       message:@"No active stream to cancel"
                                                                                       details:nil]]);
                return;
            }
            currentSink = nil;
            FlutterError* error = [handler onCancelWithArguments:call.arguments];
            if (error)
                callback([[blockSelf getCodec] encodeErrorEnvelope:error]);
            else
                callback([[blockSelf getCodec] encodeSuccessEnvelope:nil]);
        } else {
            callback(nil);
        }
    };
    [_messenger setMessageHandlerOnChannel:[blockSelf getName] binaryMessageHandler:messageHandler];
}
@end

