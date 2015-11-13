//
//  RPMutableDictionary.m
//  RetailPlus
//
//  Created by lin dong on 14-6-27.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPMutableDictionary.h"

@implementation RPMutableDictionary

-(id)init
{
    id ret = [super init];
    if (ret) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return ret;
}

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == nil)
        return [_dict setObject:@"" forKey:aKey];
    else
        return [_dict setObject:anObject forKey:aKey];
}

-(id)objectForKey:(id)aKey
{
    return [_dict objectForKey:aKey];
}
@end
