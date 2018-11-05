//
//  BeeActiveObject.m
//  hjb
//
//  Created by boob on 16/3/30.
//  Copyright © 2016年 YY.COM All rights reserved.
//

#import "BeeActiveObject.h"
//#import "NSString+HBExtension.h"
//#import "Utils.h"
#import <objc/runtime.h>
@implementation BeeActiveObject

 
-(void)loaddataFromDataDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || ![[dictionary class] isSubclassOfClass:[NSDictionary class]]) {
        return;
    }
    if (self) {
        for ( Class clazzType = [self class];; )
        {
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount);
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                if([propertyName description])
                {
                    NSObject * object = dictionary[propertyName];
                    if (object) {
                        [self setValue:object forKey:propertyName];
                    }
                }
            }
            free( properties );
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
    }
    
}

@end
