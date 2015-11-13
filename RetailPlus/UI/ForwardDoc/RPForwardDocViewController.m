//
//  RPForwardDocViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-12-11.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPForwardDocViewController.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@interface RPForwardDocViewController ()

@end

@implementation RPForwardDocViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"FORWARD DOCUMENT",@"RPString", g_bundleResorce,nil);
    
    InspReporters * reports = [[InspReporters alloc] init];
    reports.arraySection = [[NSMutableArray alloc] init];
    InspReporterSection * sec = [[InspReporterSection alloc] init];
    sec.strTitle1 = [NSString stringWithFormat:@"%@:%@ %@",_doc.strDocType,_doc.strStoreName,_doc.strBrandName];
    sec.strTitle2 = [NSString stringWithFormat:@"%@  %@",_doc.strAuthor,_doc.strCreateTime];
    [reports.arraySection addObject:sec];
    
    NSString * strTitle = NSLocalizedStringFromTableInBundle(@"Selected Document",@"RPString", g_bundleResorce,nil);
    _viewReport.strTitle = strTitle;
    _viewReport.delegate = self;
    _viewReport.reporters = reports;
    _viewReport.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewReport];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnEndAddUser:(InspReporters *)reporters
{
    InspReporterSection * section =[reporters.arraySection objectAtIndex:0];
    NSMutableArray * arrayUser = [[NSMutableArray alloc] init];
    NSMutableArray * arrayEmail = [[NSMutableArray alloc] init];
    
    for (InspReporterUser * user in section.arrayUser)
    {
        if (user.bSelected) {
            if (user.bUserCollegue)
            {
                [arrayUser addObject:user.collegue.strUserId];
                if (user.collegue.strWorkEmail && user.collegue.strWorkEmail.length > 0)                [arrayEmail addObject:user.collegue.strWorkEmail];
            }
            else
                [arrayEmail addObject:user.strEmail];
        }
    }
    NSString * showStatus = NSLocalizedStringFromTableInBundle(@"Forwarding...",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:showStatus];
    
    [[RPSDK defaultInstance] ForwardDocument:_doc.strDocumentID RecvUserList:arrayUser RecvMailList:arrayEmail Success:^(id idResult) {
        [self.delegate OnTaskEnd];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {

    }];
}

-(BOOL)OnBack
{
    return [_viewReport OnBack];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

@end
