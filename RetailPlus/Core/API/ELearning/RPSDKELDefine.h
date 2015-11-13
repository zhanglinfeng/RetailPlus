//
//  RPSDKELDefine.h
//  RetailPlus
//
//  Created by lin dong on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>

//课程课件部分
//课程分组
@interface RPELCourseCatagory : NSObject
@property (nonatomic,retain) NSString           * strCatagory;
@property (nonatomic)BOOL                       bExpand;
@property (nonatomic,retain) NSMutableArray     * arrayCourse;
@end

//课程
@interface RPELCourse : NSObject
@property (nonatomic,retain) NSString           * strId;
@property (nonatomic,retain) NSString           * strNo;
@property (nonatomic,retain) NSString           * strName;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) NSDate             * dateAdd;
@property (nonatomic,retain) NSString           * strThumbUrl;
@property (nonatomic,retain) NSMutableArray     * arrayCourseWare;
@end

//课件
@interface RPELCourseWare : NSObject
@property (nonatomic,retain) NSString           * strId;
@property (nonatomic,retain) NSString           * strNo;
@property (nonatomic,retain) NSString           * strName;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) NSDate             * dateAdd;
@property (nonatomic) BOOL                      bRead;
@property (nonatomic,retain) NSString           * strThumbUrl;
@property (nonatomic,retain) NSString           * strReadUrl;
@property (nonatomic,retain) NSString           * strDownloadUrl;
@end

//试卷部分
typedef enum
{
    RPELQuestionType_SingleChoice = 1,
    RPELQuestionType_MultiChoice=2,
}RPELQuestionType;

@interface RPELPaperList : NSObject
@property (nonatomic,retain) NSString           * strType;
@property (nonatomic) BOOL                      bExpand;
@property (nonatomic,retain) NSMutableArray     * arrayRPELPaper;
@end


//试卷
@interface RPELPaper : NSObject
@property (nonatomic,retain) NSString           * strId;
@property (nonatomic,retain) NSString           * strNo;
@property (nonatomic,retain) NSString           * strType;
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic,retain) NSString           * strReminder;
@property (nonatomic) float                      nScore;
@property (nonatomic,retain) NSMutableArray     * arrayQuestions;
@property (nonatomic,retain) NSDate             * date;
@end


//试题
@interface RPELQuestion : NSObject
@property (nonatomic,retain) NSString           * strId;
@property (nonatomic,retain) NSString           * strNo;
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic,retain) NSString           * strDesc;
@property (nonatomic,retain) NSString           * strThumbUrl;
@property (nonatomic)RPELQuestionType           questionsType;
@property (nonatomic,retain) NSMutableArray            * arrayOption;
@property (nonatomic,retain) NSMutableArray     * arrayAnswers;
@end

@interface RPELOption : NSObject
@property (nonatomic) BOOL                        bSelect;
@property (nonatomic,retain) NSString           * strOption;
@end

//答卷
@interface RPELExam : NSObject
@property (nonatomic,retain) NSString           * strId;
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic) BOOL                      bPassed;
@property (nonatomic) float                      nScore;
@property (nonatomic,retain) NSDate             * dateAdd;
@end


//每道题目回答
@interface RPELExamAnswer : NSObject
@property (nonatomic,retain) NSString           * strId;
@property (nonatomic,retain) NSMutableArray     * arrayAnswers;
@end

//学习考试记录部分
//记录归纳
@interface RPELRecordCatagory : NSObject
@property (nonatomic,retain) NSString           * strCatagory;
@property (nonatomic)BOOL                       bExpand;
@property (nonatomic,retain) NSMutableArray     * arrayRecord;
@end

//学习记录
@interface RPELLearnRecord : NSObject
@property (nonatomic,retain) NSString           * strCourseId;
@property (nonatomic,retain) NSString           * strCourseWareId;
@property (nonatomic,retain) NSString           * strCourseName;
@property (nonatomic,retain) NSString           * strCourseWareName;
@property (nonatomic,retain) NSString           * strCourseWareCode;
@property (nonatomic,retain) NSDate             * dateRead;
@end

//考试记录
@interface RPELExamRecord : NSObject
@property (nonatomic,retain) NSString           * strNo;
@property (nonatomic,retain) NSString           * strTitle;
@property (nonatomic) float                       fScore;
@property (nonatomic,retain) NSDate             * dateExam;
@end
