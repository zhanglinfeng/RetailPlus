//
//  RPInspReportsView.m
//  RetailPlus
//
//  Created by lin dong on 13-9-4.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "RPInspReportsView.h"
#import "RPInspReportsCell.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;

@implementation RPInspReportsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib
{
    _viewFrame.layer.cornerRadius = 8;
}

-(void)GetReports:(StoreDetailInfo *)store
{
    _arrayReports = nil;
    [_tbReport reloadData];
    [_btnSelectAll setSelected:NO];
    _bSelectAll = NO;
    
    NSString * str = NSLocalizedStringFromTableInBundle(@"Getting reports...",@"RPString", g_bundleResorce,nil);
    
    [SVProgressHUD showWithStatus:str];

    [[RPSDK defaultInstance] GetInspHistory:store.strStoreId Success:^(NSMutableArray * arrayResult) {
        _arrayReports = arrayResult;
        [_tbReport reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayReports == nil) return 0;
    return _arrayReports.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPInspReportsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPInspReportsCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPInspCell" owner:self options:nil];
        cell = [array objectAtIndex:3];
        cell.delegate = self;
    }
    cell.report = [_arrayReports objectAtIndex:indexPath.row];
    return cell;
}

-(IBAction)OnSelctAll:(id)sender
{
    _bSelectAll = !_bSelectAll;
    
    for (InspReportResult * report in _arrayReports) {
        report.bSelected = _bSelectAll;
    }
    
    [_btnSelectAll setSelected:_bSelectAll];
    [_tbReport reloadData];
}

-(IBAction)OnCombineInsp:(id)sender
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (InspReportResult * reportGet in _arrayReports) {
        if (reportGet.bSelected) {
            for (InspReportResultDetail * detailGet in reportGet.arrayDetail) {
                BOOL bFound = NO;
                for (InspReportResultDetail * detail in array) {
                    if ([detailGet.strCatagoryID isEqualToString:detail.strCatagoryID]) {
                        detail.mark = (detail.mark < detailGet.mark) ? detail.mark : detailGet.mark;
                        if (detailGet.arrayIssue.count > 0) {
                            [detail.arrayIssue addObjectsFromArray:detailGet.arrayIssue];
                        }
                        
                        bFound = YES;
                        break;
                    }
                }
                if (!bFound) {
                    [array addObject:detailGet];
                }
            }
        }
    }
    
    if (array.count != 0)
        [self.delegate OnCombineReportsEnd:array];
    else
    {
        NSString * str = NSLocalizedStringFromTableInBundle(@"No issues exist",@"RPString", g_bundleResorce,nil);
        [SVProgressHUD showErrorWithStatus:str];
    }
}

-(void)OnSelect:(InspReportResult *)report
{
    _bSelectAll = YES;
    
    if (report.bSelected == NO)
        _bSelectAll = NO;
    else
    {
        for (InspReportResult * reportGet in _arrayReports) {
            if (reportGet.bSelected == NO) {
                _bSelectAll = NO;
                break;
            }
        }
    }
    
    [_btnSelectAll setSelected:_bSelectAll];
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

@end
