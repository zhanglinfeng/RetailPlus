//
//  RPBVisitSelHistoryView.m
//  RetailPlus
//
//  Created by lin dong on 14-8-7.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPBVisitSelHistoryView.h"
#import "SVProgressHUD.h"
#import "RPUnfinishedReportCell.h"
#import "RPBlockUIAlertView.h"
extern NSBundle * g_bundleResorce;

@implementation RPBVisitSelHistoryView

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
//    UILongPressGestureRecognizer *longPressReger =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
//    longPressReger.minimumPressDuration = 0.5;
//    [_tbUnFinish addGestureRecognizer:longPressReger];
    
    _viewFrame.layer.cornerRadius = 8;
//    [self ReloadMyUnfinishData];
//    [self reloadOtherUnfinishData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPUnfinishedReportCell *cell=(RPUnfinishedReportCell *)[tableView dequeueReusableCellWithIdentifier:@"RPUnfinishedReportCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RPUnfinishedReportCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (_type==0)
    {
        Document *docUf = [_arrayUnfinish objectAtIndex:indexPath.row];
        cell.doc = docUf;
        cell.lbAuthorName.hidden=YES;
    }
    else
    {
        BVisitListModel *bVisitModel=[_arrayOtherUnfinish objectAtIndex:indexPath.row];
        cell.bVisitModel=bVisitModel;
        cell.lbAuthorName.hidden=NO;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type==0)
    {
        return _arrayUnfinish.count;
    }
    else
    {
        return _arrayOtherUnfinish.count;
    }
   
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to continue editing?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1)
            {
                if (_type==0)
                {
                    [SVProgressHUD showWithStatus:@""];
                    [[RPSDK defaultInstance] GetStoreList:SituationType_BVisit Success:^(NSArray * arrayStore) {
                        Document * doc = [_arrayUnfinish objectAtIndex:indexPath.row];
                        
                        for (StoreDetailInfo * store in arrayStore) {
                            if ([doc.strUnfinishStoreId isEqualToString:store.strStoreId])
                            {
                                [self.delegate OnSelectCacheData:doc.strDocumentID store:store];
                            }
                        }
                        [SVProgressHUD dismiss];
                    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                        
                    }];
                }
                else
                {
                    BVisitListModel *bVisitModel=[_arrayOtherUnfinish objectAtIndex:indexPath.row];
                    [[RPSDK defaultInstance]GetStoreInfo:bVisitModel.strStoreId Success:^(StoreDetailInfo * storeInfo) {
                        [self.delegate OnEditOtherReport:bVisitModel Store:storeInfo];
                    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
                    }];
                    
                }
                
            }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type==0)
    {
        Document * doc = [_arrayUnfinish objectAtIndex:indexPath.row];
        if (editingStyle==UITableViewCellEditingStyleDelete)
        {
            [self OnDeleteDoc:doc];
        }
    }
   
}


//-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    CGPoint point = [gestureRecognizer locationInView:_tbUnFinish];
//    NSIndexPath *indexPath = [_tbUnFinish indexPathForRowAtPoint:point];
//    _nExpandCellIndex = indexPath.row;
//    [_tbUnFinish reloadData];
//}

-(void)setStoreSelected:(StoreDetailInfo *)storeSelected
{
    _storeSelected=storeSelected;
}
-(void)ReloadMyUnfinishData
{
    _nExpandCellIndex = -1;
     NSArray *array= [[RPSDK defaultInstance] GetUnfinishedDoc:CACHETYPE_BVISITING];
    if (_storeSelected) {
        NSMutableArray *array2 =[[NSMutableArray alloc]init];
        for (Document *doc in array)
        {
            if ([doc.strUnfinishStoreId isEqualToString:_storeSelected.strStoreId]) {
                [array2 addObject:doc];
            }
        }
        _arrayUnfinish=array2;
    }
    else
    {
        _arrayUnfinish = [[RPSDK defaultInstance] GetUnfinishedDoc:CACHETYPE_BVISITING];
    }
    
    [_tbUnFinish reloadData];
    _lbLeftCount.text=[NSString stringWithFormat:@"(%i)",_arrayUnfinish.count];
    
    
    
    
}
-(void)reloadOtherUnfinishData
{
    _nExpandCellIndex = -1;
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"Loading...",@"RPString", g_bundleResorce,nil)];
    [[RPSDK defaultInstance]GetBVisitListSuccess:^(NSMutableArray * arrayResult)
     {
         [SVProgressHUD dismiss];
         if (_storeSelected) {
             _arrayOtherUnfinish=[[NSMutableArray alloc]init];
             for (BVisitListModel *bVisitListModel in arrayResult)
             {
                 if ([bVisitListModel.strStoreId isEqualToString:_storeSelected.strStoreId]) {
                     [_arrayOtherUnfinish addObject:bVisitListModel];
                 }
             }
         }
         else
         {
             _arrayOtherUnfinish=arrayResult;
         }
         
         [_tbUnFinish reloadData];
         _lbRightCount.text=[NSString stringWithFormat:@"(%i)",_arrayOtherUnfinish.count];
     } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
         [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
     }];
}

- (IBAction)OnMyUnfinished:(id)sender
{
    _viewLeft.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _lbLeft.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbLeftCount.textColor=[UIColor colorWithWhite:0.7 alpha:1];
    
    _viewRight.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbRight.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    _lbRightCount.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    _type=0;
    [self ReloadMyUnfinishData];
}

- (IBAction)OnReceivedUnfinished:(id)sender
{
    _viewRight.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    _lbRight.textColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbRightCount.textColor=[UIColor colorWithWhite:0.7 alpha:1];
    
    _viewLeft.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1];
    _lbLeft.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    _lbLeftCount.textColor=[UIColor colorWithWhite:0.5 alpha:1];
    
    _type=1;
    [self reloadOtherUnfinishData];
}

-(void)OnDeleteDoc:(Document *)doc
{
    [[RPSDK defaultInstance] ClearCacheDataById:doc.strDocumentID];
    [self ReloadMyUnfinishData];
}

-(IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self];
}

-(IBAction)OnQuit:(id)sender
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self.delegate OnHistoryQuit];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
    
}
@end
