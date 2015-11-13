//
//  RPSDK+DailyStock.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-14.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSDK+DailyStock.h"
#import "RPNetModule.h"
@implementation RPSDK (DailyStock)
-(void)GetStoreStock:(NSString *)strStoreID SN:(NSInteger)sn IsLatest:(BOOL)isLatest IsQuery:(BOOL)isQuery Query:(NSString *)query Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{

    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:sn] forKey:@"SN"];
    [dictAPI setObject:[NSNumber numberWithBool:isLatest] forKey:@"IsLatest"];
    [dictAPI setObject:[NSNumber numberWithBool:isQuery] forKey:@"IsQuery"];
    [dictAPI setObject:query forKey:@"Query"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    NSString * strUrl = nil;
    if (self.bDemoMode)
    {
        strUrl = [NSString stringWithFormat:@"StockTakingBook/GetStoreStock%d",sn];
        if (isQuery)
        {
            strUrl = @"StockTakingBook/GetStoreStockAll";
        }
    }
    else
    {
        strUrl = @"StockTakingBook/GetStoreStock";
    }
    
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dictResult in arrayResult)
        {
            StoreStockList *storeStockList=[[StoreStockList alloc]init];
            storeStockList.SN=[self ValidNumber:dictResult forKey:@"SN" defaultValue:0].integerValue;
            storeStockList.openTime=[self ValidDate:dictResult forKey:@"OpenTime"];
            storeStockList.closeTime=[self ValidDate:dictResult forKey:@"CloseTime"];
            storeStockList.strCloseUserId=[self ValidString:dictResult forKey:@"CloseUserId"];
            storeStockList.countAmount=[self ValidNumber:dictResult forKey:@"CountAmount" defaultValue:0].integerValue;
            storeStockList.lastAmount=[self ValidNumber:dictResult forKey:@"LastAmount" defaultValue:0].integerValue;
            storeStockList.inAmount=[self ValidNumber:dictResult forKey:@"InAmount" defaultValue:0].integerValue;
            storeStockList.outAmount=[self ValidNumber:dictResult forKey:@"OutAmount" defaultValue:0].integerValue;
            storeStockList.balanceAmount=[self ValidNumber:dictResult forKey:@"BalanceAmount" defaultValue:0].integerValue;
            storeStockList.strComments=[self ValidString:dictResult forKey:@"Comments"];
            storeStockList.userInfo=[self CreateUserDetailByDict:[dictResult objectForKey:@"UserDetail"]];
            [array addObject:storeStockList];
        }
            SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)PostStoreStockCount:(NSString *)strStoreID SN:(NSInteger)sn Count:(NSInteger)count Tag1:(NSString *)tag1 Tag2:(NSString *)tag2 Tag3:(NSString *)tag3 Comments:(NSString *)comments Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    if (tag1==nil)
    {
        tag1=@"";
    }
    if (tag2==nil)
    {
        tag2=@"";
    }
    if (tag3==nil)
    {
        tag3=@"";
    }
    if (comments==nil)
    {
        comments=@"";
    }
    
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:sn] forKey:@"SN"];
    [dictAPI setObject:[NSNumber numberWithInt:count] forKey:@"Count"];
    [dictAPI setObject:tag1 forKey:@"Tag1"];
    [dictAPI setObject:tag2 forKey:@"Tag2"];
    [dictAPI setObject:tag3 forKey:@"Tag3"];
    [dictAPI setObject:comments forKey:@"Comments"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"StockTakingBook/PostStoreStockCount"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetTagList:(NSString *)strStoreID Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"StockTakingBook/GetTagList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in arrayResult)
        {
            FavTagList *favTagList=[[FavTagList alloc]init];
           NSMutableDictionary * dic =[dict objectForKey:@"Tags"];
            NSMutableArray *arrayTag=[[NSMutableArray alloc]init];
            for (NSDictionary * dicTag in dic)
            {
                RPDSTag *tagList=[[RPDSTag alloc]init];
                tagList.strTagName=[self ValidString:dicTag forKey:@"Tag"];
                [arrayTag addObject:tagList];
            }
            favTagList.arrayTag=arrayTag;
            favTagList.isLast= [self ValidNumber:dict forKey:@"IsLast" defaultValue:NO].boolValue;
            [array addObject:favTagList];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetStoreStockDetail:(NSString *)strStoreID SN:(NSInteger)sn Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:sn] forKey:@"SN"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    NSString * strUrl = nil;
    if (self.bDemoMode)
        strUrl = [NSString stringWithFormat:@"StockTakingBook/GetStoreStockDetail%d",sn];
    else
        strUrl = @"StockTakingBook/GetStoreStockDetail";
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
       
        for (NSDictionary * dict in arrayResult)
        {
             RPDSDetail *rpDSDetail=[[RPDSDetail alloc]init];
            NSArray * arrayDicLast =[dict objectForKey:@"LastList"];
            NSArray * arrayDicCurrent =[dict objectForKey:@"CurrentList"];
            NSArray * arrayDicInOut =[dict objectForKey:@"IOList"];
            NSArray * arrayDicTag =[dict objectForKey:@"TagList"];
            NSMutableArray *arrayLast=[[NSMutableArray alloc]init];
            NSMutableArray *arrayCurrent=[[NSMutableArray alloc]init];
            NSMutableArray *arrayInOut=[[NSMutableArray alloc]init];
            NSMutableArray *arrayTag=[[NSMutableArray alloc]init];
            for (NSDictionary * dicTag in arrayDicTag)
            {
                RPDSTag *tagList=[[RPDSTag alloc]init];
                tagList.strTagName=[self ValidString:dicTag forKey:@"Tag"];
                if (tagList.strTagName.length>0)
                {
                    [arrayTag addObject:tagList];
                }
                
            }
            
            for (NSDictionary * dicLast in arrayDicLast)
            {
                RPDSCurrentStock *rpDSCurrentStock=[[RPDSCurrentStock alloc]init];
                rpDSCurrentStock.strCountId=[self ValidString:dicLast forKey:@"CountId"];
                rpDSCurrentStock.nCount=[self ValidNumber:dicLast forKey:@"Count" defaultValue:0].integerValue;
                rpDSCurrentStock.dateAdd=[self ValidDate:dicLast forKey:@"AddDate"];
                rpDSCurrentStock.userInfo=[self CreateUserDetailByDict:[dicLast objectForKey:@"UserDetail"]];
                [arrayLast addObject:rpDSCurrentStock];
            }
            
            for (NSDictionary * dicCurrent in arrayDicCurrent)
            {
                RPDSCurrentStock *rpDSCurrentStock=[[RPDSCurrentStock alloc]init];
                rpDSCurrentStock.strCountId=[self ValidString:dicCurrent forKey:@"CountId"];
                rpDSCurrentStock.nCount=[self ValidNumber:dicCurrent forKey:@"Count" defaultValue:0].integerValue;
                rpDSCurrentStock.dateAdd=[self ValidDate:dicCurrent forKey:@"AddDate"];
                rpDSCurrentStock.userInfo=[self CreateUserDetailByDict:[dicCurrent objectForKey:@"UserDetail"]];
                [arrayCurrent addObject:rpDSCurrentStock];
            }
            
            for (NSDictionary * dicInOut in arrayDicInOut)
            {
                RPDSIOStock *rpDSIOStock=[[RPDSIOStock alloc]init];
                rpDSIOStock.strCountId=[self ValidString:dicInOut forKey:@"IOId"];
                rpDSIOStock.dateAdd=[self ValidDate:dicInOut forKey:@"AddDate"];
                rpDSIOStock.userInfo=[self CreateUserDetailByDict:[dicInOut objectForKey:@"UserDetail"]];
                rpDSIOStock.strComment=[self ValidString:dicInOut forKey:@"Comments"];
                rpDSIOStock.nCount=[self ValidNumber:dicInOut forKey:@"Count" defaultValue:0].integerValue;
                rpDSIOStock.typeIO=[self ValidNumber:dicInOut forKey:@"Type" defaultValue:-1].integerValue;
                [arrayInOut addObject:rpDSIOStock];
            }
            
            rpDSDetail.arrayTags=arrayTag;
            rpDSDetail.arrayLast=arrayLast;
            rpDSDetail.arrayCurrent=arrayCurrent;
            rpDSDetail.arrayIO=arrayInOut;
            rpDSDetail.strStockDetailId=[self ValidString:dict forKey:@"DetailId"];
            rpDSDetail.strStoreId=[self ValidString:dict forKey:@"Storeid"];
            rpDSDetail.SN=[self ValidString:dict forKey:@"SN"];
            rpDSDetail.nLastAmount=[self ValidNumber:dict forKey:@"LastAmount" defaultValue:0].integerValue;
            rpDSDetail.nCurrentAmount=[self ValidNumber:dict forKey:@"CountAmount" defaultValue:0].integerValue;
            rpDSDetail.nInAmount=[self ValidNumber:dict forKey:@"InAmount" defaultValue:0].integerValue;
            rpDSDetail.nOutAmount=[self ValidNumber:dict forKey:@"OutAmount" defaultValue:0].integerValue;
            [array addObject:rpDSDetail];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)PostStoreStockIOCount:(NSString *)strStoreID Type:(RPDSIOType)type SN:(NSInteger)sn Count:(NSInteger)count Tag1:(NSString *)tag1 Tag2:(NSString *)tag2 Tag3:(NSString *)tag3 Comments:(NSString *)comments Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    if (tag1==nil)
    {
        tag1=@"";
    }
    if (tag2==nil)
    {
        tag2=@"";
    }
    if (tag3==nil)
    {
        tag3=@"";
    }
    if (comments==nil)
    {
        comments=@"";
    }
    
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:type] forKey:@"Type"];
    [dictAPI setObject:[NSNumber numberWithInt:sn] forKey:@"SN"];
    [dictAPI setObject:[NSNumber numberWithInt:count] forKey:@"Count"];
    [dictAPI setObject:tag1 forKey:@"Tag1"];
    [dictAPI setObject:tag2 forKey:@"Tag2"];
    [dictAPI setObject:tag3 forKey:@"Tag3"];
    [dictAPI setObject:comments forKey:@"Comments"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"StockTakingBook/PostStoreStockIOCount"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)FinishStockTaking:(NSString *)strStoreID SN:(NSInteger)sn Comments:(NSString *)comments Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strStoreID forKey:@"StoreId"];
    [dictAPI setObject:[NSNumber numberWithInt:sn] forKey:@"SN"];
    [dictAPI setObject:comments forKey:@"Comments"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"StockTakingBook/FinishStockTaking"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)DeleteStockDetail:(NSString *)strCountID Type:(NSString *)type Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:strCountID forKey:@"Id"];
    [dictAPI setObject:type forKey:@"Type"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI withToken:YES];
    [RPNetModule doRequest:[self genURL:@"StockTakingBook/DeleteStockDetail"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
@end
