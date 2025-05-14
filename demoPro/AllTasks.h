

#import <Foundation/Foundation.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@interface AllTasks : NSObject

@property NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *todoDictionary;
@property NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *doingDictionary;
@property NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *doneDictionary;

+ (instancetype)getInstance;
- (NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *)loadDataForKey:(NSString *)key;
- (void)saveDataForKey:(NSString *)key fromDictionary:(NSMutableDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
