//
//  MyXMLParser.h
//  RetailPlus
//
//  Created by 舒 鹏 on 13-5-6.
//  Copyright (c) 2013年 舒 鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(NSDictionary *jsonResult);
typedef void(^failedBlock)();

@interface MyXMLParser : NSObject <NSXMLParserDelegate>
@property (copy, nonatomic) successBlock successBlock;
@property (copy, nonatomic) failedBlock failedBlock;
@property (strong, nonatomic) NSString *elementStr;
@property (strong, nonatomic) NSMutableString *jsonStr;
- (id)initWithXMLParser:(NSXMLParser *)parser element:(NSString *)element success:(successBlock)successBlock failed:(failedBlock)failedBlock;
-(void)DoNone;
@end
