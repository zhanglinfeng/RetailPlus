//
//  RPError.h
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RPNetTaskError_Unknown         = -1,
    RPNetTaskError_InputParam      = 1,
    RPNetTasKError_ParseXML        = 2,
    RPNetTasKError_Request         = 3,
}RPErrorList;

@interface RPError : NSObject

@end
