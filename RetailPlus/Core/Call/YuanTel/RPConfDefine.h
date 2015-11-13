//
//  RPConfDefine.h
//  RetailPlus
//
//  Created by lin dong on 14-6-16.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPConfPassCode : NSObject
@property (nonatomic,retain) NSString        * strHostPassCode;
@property (nonatomic,retain) NSString        * strGuestPassCode;
@end

@interface RPConfAccount : NSObject
@property (nonatomic,retain) NSString * strID;
@property (nonatomic,retain) NSString * strUserName;
@property (nonatomic,retain) NSString * strPassWord;
@property (nonatomic)        BOOL       bInited;
@property (nonatomic)        BOOL       bChecked;
@property (nonatomic)        BOOL       bLogined;
@end

@interface RPConf : NSObject
@property (nonatomic,retain) NSString        * strID;
@property (nonatomic,retain) NSString        * strCallTheme;
@property (nonatomic,retain) NSString        * strHostPhone;
@property (nonatomic,retain) NSString        * strHostEmail;
@property (nonatomic,retain) NSString        * strHostName;
@property (nonatomic,retain) NSDate          * dateCallHistory;
@property (nonatomic,retain) NSMutableArray  * arrayGuest;
@end

@interface RPConfGuest : NSObject
@property (nonatomic,retain) NSString        * strGuestId;
@property (nonatomic,retain) NSString        * strGuestName;
@property (nonatomic,retain) NSString        * strPhone;
@property (nonatomic,retain) NSString        * strEmail;
@property (nonatomic)        BOOL            bMaster;
@property (nonatomic)        NSInteger       nCallState;
@end

@interface RPConfBook : NSObject
@property (nonatomic,retain) NSString        * strConfRoomId;
@property (nonatomic,retain) NSString        * strCallTheme;
@property (nonatomic,retain) NSDate          * dateBooking;
@property (nonatomic,retain) NSString        * strHostPhone;
@property (nonatomic,retain) NSString        * strHostName;
@property (nonatomic,retain) NSString        * strHostEmail;
@property (nonatomic)        NSInteger       nMemberCount;
@property (nonatomic,retain) NSMutableArray  * arrayMember;
@end

@interface RPConfBookMember : NSObject
@property (nonatomic,retain) NSString        * strMemberId;
@property (nonatomic,retain) NSString        * strMemberDesc;
@property (nonatomic,retain) NSString        * strMemberPhone;
@property (nonatomic,retain) NSString        * strMemberEmail;
@property (nonatomic)        BOOL            bMaster;
@end

