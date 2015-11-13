//
//  RPYuanTelApi.m
//  RetailPlus
//
//  Created by lin dong on 14-5-23.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "AFXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "RPYuanTelApi.h"
#import "RPMutableDictionary.h"

@implementation ConfCtrlAct
@end

@implementation RPYuanTelApi

static RPYuanTelApi *defaultObject;

+(void)DoYuanTelRequest:(NSString *)strURL withData:(RPMutableDictionary *)dictParam success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    if  (!dictParam.dict)
    {
        failedBlock(0,@"");
        return;
    }
    
    //Gen Body
    NSError *error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictParam.dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * strBodyJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * strBody = [NSString stringWithFormat:@"json=%@",strBodyJson];
    
    //Gen Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:[NSString stringWithFormat:@"%d",strBody.length] forHTTPHeaderField:@"Content-Length"];
    
    //Do Request
    AFHTTPRequestOperation * af = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [af setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error = nil;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
        if (dict) {
            successBlock(dict);
            return;
        }
        failedBlock(0,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(0,nil);
    }];
    //
    //    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary * dict) {
    //
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //        failedBlock(RPSDKError_NoConnection,[RPSDKError GetErrorDesc:RPSDKError_NoConnection]);
    //    }];
    [af start];
}

+(RPYuanTelApi *)defaultInstance
{
    @synchronized(self){
        if (!defaultObject)
        {
            defaultObject = [[self alloc] init];
        }
    }
    return defaultObject;
}

-(id)init
{
    id ret = [super init];
    if (ret) {
        _strApiBaseUrl = @"http://61.135.223.23:8118/";
        _strApiKey = @"testApiKey";
        _strApiSecret = @"testApiSecret";
        _strAttachPhone = @"4006-196-000";
        _strSessionKey = @"";
        _strSessionId = @"";
        _arrayConfCtrlActSend = [[NSMutableArray alloc] init];
        _asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
        //   [_asyncSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    return ret;
}


-(NSString *)genURL:(NSString *)strURL
{
    return [NSString stringWithFormat:@"%@/%@",_strApiBaseUrl,strURL];
}

-(NSString *)genTimeStamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)((float)time * 1000);
    NSNumber *longlongNumber = [NSNumber numberWithLongLong:date];
    return longlongNumber.stringValue;
}

-(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

-(void)LoginConf:(NSString *)strUserName PassWord:(NSString *)strPassWord success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"chkuservalidation" forKey:@"intertype"];
    [dict setObject:strUserName forKey:@"username"];
    [dict setObject:[self createMD5:strPassWord] forKey:@"pwdmd5"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@intertype%@pwdmd5%@timestamp%@username%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"intertype"],[dict objectForKey:@"pwdmd5"],[dict objectForKey:@"timestamp"],[dict objectForKey:@"username"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        if (((NSNumber *)[dictResult objectForKey:@"code"]).integerValue == 1000) {
            _strSessionKey = [dictResult objectForKey:@"sessionkey"];
            _strSessionId = [dictResult objectForKey:@"sessionid"];
            successBlock(nil);
            return;
        }
        _strSessionKey = @"";
        _strSessionId = @"";
        failedBlock(((NSNumber *)[dictResult objectForKey:@"code"]).integerValue,[dictResult objectForKey:@"msg"]);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        _strSessionKey = @"";
        _strSessionId = @"";
        failedBlock(0,@"Error");
    }];
}

-(void)StartConference:(NSString *)strTitle HostPhone:(NSString *)strHostPhone Guests:(NSArray *)array success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"startconference" forKey:@"intertype"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:_strSessionKey forKey:@"sessionkey"];
    [dict setObject:_strSessionId forKey:@"sessionid"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    [dict setObject:strHostPhone forKey:@"hostphone"];
    [dict setObject:strTitle forKey:@"conftitle"];
    
    NSMutableArray * arrayGuest = [[NSMutableArray alloc] init];
    for (RPConfGuest * guest in array) {
        RPMutableDictionary * dictGuest = [[RPMutableDictionary alloc] init];
        [dictGuest setObject:guest.strGuestName forKey:@"data"];
        [dictGuest setObject:guest.strPhone forKey:@"phoneno"];
        [dictGuest setObject:[NSNumber numberWithInt:1] forKey:@"mode"];
        [arrayGuest addObject:dictGuest.dict];
    }
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrayGuest options:0 error:&error];
    NSString * strGuestJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dict setObject:arrayGuest forKey:@"guests"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@conftitle%@guests%@hostphone%@intertype%@sessionid%@sessionkey%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"conftitle"],strGuestJson,[dict objectForKey:@"hostphone"],[dict objectForKey:@"intertype"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"timestamp"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        NSInteger nCode = ((NSNumber *)[dictResult objectForKey:@"code"]).integerValue;
        if (nCode == 1000) {
            successBlock(nil);
            return;
        }
        failedBlock(nCode ,[dictResult objectForKey:@"msg"]);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(0 ,@"Error");
    }];
}

