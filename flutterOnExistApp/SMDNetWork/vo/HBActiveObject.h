#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ArchiveObject : NSObject <NSCoding,NSCopying,NSMutableCopying>

@end

#pragma mark - 这个是基类，用于归档 打印 校验
//如 HBOBJ_SETVALUE_FORPATH(self, @"UserInfo", @"infos");
#define HBOBJ_SETVALUE_FORPATH(OBJ,VALUE,PATH) [OBJ setValue:VALUE forKeyPath:[NSString stringWithFormat:@"propertyArrayMap.%@",PATH]];


#define CONVERT_PROPERTY_CLASS( VALUE , PATH )\
-(id)init\
{\
    self = [super init];\
    if (self) {\
        HBOBJ_SETVALUE_FORPATH(self, @#VALUE , @#PATH )\
    }\
    return self;\
}

@interface HBActiveObject : ArchiveObject 
- (BOOL)validate  __attribute__((objc_requires_super));
@end
