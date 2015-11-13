//
//  MyXMLParser.m
//  RetailPlus
//
//  Created by 舒 鹏 on 13-5-6.
//  Copyright (c) 2013年 舒 鹏. All rights reserved.
//

#import "MyXMLParser.h"


@implementation MyXMLParser 

- (id)initWithXMLParser:(NSXMLParser *)parser element:(NSString *)element success:(successBlock)successBlock failed:(failedBlock)failedBlock
{
    if (self = [super init]) {
        self.elementStr = element;
        self.successBlock = successBlock;
        self.failedBlock = failedBlock;
        
        parser.delegate = self;
        [parser parse];
    }
    
    return self;
}

#pragma - mark XMLParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:self.elementStr]) {
        if (!self.jsonStr) {
            self.jsonStr = [[NSMutableString alloc] init];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if (self.jsonStr) {
        [self.jsonStr appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:self.elementStr]) {
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[self.jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (jsonDic) {
   //         NSLog(@"%@",jsonDic);
            self.successBlock(jsonDic);
        }else{
            self.failedBlock();
        }
        [parser abortParsing];
    }
}

-(void)DoNone
{
    
}
@end