-(void)BookingConference:(NSString *)strTitle BookTime:(NSString *)strBookTime HostPhone:(NSString *)strHostPhone Members:(NSArray *)array success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"bookingconference" forKey:@"intertype"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:_strSessionKey forKey:@"sessionkey"];
    [dict setObject:_strSessionId forKey:@"sessionid"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    [dict setObject:strHostPhone forKey:@"hostphone"];
    [dict setObject:strTitle forKey:@"conftitle"];
    [dict setObject:strBookTime forKey:@"booktime"];
    
    NSMutableArray * arrayGuest = [[NSMutableArray alloc] init];
    for (RPConfBookMember * member in array) {
        RPMutableDictionary * dictGuest = [[RPMutableDictionary alloc] init];
        [dictGuest setObject:member.strMemberDesc forKey:@"data"];
        [dictGuest setObject:member.strMemberPhone forKey:@"phoneno"];
        [dictGuest setObject:[NSNumber numberWithInt:1] forKey:@"mode"];
        [arrayGuest addObject:dictGuest.dict];
    }
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:arrayGuest options:0 error:&error];
    NSString * strGuestJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [dict setObject:arrayGuest forKey:@"guests"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@booktime%@conftitle%@guests%@hostphone%@intertype%@sessionid%@sessionkey%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"booktime"],[dict objectForKey:@"conftitle"],strGuestJson,[dict objectForKey:@"hostphone"],[dict objectForKey:@"intertype"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"timestamp"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        NSInteger nCode = ((NSNumber *)[dictResult objectForKey:@"code"]).integerValue;
        if (nCode == 1000) {
            NSDictionary * dictRoom = [dictResult objectForKey:@"room"];
            NSString * strId = @"";
            if (dictRoom) {
               strId = [dictRoom objectForKey:@"ConfRoom"];
            }
            
            successBlock(strId);
            return;
        }
        failedBlock(nCode ,[dictResult objectForKey:@"msg"]);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(0 ,@"");
    }];
}

//-(void)GetOnlineConferenceSuccess:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
//{
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"getonlinebookingconf" forKey:@"intertype"];
//    [dict setObject:_strApiKey forKey:@"apikey"];
//    [dict setObject:_strSessionKey forKey:@"sessionkey"];
//    [dict setObject:_strSessionId forKey:@"sessionid"];
//    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
//    [dict setObject:@"2000-01-01" forKey:@"starttime"];
//    [dict setObject:@"2999-01-01" forKey:@"endtime"];
//    [dict setObject:@"10" forKey:@"pagesize"];
//    [dict setObject:@"1" forKey:@"pageindex"];
//    
//    
//    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@endtime%@intertype%@pageindex%@pagesize%@sessionid%@sessionkey%@starttime%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"endtime"],[dict objectForKey:@"intertype"],[dict objectForKey:@"pageindex"],[dict objectForKey:@"pagesize"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"starttime"],[dict objectForKey:@"timestamp"],_strApiSecret];
//    
//    [dict setObject:[self createMD5:strToken] forKey:@"token"];
//    
//    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
//        NSDictionary * dictConf = [dictResult objectForKey:@"onlineconf"];
//        
//        
//        successBlock(nil);
//    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
//        failedBlock(0 ,@"");
//    }];
//}

