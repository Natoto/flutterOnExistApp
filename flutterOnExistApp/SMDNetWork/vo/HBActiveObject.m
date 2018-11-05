 
#import "HBActiveObject.h"
#import <objc/runtime.h>

#pragma mark -

#undef	__ID_AS_KEY__
#define __ID_AS_KEY__			(__ON__)	// 默认使用.id做为主键

#undef	__AUTO_PRIMARY_KEY__
#define __AUTO_PRIMARY_KEY__	(__ON__)	// 默认使用第一个NSNumber类型的字段做为主键

@implementation HBActiveObject

- (NSString *)description
{
	NSMutableString * desc = [NSMutableString string];
	
	Class rootClass = [HBActiveObject class];

	for ( Class clazzType = [self class];; )
	{
		if ( clazzType == rootClass )
			break;
		
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject *		propertyValue = [self valueForKey:propertyName];
            if([propertyName description])
            [desc appendString:[propertyName description]];
            [desc appendString:@":"];
            
            if(propertyValue && [propertyValue description])
			[desc appendString:[propertyValue description]];
			[desc appendString:@"\n"];
		}

		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
	
    return desc; //[super description];
}

- (BOOL)validate
{
    
	return YES;
}

@end


@implementation ArchiveObject

-(id)mutableCopyWithZone:(NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [self valueForKey:key];
                [object setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return object;
}

-(id)copyWithZone:(NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    if (object) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [self valueForKey:key];
                [object setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return object;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [aDecoder decodeObjectForKey:key];
                @try {
                    if ([self.ocreservedwords containsObject:key]) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                }
                @catch (NSException *exception) {
                    NSLog(@"%s %@ 不能正常赋值",__FUNCTION__, key);
                }
                @finally {
                    
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return self;
}

/**
 * 保留字
 */
-(NSArray *)ocreservedwords{

    return @[@"debugDescription",@"description",@"hash",@"superclass"];
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                               encoding:NSUTF8StringEncoding];
        
        if ([self.ocreservedwords containsObject:key]) {
            continue;
        }
        id value=[self valueForKey:key];
        if (value && key) {
            if ([value isKindOfClass:[NSObject class]]) {
                [aCoder encodeObject:value forKey:key];
            } else {
                NSNumber * v = [NSNumber numberWithInt:(int)value];
                [aCoder encodeObject:v forKey:key];
            }
        }
    }
    free(properties);
    properties = NULL;
}
 
@end
