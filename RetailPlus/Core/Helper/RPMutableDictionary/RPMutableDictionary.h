//
//  RPMutableDictionary.h
//  RetailPlus
//
//  Created by lin dong on 14-6-27.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPMutableDictionary : NSObject

@property (nonatomic,retain) NSMutableDictionary * dict;

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(id)objectForKey:(id)aKey;

@end