-(void)GetBookingConferenceSuccess:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"getonlinebookingconf" forKey:@"intertype"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:_strSessionKey forKey:@"sessionkey"];
    [dict setObject:_strSessionId forKey:@"sessionid"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    [dict setObject:@"2000-01-01" forKey:@"starttime"];
    [dict setObject:@"2999-01-01" forKey:@"endtime"];
    [dict setObject:@"1000" forKey:@"pagesize"];
    [dict setObject:@"1" forKey:@"pageindex"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@endtime%@intertype%@pageindex%@pagesize%@sessionid%@sessionkey%@starttime%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"endtime"],[dict objectForKey:@"intertype"],[dict objectForKey:@"pageindex"],[dict objectForKey:@"pagesize"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"starttime"],[dict objectForKey:@"timestamp"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        NSInteger nCode = ((NSNumber *)[dictResult objectForKey:@"code"]).integerValue;
        if (nCode == 1000) {
            NSArray * arrayConf = [dictResult objectForKey:@"bookingconf"];
            NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
            for (NSDictionary * dictConf in arrayConf) {
                RPConfBook * book = [[RPConfBook alloc] init];
                book.strConfRoomId = [dictConf objectForKey:@"confRoom"];
                book.strCallTheme = [dictConf objectForKey:@"ConfTitle"];
                book.nMemberCount = ((NSNumber *)[dictConf objectForKey:@"ActorMember"]).integerValue;
                book.strHostPhone = nil;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                book.dateBooking = [formatter dateFromString:[dictConf objectForKey:@"ConfTime"]];
                [arrayRet addObject:book];
            }
            successBlock(arrayRet);
            return;
        }
        failedBlock(0 ,@"");
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(0 ,@"");
    }];
}

-(void)GetBookingConferenceDetail:(RPConfBook *)book Success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"getbookingconference" forKey:@"intertype"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:_strSessionKey forKey:@"sessionkey"];
    [dict setObject:_strSessionId forKey:@"sessionid"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    [dict setObject:book.strConfRoomId forKey:@"roomid"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@intertype%@roomid%@sessionid%@sessionkey%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"intertype"],[dict objectForKey:@"roomid"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"timestamp"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        NSInteger nCode = ((NSNumber *)[dictResult objectForKey:@"code"]).integerValue;
        if (nCode == 1000) {
            NSDictionary * dictRoom = [dictResult objectForKey:@"room"];
            NSMutableArray * arrayMember = [dictRoom objectForKey:@"Members"];
            
            book.arrayMember = [[NSMutableArray alloc] init];
            for (NSDictionary * dictMember in arrayMember) {
                RPConfBookMember * member = [[RPConfBookMember alloc] init];
                member.strMemberId = [dictMember objectForKey:@"mebguid"];
                member.strMemberDesc = [dictMember objectForKey:@"data"];
                member.strMemberPhone = [dictMember objectForKey:@"phoneno"];
                member.bMaster = ((NSNumber *)[dictMember objectForKey:@"IsMaster"]).integerValue;
                if (member.bMaster) {
                    book.strHostPhone = member.strMemberPhone;
                    [book.arrayMember insertObject:member atIndex:0];
                }
                else
                    [book.arrayMember addObject:member];
            }
            successBlock(nil);
            return;
        }
        failedBlock(0 ,@"");
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(0 ,@"");
    }];
}

-(void)DeleteBookingConference:(NSString *)strRoomId Success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"deletebookingconference" forKey:@"intertype"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:_strSessionKey forKey:@"sessionkey"];
    [dict setObject:_strSessionId forKey:@"sessionid"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    [dict setObject:strRoomId forKey:@"roomid"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@intertype%@roomid%@sessionid%@sessionkey%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"intertype"],[dict objectForKey:@"roomid"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"timestamp"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        NSInteger nCode = ((NSNumber *)[dictResult objectForKey:@"code"]).integerValue;
        if (nCode == 1000) {
            successBlock(nil);
            return;
        }
        failedBlock(nCode ,[dictResult objectForKey:@"msg"]);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(0 ,@"");
    }];
}

