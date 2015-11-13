//
//  RPAddCalender.h
//  RetailPlus
//
//  Created by lin dong on 14-9-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Foundation/Foundation.h>
#import "RPConfDefine.h"

@protocol RPAddCalenderDelegate <NSObject>
    -(void)OnAddCalenderEnd;
@end

@interface RPAddCalender : NSObject<EKEventEditViewDelegate>
{
    PLSqliteDatabase * _dbPointer;
    TaskInfo         * _task;
}

@property (nonatomic,strong) id<RPAddCalenderDelegate> delegate;
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) EKCalendar *defaultCalendar;

+(RPAddCalender *)defaultInstance;

-(BOOL)IsCalenderAddToTask:(TaskInfo *)task;
-(void)AddTaskToCalender:(TaskInfo *)task;
@end
