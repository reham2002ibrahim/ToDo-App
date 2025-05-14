

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding, NSSecureCoding>

@property NSString *title;
@property NSString *desc;
@property NSInteger priority;
@property  NSInteger status;
@property  NSDate *date;
@end

NS_ASSUME_NONNULL_END