-(void)GetPassCode:(NSString *)strRoomId Success:(RPYuanTelApiSuccess)successBlock failed:(RPYuanTelApiFailed)failedBlock
{
    RPMutableDictionary * dict = [[RPMutableDictionary alloc] init];
    [dict setObject:@"getpasscode" forKey:@"intertype"];
    [dict setObject:_strApiKey forKey:@"apikey"];
    [dict setObject:_strSessionKey forKey:@"sessionkey"];
    [dict setObject:_strSessionId forKey:@"sessionid"];
    [dict setObject:[self genTimeStamp] forKey:@"timestamp"];
    
    NSString * strToken = [NSString stringWithFormat:@"%@apikey%@intertype%@sessionid%@sessionkey%@timestamp%@%@",_strApiKey,[dict objectForKey:@"apikey"],[dict objectForKey:@"intertype"],[dict objectForKey:@"sessionid"],[dict objectForKey:@"sessionkey"],[dict objectForKey:@"timestamp"],_strApiSecret];
    
    [dict setObject:[self createMD5:strToken] forKey:@"token"];
    
    [RPYuanTelApi DoYuanTelRequest:[self genURL:@"RestWebServices.ashx"] withData:dict success:^(NSDictionary * dictResult) {
        NSInteger nCode = ((NSNumber *)[dictResult objectForKey:@"code"]).integerValue;
        if (nCode == 1000) {
            RPConfPassCode * code = [[RPConfPassCode alloc] init];
            NSDictionary * dictPassCode = [dictResult objectForKey:@"userpassword"];
            code.strHostPassCode = [NSString stringWithFormat:@"%@%@",[dictPassCode objectForKey:@"ConfRoomID"],[dictPassCode objectForKey:@"HostPassCode"]];
            
            code.strGuestPassCode = [NSString stringWithFormat:@"%@%@",[dictPassCode objectForKey:@"ConfRoomID"],[dictPassCode objectForKey:@"GuestPassCode"]];
            
            successBlock(code);
            return;
        }
        failedBlock(0 ,@"");
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        failedBlock(0 ,@"");
    }];
}

#pragma mark AsyncSocket Delegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //    _dataSocketLastRemain = nil;
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self performSelectorOnMainThread:@selector(OnSocketReadData:) withObject:data waitUntilDone:NO];
    [[RPYuanTelApi defaultInstance] OnSocketReadData:data];
    
    //    NSError * error;
    //    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //    if (_strConfCtrlSessionId == nil) _strConfCtrlSessionId = [dict objectForKey:@"result"];
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError:%@",err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"onSocketDidDisconnect");
    _bConfCtrlConnected = NO;
}

+ (void)OnSocketReadData:(NSData *)data
{
    [[RPYuanTelApi defaultInstance] OnSocketReadData:data];
}

#pragma mark Meeting Control
-(NSInteger)GenConferenceControlId
{
    static NSInteger nConfCtrlId = 0;
    nConfCtrlId ++;
    return nConfCtrlId;
}


-(void)OnSocketReadData:(NSData *)data
{
    NSString * strEnd = @"\r\n";
    NSData * dataEnd = [strEnd dataUsingEncoding: NSASCIIStringEncoding];
    
    NSMutableData * dataCombine = [[NSMutableData alloc] init];
    if (_dataSocketLastRemain != nil) {
        [dataCombine appendData:_dataSocketLastRemain];
    }
    [dataCombine appendData:data];
    
    NSInteger nIndex = 0;
    NSInteger nRemainLength = dataCombine.length;
    
    while (nRemainLength) {
        NSRange range = [dataCombine rangeOfData:dataEnd options:NSDataSearchBackwards range:NSMakeRange(nIndex, nRemainLength)];
        if (range.location != NSNotFound) {
            NSData * dataJSON = [dataCombine subdataWithRange:NSMakeRange(nIndex, range.location)];
            [self OnReadJsonData:dataJSON];
            nIndex += (range.location + dataEnd.length);
            nRemainLength -= (range.location + dataEnd.length);
        }
        else
            break;
    }
    
    if (nRemainLength > 0)
        _dataSocketLastRemain = [dataCombine subdataWithRange:NSMakeRange(nIndex, nRemainLength)];
    else
        _dataSocketLastRemain = nil;
}

