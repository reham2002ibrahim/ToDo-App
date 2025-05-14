#import "AllTasks.h"

@implementation AllTasks


+ (instancetype)getInstance {
    static AllTasks *getInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
        getInstance.todoDictionary = [[getInstance loadDataForKey:@"todoDictionary"] mutableCopy] ?: [NSMutableDictionary dictionary];
        getInstance.doingDictionary = [[getInstance loadDataForKey:@"doingDictionary"] mutableCopy] ?: [NSMutableDictionary dictionary];
        getInstance.doneDictionary = [[getInstance loadDataForKey:@"doneDictionary"] mutableCopy] ?: [NSMutableDictionary dictionary];

    });
    return getInstance;
}

- (NSMutableDictionary<NSString *, NSMutableArray<Task *> *> *)loadDataForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [defaults objectForKey:key];

    if (savedData) {
        NSError *error = nil;
        NSSet *classes = [NSSet setWithObjects:[NSDictionary class], [NSMutableArray class], [Task class], nil];
        NSDictionary *decoded = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:savedData error:&error];

        return [decoded mutableCopy];
    } else {
        return [NSMutableDictionary dictionary];
    }
}



- (void)saveDataForKey:(NSString *)key fromDictionary:(NSMutableDictionary *)dictionary {
    NSError *error = nil;
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:YES error:&error];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedData forKey:key];
}

@end
