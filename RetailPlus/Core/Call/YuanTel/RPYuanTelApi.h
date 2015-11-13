//
//  RPYuanTelApi.h
//  RetailPlus
//
//  Created by lin dong on 14-5-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "RPConfDefine.h"

typedef void(^RPYuanTelApiSuccess)(id idResult);
typedef void(^RPYuanTelApiFailed)(NSInteger nErrorCode,NSString * strDesc);
typedef void(^RPYuanTelApiProgress)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);

//@interface Conference : NSObject
//@property (nonatomic,retain) NSString * strConfRoomId;
//@property (nonatomic,retain) NSString * strConfTitle;
//@property (nonatomic,retain) NSString * strConfTime;
//@property (nonatomic)        NSInteger nMembers;
//@property (nonatomic)        NSInteger state;
//@property (nonatomic)        NSInteger nSeqNo;
//@property (nonatomic)        NSInteger nHoldTime;
//@property (nonatomic)        BOOL      bRecord;
//@end



typedef enum : NSUInteger {
    ConfCtrlActMethod_Login,
    ConfCtrlActMethod_GetMyConferenceRoom,
    ConfCtrlActMethod_GetMyConferenceMember,
    ConfCtrlActMethod_CloseMyConference,
} ConfCtrlActMethod;

@interface ConfCtrlAct : NSObject
@property (nonatomic) NSInteger nId;
@property (nonatomic) ConfCtrlActMethod method;
@property (nonatomic,retain) NSString * strSendBuf;
@end

@protocol ConferenceCtrlDelegate
    -(void)OnCtrlConfDisconnected;

    -(void)OnCtrlConfLoginEnd:(BOOL)bSuccess;
    -(void)OnGetConfEnd:(RPConf *)conf;
    -(void)OnGetConfMemberEnd:(NSMutableArray *)arrayMember;
    -(void)OnCloseConfEnd;

    -(void)OnConfMemberStateChange:(NSString *)strMemberID state:(NSInteger)nState;
    -(void)OnCloseConference:(NSString *)strConfID;
    -(void)OnAddMember:(RPConfGuest *)guest;
@end

@interface RPYuanTelApi : NSObject<AsyncSocketDelegate>
{
    NSString            * _strApiBaseUrl;
    NSString            * _strApiKey;
    NSString            * _strApiSecret;
    NSString            * _strSessionKey;
    NSString            * _strSessionId;
    NSString            * _strConfCtrlSessionId;
    
    AsyncSocket         * _asyncSocket;
    BOOL                _bConfCtrlConnected;
    NSMutableArray      * _arrayConfCtrlActSend;
    NSData              * _dataSocketLastRemain;
}

+(RPYuanTelApi *)defaultInstance;

@property (nonatomic,readonly) NSString * strAttachPhone;
@property (nonatomic,assign) id<ConferenceCtrlDelegate> delegateConferenceCtrl;

//登录会议系统
-(void)LoginConf:(NSString *)strUserName PassWord:(NSString *)strPassWord success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;
//马上开始会议
-(void)StartConference:(NSString *)strTitle HostPhone:(NSString *)strHostPhone Guests:(NSArray *)array success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;
//获取正在召开的会议
//-(void)GetOnlineConferenceSuccess:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;

//预约会议
-(void)BookingConference:(NSString *)strTitle BookTime:(NSString *)strBookTime HostPhone:(NSString *)strHostPhone Members:(NSArray *)array success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;
//获取预约会议
-(void)GetBookingConferenceSuccess:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;
//获取预约会议详情
-(void)GetBookingConferenceDetail:(RPConfBook *)book Success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;
//删除预约会议
-(void)DeleteBookingConference:(NSString *)strRoomId Success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;

//获取加入会议密码
-(void)GetPassCode:(NSString *)strRoomId Success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock;

//会议控制
-(BOOL)InitConferenceControl:(id)delegate;
-(BOOL)CloseConferenceControl;
-(BOOL)GetMyConferenceRoom;
-(BOOL)GetMyConferenceMember;
-(BOOL)CloseMyConference;
@end
