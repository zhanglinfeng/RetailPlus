//
//  RPSDK+VisualMerchandising.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSDK+VisualMerchandising.h"
#import "GTMBase64.h"
#import "RPNetModule.h"
extern NSBundle * g_bundleResorce;
@implementation RPSDK (VisualMerchandising)


-(float)ValidFloatNumber:(NSDictionary *)dict forKey:(NSString *)strKey defaultValue:(float)dDefault
{
    NSNumber * numValue = [dict objectForKey:strKey];
    float numfloat=[numValue floatValue];
    return numfloat;
}
-(void)GetVisualDisplayAttachmentsSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/GetAttachmentList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {

        
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in arrayResult)
        {
            RPvmGuide *vmGuide=[[RPvmGuide alloc]init];
            vmGuide.strID=[self ValidString:dict forKey:@"AttachmentId"];
            vmGuide.strCreator=[self ValidString:dict forKey:@"Creator"];
            vmGuide.strDate=[self ValidString:dict forKey:@"AddDate"];
            vmGuide.strName=[self ValidString:dict forKey:@"AttachmentName"];
            vmGuide.strPath=[self ValidString:dict forKey:@"AttachmentPath"];
            vmGuide.strType=[self ValidString:dict forKey:@"AttachmentType"];
            vmGuide.strUrl=[self ValidString:dict forKey:@"AthUrl"];
            vmGuide.size=[self ValidFloatNumber:dict forKey:@"Size" defaultValue:0.0];
            [array addObject:vmGuide];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)getVisualStoreList:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/GetFollowStore"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in arrayResult)
        {
            FollowStore *followStore=[[FollowStore alloc]init];
            followStore.strStoreId=[self ValidString:dict forKey:@"StoreId"];
            followStore.strFollowStoreId=[self ValidString:dict forKey:@"FollowStoreId"];
            followStore.strShopMap=[self ValidString:dict forKey:@"ShopMap"];
            followStore.strStoreName=[self ValidString:dict forKey:@"StoreName"];
            followStore.strBrandName=[self ValidString:dict forKey:@"BrandName"];
            followStore.strStoreThumb=[self ValidString:dict forKey:@"StoreThumb"];
            followStore.strUserId=[self ValidString:dict forKey:@"UserId"];
            followStore.pendingCount=[self ValidNumber:dict forKey:@"PendingCount" defaultValue:0].integerValue;
            followStore.rejectCount=[self ValidNumber:dict forKey:@"RejectCount" defaultValue:0].integerValue;
            [array addObject:followStore];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)AddFollowStore:(NSArray *)arrayStore Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    NSMutableArray * arrayAPI = [[NSMutableArray alloc] init];
    for (NSString * str in arrayStore) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:str forKey:@"StoreId"];
        [arrayAPI addObject:dict];
    }
    
    NSMutableDictionary * dict = [self genBodyDataDict:arrayAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/AddFollowStore"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)DelFollowStore:(NSArray *)arrayStore Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    NSMutableArray * arrayAPI = [[NSMutableArray alloc] init];
    for (NSString * str in arrayStore) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:str forKey:@"StoreId"];
        [arrayAPI addObject:dict];
    }
    
    NSMutableDictionary * dict = [self genBodyDataDict:arrayAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/DelFollowStore"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetVisualDisplayList:(NSString *)FollowStoreId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:FollowStoreId forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/GetVisualDisplayList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in arrayResult)
        {
            VisualDisplay *visualDisplay=[[VisualDisplay alloc]init];
            visualDisplay.strVisualDisplayId=[self ValidString:dict forKey:@"VisualDisplayId"];
            visualDisplay.strTitle=[self ValidString:dict forKey:@"Title"];
            visualDisplay.strImgUrl=[self ValidString:dict forKey:@"ImgUrl"];
            visualDisplay.strUserName=[self ValidString:dict forKey:@"UserName"];
            visualDisplay.strComments=[self ValidString:dict forKey:@"Comments"];
            visualDisplay.states=[self ValidNumber:dict forKey:@"Status" defaultValue:0].integerValue;
            visualDisplay.x=[self ValidFloatNumber:dict forKey:@"X" defaultValue:0.0];
            visualDisplay.y=[self ValidFloatNumber:dict forKey:@"Y" defaultValue:0.0];
            visualDisplay.rank=[self ValidNumber:dict forKey:@"Rank" defaultValue:NO].integerValue;
            [array addObject:visualDisplay];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)AddVisualDisplayModel:(NSString *)storeId Title:(NSString *)title Comment:(NSString*)comment X:(float)x Y:(float)y Images:(NSMutableArray *)arrayImg Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    if (comment==nil)
    {
        comment=@"";
    }
    
     NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:storeId forKey:@"StoreId"];
    [dictAPI setObject:title forKey:@"Title"];
    [dictAPI setObject:comment forKey:@"Comments"];
    [dictAPI setObject:[NSNumber numberWithFloat:x] forKey:@"X"];
    [dictAPI setObject:[NSNumber numberWithFloat:y] forKey:@"Y"];
    NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
    for (VMImage * image in arrayImg) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        UIImage * img=image.imgData;
        NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(img, 0.5)];
        [dict setObject:strImage forKey:@"ImgData"];
        if (image.strComments==nil)
        {
            image.strComments=@"";
        }
        [dict setObject:image.strComments forKey:@"Comments"];
        [dict setObject:[NSNumber numberWithFloat:image.regX] forKey:@"RegX"];
        [dict setObject:[NSNumber numberWithFloat:image.regY] forKey:@"RegY"];
        [dict setObject:[NSNumber numberWithFloat:image.regWidth] forKey:@"RegWidth"];
        [dict setObject:[NSNumber numberWithFloat:image.regHeight] forKey:@"RegHeight"];
        [arrayImage addObject:dict];
    }
    [dictAPI setObject:arrayImage forKey:@"Images"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/AddVisualDisplay"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)GetStoreInfo:(NSString *)storeId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:storeId forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"store/GetStoreInfo"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        StoreDetailInfo * storeInfo = [self CreateStoreDetailByDict:dictResult];
        SuccessBlock(storeInfo);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)AddReplyModel:(NSString *)visualDisplayId StoreId:(NSString *)storeId Type:(int)type Comments:(NSString *)comments ImageArray:(NSMutableArray *)arrayImg Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    if (comments==nil)
    {
        comments=@"";
    }
    
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:visualDisplayId forKey:@"VisualDisplayId"];
    [dictAPI setObject:storeId forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:type] forKey:@"Type"];
    [dictAPI setObject:comments forKey:@"Comments"];
    NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
    for (VMImage * image in arrayImg) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        UIImage * img=image.imgData;
        NSString * strImage =  [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(img, 0.5)];
        [dict setObject:strImage forKey:@"ImgData"];
        if (image.strComments==nil)
        {
            image.strComments=@"";
        }
        [dict setObject:image.strComments forKey:@"Comments"];
        [dict setObject:[NSNumber numberWithFloat:image.regX] forKey:@"RegX"];
        [dict setObject:[NSNumber numberWithFloat:image.regY] forKey:@"RegY"];
        [dict setObject:[NSNumber numberWithFloat:image.regWidth] forKey:@"RegWidth"];
        [dict setObject:[NSNumber numberWithFloat:image.regHeight] forKey:@"RegHeight"];
        [arrayImage addObject:dict];
    }
    [dictAPI setObject:arrayImage forKey:@"Images"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/AddReply"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)GetReplyList:(NSString *)visualDisplayId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:visualDisplayId forKey:@"VisualDisplayId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/GetReplyList"] isCheckWifi:NO withData:dict success:^(NSDictionary * dictResult) {
        ReplyList *replyList=[[ReplyList alloc]init];
        NSMutableDictionary *dicReplys=[dictResult objectForKey:@"Replys"];
        NSMutableDictionary *dicImgs=[dictResult objectForKey:@"ReplyImgs"];
        NSMutableArray *arrayReplys=[[NSMutableArray alloc]init];
        NSMutableArray *arrayImgs=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in dicReplys)
        {
            VMReply *reply=[[VMReply alloc]init];
            reply.strVisualDisplayId=[self ValidString:dict forKey:@"VisualDisplayDetailId"];
            reply.rank=[self ValidNumber:dict forKey:@"Rank" defaultValue:0].integerValue;
            reply.strUserId=[self ValidString:dict forKey:@"UserId"];
            reply.strUsername=[self ValidString:dict forKey:@"UserName"];
            reply.strComment=[self ValidString:dict forKey:@"Comments"];
//            reply.strDate=[self ValidString:dict forKey:@"AddDate"];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
            [dateFormatter1 setDateFormat:@"MM/dd"];
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
            [dateFormatter2 setDateFormat:@"cccc"];
            NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc]init];
            [dateFormatter3 setDateFormat:@"HH:mm"];
            NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc]init];
            [dateFormatter4 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date=[dateFormatter4 dateFromString:[self ValidString:dict forKey:@"AddDate"]];
            
            NSString *strDay=[dateFormatter1 stringFromDate:date];
            NSString *strWeek=[dateFormatter2 stringFromDate:date];
            NSString *strTime=[dateFormatter3 stringFromDate:date];
//            if ([strWeek isEqualToString:@"星期一"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Monday",@"RPString", g_bundleResorce,nil);
//            }
//            else if([strWeek isEqualToString:@"星期二"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Tuesday",@"RPString", g_bundleResorce,nil);
//            }
//            else if([strWeek isEqualToString:@"星期三"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Wednesday",@"RPString", g_bundleResorce,nil);
//            }
//            else if([strWeek isEqualToString:@"星期四"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Thursday",@"RPString", g_bundleResorce,nil);
//            }
//            else if([strWeek isEqualToString:@"星期五"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Friday",@"RPString", g_bundleResorce,nil);
//            }
//            else if([strWeek isEqualToString:@"星期六"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Saturday",@"RPString", g_bundleResorce,nil);
//            }
//            else if([strWeek isEqualToString:@"星期天"])
//            {
//                strWeek=NSLocalizedStringFromTableInBundle(@"Sunday",@"RPString", g_bundleResorce,nil);
//            }
            reply.strDate=[NSString stringWithFormat:@"%@ %@ %@",strDay,strWeek,strTime];
            reply.type=[self ValidNumber:dict forKey:@"Type" defaultValue:0].integerValue;
            reply.states=[self ValidNumber:dict forKey:@"Status" defaultValue:0].integerValue;
            NSMutableArray *dicImgDetail=[dict objectForKey:@"Images"];
            NSMutableArray *arrayImgDetail=[[NSMutableArray alloc]init];
            for (NSDictionary * dict in dicImgDetail)
            {
                ReplyImgDetail *imgDetail=[[ReplyImgDetail alloc]init];
                imgDetail.strImgId=[self ValidString:dict forKey:@"ImgId"];
                imgDetail.regX=[self ValidFloatNumber:dict forKey:@"RegX" defaultValue:0.0];
                imgDetail.regY=[self ValidFloatNumber:dict forKey:@"RegY" defaultValue:0.0];
                imgDetail.regWidth=[self ValidFloatNumber:dict forKey:@"RegWidth" defaultValue:0.0];
                imgDetail.regHeigth=[self ValidFloatNumber:dict forKey:@"RegHeight" defaultValue:0.0];
                [arrayImgDetail addObject:imgDetail];
            }
            reply.arrayimgReply=arrayImgDetail;
            [arrayReplys addObject:reply];
        }
        for (NSDictionary * dict in dicImgs)
        {
            ReplyImg *replyImg=[[ReplyImg alloc]init];
            replyImg.strImgId=[self ValidString:dict forKey:@"ImgId"];
            replyImg.strComments=[self ValidString:dict forKey:@"Comments"];
            replyImg.strImgPath=[self ValidString:dict forKey:@"ImgPath"];
            replyImg.strThumbPath=[self ValidString:dict forKey:@"ThumbPath"];
            replyImg.strUserName=[self ValidString:dict forKey:@"UserName"];
            replyImg.rank=[self ValidNumber:dict forKey:@"Rank" defaultValue:0].integerValue;
            [arrayImgs addObject:replyImg];
        }
        replyList.arrayImg=arrayImgs;
        replyList.arrayReply=arrayReplys;
        SuccessBlock(replyList);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)AddReference:(NSString *)visualDisplayId StoreId:(NSString *)storeId Type:(int)type Comments:(NSString *)comments ImageArray:(NSMutableArray *)arrayImg Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    if (comments==nil)
    {
        comments=@"";
    }
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:visualDisplayId forKey:@"VisualDisplayId"];
    [dictAPI setObject:storeId forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:type] forKey:@"Type"];
    [dictAPI setObject:comments forKey:@"Comments"];
    NSMutableArray * arrayImage = [[NSMutableArray alloc] init];
    for (VMImage * image in arrayImg) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
       [dict setObject:image.strImgId forKey:@"ImgData"];
        if (image.strComments==nil)
        {
            image.strComments=@"";
        }
        [dict setObject:image.strComments forKey:@"Comments"];
        [dict setObject:[NSNumber numberWithFloat:image.regX] forKey:@"RegX"];
        [dict setObject:[NSNumber numberWithFloat:image.regY] forKey:@"RegY"];
        [dict setObject:[NSNumber numberWithFloat:image.regWidth] forKey:@"RegWidth"];
        [dict setObject:[NSNumber numberWithFloat:image.regHeight] forKey:@"RegHeight"];
        [arrayImage addObject:dict];
    }
    [dictAPI setObject:arrayImage forKey:@"Images"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/AddReply"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)UpdateVisualDisplayStatus:(NSString *)visualDisplayId Status:(int)states Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:visualDisplayId forKey:@"VisualDisplayId"];
    [dictAPI setObject:[NSNumber numberWithInt:states] forKey:@"Status"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/UpdateVisualDisplayStatus"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)DelReply:(NSString *)visualDisplayDetailId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:visualDisplayDetailId forKey:@"VisualDisplayDetailId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"VisualDisplay/DelReply"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
@end
