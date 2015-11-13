//
//  RPPurchaseRecordClass.h
//  RetailPlus
//
//  Created by zwhe on 13-12-27.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPPurchaseRecordClass : NSObject
{
}
@property(strong,nonatomic)NSString *recordDate;
@property(strong,nonatomic)NSString *recordProductName;
@property(assign,nonatomic)int  recordUnitPrice;
@property(assign,nonatomic)int  recordQty;
@property(assign,nonatomic)int  recordAmount;
@end
