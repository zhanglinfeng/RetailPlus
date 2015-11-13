//
//  RPSDK+ELearning.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-30.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSDK+ELearning.h"
#import "RPNetModule.h"
#import "RPMutableDictionary.h"
@implementation RPSDK (ELearning)
-(void)GetPaperListSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"ELearning/GetPaperList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in arrayResult)
        {
            RPELPaperList *rpELPaperList=[[RPELPaperList alloc]init];
            NSMutableArray *arrayDic=[dict objectForKey:@"Papers"];
            NSMutableArray *arrayPaper=[[NSMutableArray alloc]init];
            for (NSDictionary *dicPaper in arrayDic)
            {
                RPELPaper *paper=[[RPELPaper alloc]init];
                paper.strId=[self ValidString:dicPaper forKey:@"PaperId"];
                paper.strNo=[self ValidString:dicPaper forKey:@"PaperCode"];
                paper.strType=[self ValidString:dicPaper forKey:@"PaperTag"];
                paper.strTitle=[self ValidString:dicPaper forKey:@"PaperName"];
                paper.strReminder=[self ValidString:dicPaper forKey:@"PaperTip"];
                paper.nScore=[self ValidDoubleNumber:dicPaper forKey:@"LatestScore" defaultValue:NO].floatValue;
                [arrayPaper addObject:paper];
            }
            rpELPaperList.strType=[self ValidString:dict forKey:@"PaperTag"];
            rpELPaperList.bExpand=YES;
            rpELPaperList.arrayRPELPaper=arrayPaper;
            [array addObject:rpELPaperList];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)GetQuestionList:(NSString *)paperId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:paperId forKey:@"PaperId"];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    NSString * strUrl = nil;
    if (self.bDemoMode)
    {
        strUrl = [NSString stringWithFormat:@"ELearning/GetQuestionList%@",paperId];
    }
    else
    {
        strUrl = @"ELearning/GetQuestionList";
    }
    [RPNetModule doRequest:[self genURL:strUrl] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (NSDictionary * dict in arrayResult)
        {
            RPELQuestion *question=[[RPELQuestion alloc]init];
            question.strId=[self ValidString:dict forKey:@"QuestionId"];
            question.strNo=[self ValidString:dict forKey:@"QuestionCode"];
            question.strThumbUrl=[self ValidString:dict forKey:@"ImgUrl"];
            question.strTitle=[self ValidString:dict forKey:@"QuestionTitle"];
            question.strDesc=[self ValidString:dict forKey:@"QuestionDesc"];
            question.questionsType=[self ValidNumber:dict forKey:@"QuestionType" defaultValue:NO].integerValue;
            NSString *s=[self ValidString:dict forKey:@"Options"];
            if (s.length>0) {
                //将字符串按逗号分割为数组
                NSArray *arrayStr=[s componentsSeparatedByString:@"|"];
                NSMutableArray *arrayOption=[[NSMutableArray alloc]init];
                for (NSString *s in arrayStr)
                {
                    RPELOption *option=[[RPELOption alloc]init];
                    option.bSelect=NO;
                    option.strOption=s;
                    [arrayOption addObject:option];
                }
                question.arrayOption=arrayOption;
            }
           
            [array addObject:question];
        }
        SuccessBlock(array);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(NSMutableDictionary*)paperForDic:(RPELPaper *)paper
{
     NSMutableDictionary * dictAPI = [[NSMutableDictionary alloc] init];
    [dictAPI setObject:paper.strId forKey:@"PaperId"];
    [dictAPI setObject:paper.strNo forKey:@"PaperCode"];
    [dictAPI setObject:paper.strTitle forKey:@"PaperName"];
    NSMutableArray *arrayAnswers=[[NSMutableArray alloc]init];
    for (RPELQuestion *question in paper.arrayQuestions)
    {
        if (question.arrayAnswers.count>0)
        {
            NSMutableDictionary * dictAnswer = [[NSMutableDictionary alloc] init];
            [dictAnswer setObject:question.strId forKey:@"QuestionId"];
            
            NSMutableArray *array=[[NSMutableArray alloc]init];
            for (int i=0; i<question.arrayAnswers.count; i++)
            {
                [array addObject:[((RPELOption *)[question.arrayAnswers objectAtIndex:i]).strOption substringToIndex:1]];
            }
            NSString *s=[array componentsJoinedByString:@"|"];
            [dictAnswer setObject:s forKey:@"Answer"];
            [arrayAnswers addObject:dictAnswer];
        }
    }
    [dictAPI setObject:arrayAnswers forKey:@"Answers"];
    return dictAPI;
}


-(void)UploadExam:(RPELPaper *)paper Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSMutableDictionary * dictAPI=[self paperForDic:paper];
    [array addObject:dictAPI];
    
    NSMutableDictionary * dict = [self genBodyDataDict:array  withToken:YES];
    [RPNetModule doRequest:[self genURL:@"ELearning/UploadExam"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        SuccessBlock(nil);
    }failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
-(void)UploadExamTemp:(RPELPaper *)paper
{
    if (self.bDemoMode) {
        return;
    }
    NSString *s=[NSString stringWithFormat:@"%@,%@",paper.strNo,paper.strTitle];
    [self SaveUploadCache:(NSDictionary *)[self paperForDic:paper] Type:CACHETYPE_ELEARNINGEXAM Desc:s];
}

-(NSMutableArray *)GetPaperCacheList:(CacheType)typeGet
{
    NSMutableArray * arrayDoc = [[NSMutableArray alloc] init];
    for (CachData * data in self.arrayCacheData)
    {
        if (data.type == CACHETYPE_ELEARNINGEXAM) {
            Document * doc = [[Document alloc] init];
            doc.dataUnSent = data;
            doc.strDescEx = data.strDesc;
            NSDateFormatter  *dateformatter1=[[NSDateFormatter alloc] init];
            [dateformatter1 setDateFormat:@"HH:mm MM-dd-yyyy"];
//            [dateformatter1 setDateFormat:@"HH:mm MMMM dd'th' yyyy"];
            
//            NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
//            [dateformatter2 setDateFormat:@"MMMM"];
//            
//            NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
//            [dateformatter3 setDateFormat:@"dd"];
            
            NSString *strTime=[dateformatter1 stringFromDate:data.date];
            
            doc.strCreateTime =strTime;
            [arrayDoc addObject:doc];
        }
    }
    return arrayDoc;
}


-(void)GetCourseCatagory:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"ELearning/GetCourseList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult) {
        NSMutableArray * arrayCatagory = [[NSMutableArray alloc] init];
        for (NSDictionary * dictResult in arrayResult) {
            RPELCourse * course = [[RPELCourse alloc] init];
            course.strId = [self ValidString:dictResult forKey:@"CourseId"];
            course.strNo = [self ValidString:dictResult forKey:@"CourseCode"];
            course.strName = [self ValidString:dictResult forKey:@"CourseName"];
            course.strDesc = [self ValidString:dictResult forKey:@"CourseDesc"];
            course.strThumbUrl = [self ValidString:dictResult forKey:@"ThumbImg"];
            course.dateAdd = [self ValidDate:dictResult forKey:@"AddDate"];
            course.arrayCourseWare = [[NSMutableArray alloc] init];
            NSArray * arrayWareResult = [dictResult objectForKey:@"CourseWares"];
            for (NSDictionary * dictWareResult in arrayWareResult) {
                RPELCourseWare * ware = [[RPELCourseWare alloc] init];
                ware.strId = [self ValidString:dictWareResult forKey:@"CoursewareId"];
                ware.strNo = [self ValidString:dictWareResult forKey:@"CoursewareCode"];
                ware.strName = [self ValidString:dictWareResult forKey:@"CoursewareName"];
                ware.strDesc = [self ValidString:dictWareResult forKey:@"CoursewareDesc"];
                ware.strDownloadUrl = [self ValidString:dictWareResult forKey:@"AttachPath"];
                ware.strReadUrl = [self ValidString:dictWareResult forKey:@"HtmlPath"];
                ware.strThumbUrl = [self ValidString:dictWareResult forKey:@"ThumbImg"];
                ware.dateAdd = [self ValidDate:dictWareResult forKey:@"AddDate"];
                ware.bRead = [self ValidNumber:dictWareResult forKey:@"IsRead" defaultValue:NO].boolValue;
                [course.arrayCourseWare addObject:ware];
            }
            
            NSString * strCatagory = [self ValidString:dictResult forKey:@"CourseTag"];
            BOOL bFound = NO;
            for (RPELCourseCatagory * catagory in arrayCatagory) {
                if ([catagory.strCatagory isEqualToString:strCatagory]) {
                    [catagory.arrayCourse addObject:course];
                    bFound = YES;
                    break;
                }
            }
            
            if (!bFound) {
                RPELCourseCatagory * catagory = [[RPELCourseCatagory alloc] init];
                catagory.strCatagory = strCatagory;
                catagory.arrayCourse = [[NSMutableArray alloc] init];
                [catagory.arrayCourse addObject:course];
                catagory.bExpand = YES;
                [arrayCatagory addObject:catagory];
            }
        }
        SuccessBlock(arrayCatagory);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)UpdateLearnRecord:(RPELCourseWare *)courseware inCourse:(RPELCourse *)course Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    if (self.bDemoMode) {
        SuccessBlock(nil);
        return;
    }
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    [dictAPI setObject:course.strId forKey:@"CourseId"];
    [dictAPI setObject:courseware.strId forKey:@"CoursewareId"];
    [dictAPI setObject:courseware.strNo forKey:@"CoursewareCode"];
    [dictAPI setObject:courseware.strName forKey:@"CoursewareName"];
    [dictAPI setObject:course.strName forKey:@"CourseName"];
    
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    [RPNetModule doRequest:[self genURL:@"ELearning/UploadLearnRecord"] isCheckWifi:NO withData:dict success:^(id idResult) {
        SuccessBlock(nil);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetLearnRecCatagory:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yyyy";
    
    [RPNetModule doRequest:[self genURL:@"ELearning/GetLearnRecordList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult){
        NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
        for (NSDictionary * dictResult in arrayResult) {
            RPELLearnRecord * rec = [[RPELLearnRecord alloc] init];
            rec.strCourseId = [self ValidString:dictResult forKey:@"CourseId"];
            rec.strCourseName = [self ValidString:dictResult forKey:@"CourseName"];
            rec.strCourseWareCode = [self ValidString:dictResult forKey:@"CoursewareCode"];
            rec.strCourseWareId = [self ValidString:dictResult forKey:@"CoursewareId"];
            rec.strCourseWareName = [self ValidString:dictResult forKey:@"CoursewareName"];
            rec.dateRead = [self ValidDate:dictResult forKey:@"LearnDate"];
            
            NSString * strCatagory = [formatter stringFromDate:rec.dateRead];
            BOOL bFound = NO;
            for (RPELRecordCatagory * catagory in arrayRet) {
                if ([catagory.strCatagory isEqualToString:strCatagory]) {
                    [catagory.arrayRecord addObject:rec];
                    bFound = YES;
                    break;
                }
            }
            
            if (!bFound) {
                RPELRecordCatagory * catagory = [[RPELRecordCatagory alloc] init];
                catagory.strCatagory = strCatagory;
                catagory.bExpand = YES;
                catagory.arrayRecord = [[NSMutableArray alloc] init];
                [catagory.arrayRecord addObject:rec];
                [arrayRet addObject:catagory];
            }
        }
        SuccessBlock(arrayRet);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}

-(void)GetExamRecCatagory:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock
{
    RPMutableDictionary * dictAPI = [[RPMutableDictionary alloc] init];
    NSMutableDictionary * dict = [self genBodyDataDict:dictAPI.dict  withToken:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yyyy";
    
    [RPNetModule doRequest:[self genURL:@"ELearning/GetExamRecordList"] isCheckWifi:NO withData:dict success:^(NSArray * arrayResult){
        NSMutableArray * arrayRet = [[NSMutableArray alloc] init];
        for (NSDictionary * dictResult in arrayResult) {
            RPELExamRecord * rec = [[RPELExamRecord alloc] init];
            rec.strNo = [self ValidString:dictResult forKey:@"PaperCode"];
            rec.strTitle = [self ValidString:dictResult forKey:@"PaperName"];
            rec.fScore = [self ValidNumber:dictResult forKey:@"Score" defaultValue:0].floatValue;
            rec.dateExam = [self ValidDate:dictResult forKey:@"ExamDate"];
            
            NSString * strCatagory = [formatter stringFromDate:rec.dateExam];
            BOOL bFound = NO;
            for (RPELRecordCatagory * catagory in arrayRet) {
                if ([catagory.strCatagory isEqualToString:strCatagory]) {
                    [catagory.arrayRecord addObject:rec];
                    bFound = YES;
                    break;
                }
            }
            
            if (!bFound) {
                RPELRecordCatagory * catagory = [[RPELRecordCatagory alloc] init];
                catagory.strCatagory = strCatagory;
                catagory.bExpand = YES;
                catagory.arrayRecord = [[NSMutableArray alloc] init];
                [catagory.arrayRecord addObject:rec];
                [arrayRet addObject:catagory];
            }
        }
        SuccessBlock(arrayRet);
    } failed:^(NSInteger nErrorCode, NSString *strDesc) {
        FailedBlock(nErrorCode,strDesc);
    }];
}
@end
