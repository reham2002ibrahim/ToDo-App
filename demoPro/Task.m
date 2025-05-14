#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self) {
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _desc = [coder decodeObjectOfClass:[NSString class] forKey:@"desc"];
        _priority = [coder decodeIntegerForKey:@"priority"];
        _status = [coder decodeIntegerForKey:@"status"];
        _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