-(void)OnReadJsonData:(NSData *)data
{
    NSError * error;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSInteger nReadId = ((NSNumber *)[dict objectForKey:@"id"]).integerValue;
    BOOL bNotify = YES;
    
    for (ConfCtrlAct * act in _arrayConfCtrlActSend) {
        if (act.nId == nReadId) {
            bNotify = NO;
            switch (act.method) {
                case ConfCtrlActMethod_Login:
                    _strConfCtrlSessionId = [dict objectForKey:@"result"];
                    if (_strConfCtrlSessionId.length > 0)
                        [self.delegateConferenceCtrl OnCtrlConfLoginEnd:YES];
                    else
                        [self.delegateConferenceCtrl OnCtrlConfLoginEnd:NO];
                    break;
                case ConfCtrlActMethod_GetMyConferenceRoom:
                {
                    NSDictionary * dictConf = [dict objectForKey:@"result"];
                    if ([dictConf isKindOfClass:[NSDictionary class]]) {
                        RPConf * conf = [[RPConf alloc] init];
                        conf.strCallTheme = [dictConf objectForKey:@"ConfTitle"];
                        conf.strID = [dictConf objectForKey:@"RoomID"];
                        NSString * strDate = [dictConf objectForKey:@"CreateTime"];
                        NSString * strDate2 = [strDate substringWithRange:NSMakeRange(6, 10)];
                        NSDateFormatter * format = [[NSDateFormatter alloc] init];
                        format.dateFormat = @"yyyy-MM-dd HH:mm";
                        NSDate * dateBegin = [format dateFromString:@"1970-01-01 00:00"];
                        conf.dateCallHistory = [NSDate dateWithTimeInterval:strDate2.integerValue sinceDate:dateBegin];
                        [self.delegateConferenceCtrl OnGetConfEnd:conf];
                    }
                    else
                        [self.delegateConferenceCtrl OnGetConfEnd:nil];
                }
                    break;
                case ConfCtrlActMethod_GetMyConferenceMember:
                {
                    NSArray * arrayGuest = [dict objectForKey:@"result"];
                    if ([arrayGuest isKindOfClass:[NSArray class]]) {
                        NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
                        for (NSDictionary * dictGuest in arrayGuest) {
                            RPConfGuest * guest = [[RPConfGuest alloc] init];
                            guest.strPhone =  [dictGuest objectForKey:@"Phoneno"];
                            guest.strGuestName = [dictGuest objectForKey:@"Data"];
                            guest.strGuestId = [dictGuest objectForKey:@"MebGuid"];
                            guest.nCallState = ((NSNumber *)[dictGuest objectForKey:@"ChannelState"]).integerValue;
                            
                            NSLog(@"%@ CURSTATE %d",guest.strGuestId,guest.nCallState);
                            
                            if (arrayRet.count == 0)
                                guest.bMaster = YES;
                            else
                                guest.bMaster = NO;
                            
                            [arrayRet addObject:guest];
                        }
                        [self.delegateConferenceCtrl OnGetConfMemberEnd:arrayRet];
                    }
                    else
                        [self.delegateConferenceCtrl OnGetConfMemberEnd:nil];
                }
                    break;
                case ConfCtrlActMethod_CloseMyConference:
                    [self.delegateConferenceCtrl OnCloseConfEnd];
                    break;
                default:
                    
                    break;
            }
            [_arrayConfCtrlActSend removeObject:act];
            break;
        }
    }
    
    if (bNotify) {
        NSString * strMethod = [dict objectForKey:@"method"];
        if ([strMethod isKindOfClass:[NSString class]]) {
            NSArray * arrayParam = [dict objectForKey:@"params"];
            if ([strMethod isEqualToString:@"OnMemberChange"]) {
                if ([arrayParam isKindOfClass:[NSArray class]]) {
                    NSDictionary * dictChg = [arrayParam objectAtIndex:1];
                    if ([dictChg isKindOfClass:[NSDictionary class]]) {
                        NSString * strMemID = [dictChg objectForKey:@"MebGuid"];
                        NSInteger state = ((NSNumber *)[dictChg objectForKey:@"ChannelState"]).integerValue;
                        [_delegateConferenceCtrl OnConfMemberStateChange:strMemID state:state];
                    }
                }
            }
            if ([strMethod isEqualToString:@"OnMemberAdd"]) {
                NSDictionary * dictChg = [arrayParam objectAtIndex:1];
                if ([dictChg isKindOfClass:[NSDictionary class]]) {
                    RPConfGuest * guest = [[RPConfGuest alloc] init];
                    guest.strPhone =  [dictChg objectForKey:@"Phoneno"];
                    guest.strGuestName = [dictChg objectForKey:@"Data"];
                    guest.strGuestId = [dictChg objectForKey:@"MebGuid"];
                    [_delegateConferenceCtrl OnAddMember:guest];
                }
            }
            
            if ([strMethod isEqualToString:@"OnCloseConference"]) {
                 NSString * strConfID = [arrayParam objectAtIndex:0];
                if ([strConfID isKindOfClass:[NSString class]]) {
                    [_delegateConferenceCtrl OnCloseConference:strConfID];
                }
            }
        }
    }
}

