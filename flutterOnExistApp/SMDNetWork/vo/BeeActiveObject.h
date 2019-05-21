//
//  BeeActiveObject.h
//  hjb
//
//  Created by boob on 16/3/30.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "HBActiveObject.h"

@interface BeeActiveObject : HBActiveObject
//@property(nonatomic,strong) NSDictionary * dataDictonary;

//-(NSDictionary *)getDataDictionaryFromResponsejson:(NSString *)responsejson;

-(void)loaddataFromDataDictionary:(NSDictionary *)dictionary;



/**
 *  拷贝 BeeActiveObject 子类内容到 subclass 中
 *
 *  @param item   基类
 *  @param object 目标子类
 */
//+(void)copyBeeActiveObject:(BeeActiveObject *)item ToSubClassObject:(id)targetObject;
@end
