//
//  RPAddCalender.m
//  RetailPlus
//
//  Created by lin dong on 14-9-18.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPAddCalender.h"
#import "RPAppDelegate.h"
#import "RPMainViewController.h"

#define CALENDERTITLE       @"RPlus Task"

#define kDBCalenderFileName  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RPTaskCalender.sqlite"]

@implementation RPAddCalender

static RPAddCalender *defaultObject;

+(RPAddCalender *)defaultInstance
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
        _eventStore = [[EKEventStore alloc] init];
        [self checkEventStoreAccessForCalendar];
        
        
    }
    return ret;
}



// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
            break;
        default:
            break;
    }
}

-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             [self accessGrantedForCalendar];
         }
     }];
}

-(void)accessGrantedForCalendar
{
    NSArray * arrayCalenders = [_eventStore calendarsForEntityType:EKEntityTypeEvent];
    BOOL bFound = NO;
    for(EKCalendar * calendor in arrayCalenders)
    {
        if ([calendor.title isEqualToString:CALENDERTITLE])
        {
            _defaultCalendar = calendor;
            bFound = YES;
            break;
        }
    }
    if (!bFound)
    {
        EKSource *localSource = nil;
        for (EKSource *source in self.eventStore.sources)
        {
            if (source.sourceType == EKSourceTypeLocal)
            {
                localSource = source;
                break;
            }
        }
        
        if (localSource)
        {
            self.defaultCalendar = [self.eventStore calendarWithIdentifier:CALENDERTITLE];
            self.defaultCalendar = [EKCalendar calendarWithEventStore:_eventStore];
            self.defaultCalendar.title = CALENDERTITLE;
            self.defaultCalendar.source = localSource;
            [self.eventStore saveCalendar: self.defaultCalendar commit:YES error:nil];
        }
    }
    
    _dbPointer = [[PLSqliteDatabase alloc] initWithPath:kDBCalenderFileName];
    if (_dbPointer) {
        if ([_dbPointer open]) {
            [_dbPointer executeUpdate:@"CREATE TABLE \"TaskCalender\" (\"Id\" TEXT PRIMARY KEY, \"TaskId\" TEXT)"];
        }
    }
}

-(BOOL)IsCalenderAddToTask:(TaskInfo *)task
{
    NSString * str = [NSString stringWithFormat:@"select * from TaskCalender where TaskId = '%@'",task.strTaskId];
    
    id<PLResultSet> ds = [_dbPointer executeQuery:str];
    if ([ds next])
        return YES;
    return NO;
}

-(void)AddTaskToCalender:(TaskInfo *)task
{
    EKEvent *calEvent = [EKEvent eventWithEventStore:self.eventStore];
    calEvent.title = task.strTitle;
    calEvent.startDate = [task dateEnd];
    calEvent.endDate = [task dateEnd];
    //    calEvent.location = self.event.address.title;
    //    [calEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
    
	// Create an instance of EKEventEditViewController
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    //	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
	// Set addController's event store to the current event store
	addController.eventStore = self.eventStore;
    addController.event = calEvent;
    addController.editViewDelegate = self;
    
    RPAppDelegate * app = (RPAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.viewController presentViewController:addController animated:YES completion:nil];
    
    _task = task;
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
		  didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller dismissViewControllerAnimated:YES completion:^{
        if (action == EKEventEditViewActionSaved)
        {
            [_dbPointer executeUpdate:@"insert into TaskCalender (Id,TaskId) values (?,?)", controller.event.eventIdentifier,_task.strTaskId];
            [self.delegate OnAddCalenderEnd];
        }
    }];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    
	return self.defaultCalendar;
}
@end