-(BOOL)InitConferenceControl:(id)delegate
{
    NSError * err;
    _delegateConferenceCtrl = delegate;
    
    if(!_bConfCtrlConnected && ![_asyncSocket connectToHost:@"conf1.yuantel.net" onPort:4530 error:&err])
        return NO;
    
    _bConfCtrlConnected = YES;
    
    NSInteger nId = [self GenConferenceControlId];
    
    NSString * str = [NSString stringWithFormat:@"{\"id\":%d,\"method\":\"LoginbySession\",\"params\":[\"%@\",\"%@\"]}\r\n",nId,_strSessionId,_strSessionKey];
    
    ConfCtrlAct * act = [[ConfCtrlAct alloc] init];
    act.nId = nId;
    act.strSendBuf = str;
    act.method = ConfCtrlActMethod_Login;
    [_arrayConfCtrlActSend addObject:act];
    
    NSData* xmlData = [str dataUsingEncoding:NSASCIIStringEncoding];
    [_asyncSocket writeData:xmlData withTimeout:-1 tag:(long)0];
    return YES;
}

-(BOOL)GetMyConferenceRoom
{
    if (!_bConfCtrlConnected) return NO;
    
    NSInteger nId = [self GenConferenceControlId];
    NSString * str = [NSString stringWithFormat:@"{\"id\":%d,\"method\":\"GetMyConferenceRoom\",\"params\":[\"%@\"]}\r\n",nId,_strConfCtrlSessionId];
    
    ConfCtrlAct * act = [[ConfCtrlAct alloc] init];
    act.nId = nId;
    act.strSendBuf = str;
    act.method = ConfCtrlActMethod_GetMyConferenceRoom;
    [_arrayConfCtrlActSend addObject:act];
    
    NSData* xmlData = [str dataUsingEncoding:NSASCIIStringEncoding];
    [_asyncSocket writeData:xmlData withTimeout:-1 tag:(long)0];
    return YES;
}

-(BOOL)GetMyConferenceMember
{
    if (!_bConfCtrlConnected) return NO;
    NSInteger nId = [self GenConferenceControlId];
    NSString * str = [NSString stringWithFormat:@"{\"id\":%d,\"method\":\"GetMyConfAllMember\",\"params\":[\"%@\"]}\r\n",nId,_strConfCtrlSessionId];
    
    ConfCtrlAct * act = [[ConfCtrlAct alloc] init];
    act.nId = nId;
    act.strSendBuf = str;
    act.method = ConfCtrlActMethod_GetMyConferenceMember;
    [_arrayConfCtrlActSend addObject:act];
    
    NSData* xmlData = [str dataUsingEncoding:NSASCIIStringEncoding];
    [_asyncSocket writeData:xmlData withTimeout:-1 tag:(long)0];
    
    return YES;
}

-(BOOL)CloseMyConference
{
    if (!_bConfCtrlConnected) return NO;
    NSInteger nId = [self GenConferenceControlId];
    NSString * str = [NSString stringWithFormat:@"{\"id\":%d,\"method\":\"CloseMyConference\",\"params\":[\"%@\"]}\r\n",nId,_strConfCtrlSessionId];
    
    ConfCtrlAct * act = [[ConfCtrlAct alloc] init];
    act.nId = nId;
    act.strSendBuf = str;
    act.method = ConfCtrlActMethod_CloseMyConference;
    [_arrayConfCtrlActSend addObject:act];
    
    NSData* xmlData = [str dataUsingEncoding:NSASCIIStringEncoding];
    [_asyncSocket writeData:xmlData withTimeout:-1 tag:(long)0];
    
    return YES;
}

-(BOOL)CloseConferenceControl
{
    if (!_bConfCtrlConnected) return NO;
    [_asyncSocket disconnect];
    _delegateConferenceCtrl = nil;
    return YES;
}
@end
