//
//  RPSDK+ELearning.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-30.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPSDK.h"
#import "RPSDKELDefine.h"
@interface RPSDK (ELearning)
-(void)GetPaperListSuccess:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetQuestionList:(NSString *)paperId Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)UploadExam:(RPELPaper *)paper Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)UploadExamTemp:(RPELPaper *)paper;
-(NSMutableArray *)GetPaperCacheList:(CacheType)typeGet;


-(void)GetCourseCatagory:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)UpdateLearnRecord:(RPELCourseWare *)courseware inCourse:(RPELCourse *)course Success:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;


-(void)GetLearnRecCatagory:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
-(void)GetExamRecCatagory:(RPSDKSuccess)SuccessBlock Failed:(RPSDKFailed)FailedBlock;
@end
