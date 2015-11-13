//
//  RPDocLiveView.m
//  RetailPlus
//
//  Created by lin dong on 13-11-22.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPDocLiveView.h"
#import "RPDocAllCell.h"
#import "RPDocSentCell.h"
#import "RPDocUnfinishedCell.h"
#import "RPWebDocViewController.h"
#import "SVProgressHUD.h"

extern NSBundle * g_bundleResorce;

@implementation RPDocLiveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)awakeFromNib
{
    taskType=DocLiveTaskType_Recv;
    
    _isRecvOnly=YES;
    [_btRecOnly setBackgroundImage:[UIImage imageNamed:@"button_r_only_checked.png"] forState:UIControlStateNormal];
    _nExpandCellIndex = -1;
//    [self loadData];
    
    
    //view 设置圆角样式
//    _viewMask.layer.cornerRadius = 8;
//    _viewMask.layer.shadowOffset = CGSizeMake(0, 1);
//    _viewMask.layer.shadowRadius =3.0;
//    _viewMask.layer.shadowColor =[UIColor blackColor].CGColor;
//    _viewMask.layer.shadowOpacity =0.5;
    
//    _uvBackground.layer.cornerRadius=8;
//    _uvBackground.layer.masksToBounds=YES;
    _uvSearch.layer.cornerRadius=6;
    _uvSearch.layer.masksToBounds=YES;
    _uvBGround.layer.cornerRadius=10;
    
    _uvBGround.layer.shadowOffset = CGSizeMake(0, 1);
    _uvBGround.layer.shadowRadius =3.0;
    _uvBGround.layer.shadowColor =[UIColor blackColor].CGColor;
    _uvBGround.layer.shadowOpacity =0.5;

//    _uvBGround.layer.masksToBounds=YES;
    
    
    
    [_tbDocument setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_ivTopbar setImage:[UIImage imageNamed:@"image_topbar_p1_docu.png"]];
    
//    [_receCell setDocCellDelegate:self];
    //输入的同时也进行搜索
  //  [_tfSearch addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingChanged];
    
    //cell长按事件
    UILongPressGestureRecognizer *longPressReger =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 0.5;
    [_tbDocument addGestureRecognizer:longPressReger];
    
    
    
    _rcUvBackground = _uvBackground.frame;
    
    _ivDocuments.alpha=0;
    _ivPublish.alpha=0;
    _ivUnfinished.alpha=0;
    //显示红点
    [self showRedPoint];
    getPointTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(showRedPoint) userInfo:nil repeats:YES];
    
    //添加RefreshView到tableView
    _refreshView=[[RefreshView alloc]initWithOwner:_tbDocument delegate:self];
    //[self refresh];
    
    [self setUpForDismissKeyboard];
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    tapGr.cancelsTouchesInView = NO;
//    [self.uvBGround addGestureRecognizer:tapGr];
//    NSLog(@"woshi===%@",self);
//    isKeyboardShow=NO;
    
    _strLastAllDocId = @"";
    _strLastSentDocId = @"";
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
    
//    NSTimeInterval  interval = 24*60*60*7; //1:天数
//    NSDate *dateBef = [nowDate initWithTimeIntervalSinceNow:-interval];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    
    NSDate *dateBef = [calendar dateByAddingComponents:adcomps toDate:nowDate options:0];
    
    _datePickerStart = [[RPDatePicker alloc] init:_tfStartDate Format:dateFormatter1 curDate:dateBef canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    _datePickerEnd = [[RPDatePicker alloc] init:_tfEndDate Format:dateFormatter1 curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    _search = [[RPSearch alloc] InitWithParent:_uvSearch Delegate:self];
    
    [[RPSDK defaultInstance] GetStoreList:SituationType_NotAssign Success:^(NSArray * arrayStore) {
        _arrayStore = arrayStore;
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
//    singleTapGR.cancelsTouchesInView = NO;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbDocument addGestureRecognizer:singleTapGR];
//                    NSLog(@"ziji===%@",self);
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [_tbDocument removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
}
// 停止，可以触发自己定义的停止方法
-(void)stopLoading
{
    [_refreshView stopLoading];
}
//开始，可以触发自定义的开始方法
-(void)startLoading
{
    [_refreshView startLoading];
    //模拟3后停止
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3];
}
//刷新
-(void)refresh
{
    [self startLoading];
    [self loadData];
    [self showRedPoint];
    //模拟3后停止
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3];
//    [_tbDocument reloadData];
    [self stopLoading];
    
}

-(void)refreshViewDidCallBack
{
    [self refresh];
    
}

//刚拖动时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshView scrollViewWillBeginDragging:scrollView];
}
//拖动过程中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidScroll:scrollView];
}
//拖动结束后
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


//cell长按事件
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_tbDocument];
    NSIndexPath *indexPath = [_tbDocument indexPathForRowAtPoint:point];
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan===%d",indexPath.row);
//    }
//    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged===%d",indexPath.row);
//    }
//    
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded===%d",indexPath.row);
//    }
    _nExpandCellIndex = indexPath.row;
    [_tbDocument reloadData];
}
//显示红点
-(void)showRedPoint
{
    _ivDocuments.alpha=0;
    _ivPublish.alpha=0;
    _ivUnfinished.alpha=0;

    BOOL bFound=NO;
    NSArray * array = _arrayDocAll;
    NSString *s=@"";
    NSArray *tempArray=[self genSearchArray:array condition:s receivedOnly:YES FiltDomainDate:YES];
    for (int i=0; i<tempArray.count; i++)
    {
        Document *doc=[tempArray objectAtIndex:i];
        if (doc.isNew)
        {
            _ivDocuments.alpha=1;
            bFound=YES;
            break;
        }
    }

//    if (!bFound)
//    {
//        [[RPSDK defaultInstance]HaveLatestDocument:_strLastAllDocId Success:^(id idResult)
//        {
//            _ivDocuments.alpha=1;
//
//        }
//        Failed:^(NSInteger nErrorCode, NSString *strDesc)
//        {
//            _ivDocuments.alpha=0;
//        }];
//    }
    

    for (int i = 0; i<_arrayDocUnSent.count; i++)
    {
        Document *doc=[_arrayDocUnSent objectAtIndex:i];
        if (!doc.isUnSentUploading)
        {
            _ivPublish.alpha=1;
            break;
        }
    }
    
    if (_arrayDocUnfinish.count>0) {
        _ivUnfinished.alpha=1;
    }
    
}


-(void)OnShowDocView
{
    if (_arrayDocAll && _arrayDocAll.count > 0) return;
    [self loadData];
}

 //加载数据
-(void)loadData
{
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Loading document list",@"RPString", g_bundleResorce,nil);
    [SVProgressHUD showWithStatus:strDesc];
    
    [[RPSDK defaultInstance]GetDocumentList:_strLastAllDocId GetDocType:GetDocType_All Success:^(NSMutableArray * array) {
        if (array.count > 0) {
            if (_arrayDocAll.count == 0) {
                _arrayDocAll = array;
            }
            else
            {
                for(NSInteger n = array.count - 1;n >= 0;n --)
                {
                    Document * doc = [array objectAtIndex:n];
                    BOOL bFound = NO;
                    for (Document * doc2 in _arrayDocAll) {
                        if ([doc2.strDocumentID isEqualToString:doc.strDocumentID]) {
                            bFound = YES;
                            break;
                        }
                    }
                    if (!bFound) {
                        [_arrayDocAll insertObject:doc atIndex:0];
                    }
                }
            }
            
            _strLastAllDocId = ((Document *)[array objectAtIndex:0]).strDocumentID;
            
            _arraySearchDoc = [self genSearchArray:_arrayDocAll condition:[_search GetSearchString] receivedOnly:_isRecvOnly FiltDomainDate:YES];
            [_tbDocument reloadData];
        }
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
    
    [[RPSDK defaultInstance]GetDocumentList:@"" GetDocType:GetDocType_UnSent Success:^(NSMutableArray * array) {
        _arrayDocUnSent=array;
        _arraySearchUnsent = [self genSearchArray:_arrayDocUnSent condition:[_search GetSearchString] receivedOnly:NO FiltDomainDate:NO];
        [_tbDocument reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
    
    [[RPSDK defaultInstance]GetDocumentList:_strLastSentDocId GetDocType:GetDocType_Sent Success:^(NSMutableArray * array) {
        if (array.count > 0) {
            if (_arrayDocSent.count == 0) {
                _arrayDocSent = array;
            }
            else
            {
                for(NSInteger n = array.count - 1;n >= 0;n --)
                {
                    Document * doc = [array objectAtIndex:n];
                    BOOL bFound = NO;
                    for (Document * doc2 in _arrayDocSent) {
                        if ([doc2.strDocumentID isEqualToString:doc.strDocumentID]) {
                            bFound = YES;
                            break;
                        }
                    }
                    if (!bFound) {
                        [_arrayDocSent insertObject:doc atIndex:0];
                    }
                }
            }
            
            _strLastSentDocId = ((Document *)[array objectAtIndex:0]).strDocumentID;
            
            _arraySearchSent = [self genSearchArray:_arrayDocSent condition:[_search GetSearchString] receivedOnly:NO FiltDomainDate:YES];
            [_tbDocument reloadData];
        }
       [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
    
    [[RPSDK defaultInstance]GetDocumentList:@"" GetDocType:GetDocType_UnFinished Success:^(NSMutableArray * array) {
        _arrayDocUnfinish=array;
        _arraySearchUnfinished = [self genSearchArray:_arrayDocUnfinish condition:[_search GetSearchString] receivedOnly:NO FiltDomainDate:NO];
        [_tbDocument reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        [SVProgressHUD dismiss];
    }];
}

//判断网络状况
-(void)judgeStatus
{
    NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
    switch (networkStatus) {
        case NotReachable:
        {
            
            break;
        }
        case ReachableViaWiFi:
        {
            
            break;
        }
        case ReachableViaWWAN:
        {
            
            break;
        }

        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (taskType) {
        case DocLiveTaskType_Recv:
        {
            

            //根据是否展开显示下面四个button来确定cell高度
            if (indexPath.row == _nExpandCellIndex) {
                return 111;
                
            }
            else
            {
                return 59;
            }
            
            break;
        }
        case DocLiveTaskType_Sent:
        {
            //判断sent中是哪种文档
            if (indexPath.row < _arraySearchUnsent.count)
            {
                //根据是否展开显示下面四个button来确定cell高度
                if (indexPath.row == _nExpandCellIndex) {
                    return 111;
                }
                else
                {
                    return 59;
                }

            }
            else
            {
                //根据是否展开显示下面四个button来确定cell高度
                if (indexPath.row == _nExpandCellIndex) {
                    return 111;
                }
                else
                {
                    return 59;
                }
            }
            
            break;

        }
        case DocLiveTaskType_Unfinish:
        {
            //根据是否展开显示下面四个button来确定cell高度
            if (indexPath.row == _nExpandCellIndex) {
                return 111;
                
            }
            else
            {
                return 59;
            }

            break;
        }
        default:
            break;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (taskType) {
        case DocLiveTaskType_Recv:
        {
          //  NSLog(@"所有文档数目＝＝＝%d",_arraySearchDoc.count);
            return _arraySearchDoc.count;
            
            break;
        }
        case DocLiveTaskType_Sent:
        {
          //  NSLog(@"发布文档数目＝＝＝%d",_arraySearchUnsent.count+_arraySearchSent.count);
            return _arraySearchUnsent.count+_arraySearchSent.count;
            
            break;
        }
        case DocLiveTaskType_Unfinish:
        {
         //   NSLog(@"未完成文档数目＝＝＝%d",_arraySearchUnfinished.count);
            return _arraySearchUnfinished.count;
            
            break;
        }
        default:
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (taskType) {
        case DocLiveTaskType_Recv:
        {
            RPDocAllCell *cell=(RPDocAllCell *)[tableView dequeueReusableCellWithIdentifier:@"RPDocAllCell"];
            if (cell == nil)
            {
                NSArray *nib = [g_bundleResorce loadNibNamed:@"RPDocAllCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
            Document *docAll;
            docAll=[_arraySearchDoc objectAtIndex:indexPath.row];
            cell.doc=docAll;
            cell.docCellDelegate = self;
            [cell.ivTypeImage setImage:[UIImage imageNamed:@"icon_normal doc.png"]];
            
            if (indexPath.row == _nExpandCellIndex)
                [cell ShowExpand:YES];
            else
                [cell ShowExpand:NO];
            
            return cell;
            break;
        }
            
            
        case DocLiveTaskType_Sent:
        {
            
            if (indexPath.row < _arraySearchUnsent.count)
            {
                NSArray *array = [g_bundleResorce loadNibNamed:@"RPDocSentCell" owner:self options:nil];
                RPDocSentCell* cell = [array objectAtIndex:0];
                
                Document *docUnsent=[_arraySearchUnsent objectAtIndex:indexPath.row];
                cell.doc = docUnsent;
                cell.delegate=self;
                //如果是上传文档得最后一个则画则让下划线显示
                if (indexPath.row==_arraySearchUnsent.count-1)
                {
                    cell.lineImage.alpha=1.0;
                    if (indexPath.row == _nExpandCellIndex)
                    {
                        cell.lineImage.frame=CGRectMake(0, cell.frame.size.height-3, cell.frame.size.width, 3);
                    }
                }
                if (indexPath.row == _nExpandCellIndex)
                    [cell ShowExpand:YES];
                else
                    [cell ShowExpand:NO];
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
                return cell;
        
            }
            else
            {
                Document * docSent=[_arraySearchSent objectAtIndex:indexPath.row-_arraySearchUnsent.count];
                NSArray *array = [g_bundleResorce loadNibNamed:@"RPDocAllCell" owner:self options:nil];
                RPDocAllCell * cell = [array objectAtIndex:0];
                
                cell.doc=docSent;
                cell.docCellDelegate = self;
                cell.ivReceived.alpha=0;
                
                if (indexPath.row == _nExpandCellIndex)
                    [cell ShowExpand:YES];
                else
                    [cell ShowExpand:NO];
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
                return cell;
            }
            
            
            break;
        }
        case DocLiveTaskType_Unfinish:
        {
            RPDocUnfinishedCell *cell=(RPDocUnfinishedCell *)[tableView dequeueReusableCellWithIdentifier:@"RPDocUnfinishedCell"];
            if (cell == nil)
            {
                NSArray *nib = [g_bundleResorce loadNibNamed:@"RPDocUnfinishedCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            Document *docUf=[_arraySearchUnfinished objectAtIndex:indexPath.row];
            
            cell.doc=docUf;
            cell.docCellDelegate=self;
            if (indexPath.row == _nExpandCellIndex)
                [cell ShowExpand:YES];
            else
                [cell ShowExpand:NO];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
            return cell;
            
            
            break;
        }
            
            
        default:
            break;
    }
}

-(void)UploadCache:(Document *)doc
{
    doc.isUnSentUploading=YES;
    [_tbDocument reloadData];
    
    [[RPSDK defaultInstance] SubmitCacheData:doc.dataUnSent Success:^(id idResult) {
        NSMutableArray * arrayTemp = [[NSMutableArray alloc] initWithArray:_arrayDocUnSent];
        [arrayTemp removeObject:doc];
        _arrayDocUnSent = arrayTemp;
        _arraySearchUnsent = [self genSearchArray:_arrayDocUnSent condition:[_search GetSearchString] receivedOnly:NO FiltDomainDate:NO];
        [_tbDocument reloadData];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        doc.isUnSentUploading=NO;
        
        [_tbDocument reloadData];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (taskType) {
        case DocLiveTaskType_Recv:
        {
//            if(!isKeyboardShow)
//            {
                if(_nExpandCellIndex == -1)
                {
                    Document * doc = [_arraySearchDoc objectAtIndex:indexPath.row];
                    doc.isNew=NO;
                    
                    NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
                    switch (networkStatus)
                    {
                        case NotReachable:
                        {
                            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Network not found",@"RPString", g_bundleResorce,nil);
                            [SVProgressHUD showErrorWithStatus:strDesc];
                            break;
                        }
                        case ReachableViaWiFi:
                        {
                            RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
                            vcWeb.cache = [RPSDK defaultInstance].cacheDocumentLive;
                            //vcSignUp.delegate = self;
                            vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            vcWeb.strUrl = doc.strDocumentURL;
                            vcWeb.strTitle = doc.strFileName;
                            
                            //                    NSDictionary * dict = [[RPSDK defaultInstance].cacheDocumentLive cachedResponseHeadersForURL:[NSURL URLWithString:vcWeb.strUrl]];
                            
                            [self.viewController presentViewController:vcWeb animated:YES completion:^{
                                
                            }];
                            
                            if (doc.isNew) {
                                [[RPSDK defaultInstance] SetDocumentRead:doc.strDocumentID Success:^(id idResult) {
                                    doc.isNew = NO;
                                    [_tbDocument reloadData];
                                } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                                    
                                }];
                            }
                            
                            [self loadData];
                            [self showRedPoint];
                            break;
                        }
                        case ReachableViaWWAN:
                        {
                            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to view document now?",@"RPString", g_bundleResorce,nil);
                            RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                                if (indexButton==1)
                                {
                                    
                                    
                                    RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
                                    vcWeb.cache = [RPSDK defaultInstance].cacheDocumentLive;
                                    //vcSignUp.delegate = self;
                                    vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                    vcWeb.strUrl = doc.strDocumentURL;
                                    vcWeb.strTitle = doc.strFileName;
                                    //                    NSDictionary * dict = [[RPSDK defaultInstance].cacheDocumentLive cachedResponseHeadersForURL:[NSURL URLWithString:vcWeb.strUrl]];
                                    
                                    [self.viewController presentViewController:vcWeb animated:YES completion:^{
                                        
                                    }];
                                    
                                    if (doc.isNew) {
                                        [[RPSDK defaultInstance] SetDocumentRead:doc.strDocumentID Success:^(id idResult) {
                                            doc.isNew = NO;
                                            [_tbDocument reloadData];
                                        } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                                            
                                        }];
                                    }
                                    [self loadData];
                                    [self showRedPoint];
                                }
                            }otherButtonTitles:strOK, nil];
                            [alertView show];
                            
                            break;
                        }
                            
                        default:
                            break;
                    }
                    
                    
                    
                   
                }
                else
                {
                    _nExpandCellIndex = -1;
                
                }
                [_tbDocument reloadData];
//            }
            break;
        }
        case DocLiveTaskType_Sent:
        {
//            if(!isKeyboardShow)
//            {
                if(indexPath.row < _arraySearchUnsent.count)
                {
                    if (_nExpandCellIndex==-1)
                    {
                        Document * doc = [_arraySearchUnsent objectAtIndex:indexPath.row];
                        if (!doc.isUnSentUploading)
                        {
                            NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
                            switch (networkStatus)
                            {
                                case NotReachable:
                                {
                                    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Network not found",@"RPString", g_bundleResorce,nil);
                                    [SVProgressHUD showErrorWithStatus:strDesc];
                                    break;
                                }
                                case ReachableViaWiFi:
                                {
                                    [self UploadCache:doc];
                                    break;
                                }
                                case ReachableViaWWAN:
                                {
                                    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                                    NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                                    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to upload now?",@"RPString", g_bundleResorce,nil);
                                    RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                                            if (indexButton==1)
                                            {
                                                [self UploadCache:doc];
                                            }
                                    }otherButtonTitles:strOK, nil];
                                    [alertView show];

                                    break;
                                }
                                
                                default:
                                    break;
                            }
                        }
                    }
                    else
                    {
                        _nExpandCellIndex=-1;
                    }
                }
                else
                {
                    if (_nExpandCellIndex==-1)
                    {
                        Document * doc = [_arrayDocSent objectAtIndex:indexPath.row-_arraySearchUnsent.count];
                        
                        NetworkStatus networkStatus=[RPSDK GetConnectionStatus];
                        switch (networkStatus)
                        {
                            case NotReachable:
                            {
                                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Network not found",@"RPString", g_bundleResorce,nil);
                                [SVProgressHUD showErrorWithStatus:strDesc];
                                break;
                            }
                            case ReachableViaWiFi:
                            {
                                RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
                                vcWeb.cache = [RPSDK defaultInstance].cacheDocumentLive;
                                //vcSignUp.delegate = self;
                                vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                vcWeb.strUrl = doc.strDocumentURL;
                                vcWeb.strTitle = doc.strFileName;
                                
                                [self.viewController presentViewController:vcWeb animated:YES completion:^{
                                }];
                                
                                if (doc.isNew) {
                                    [[RPSDK defaultInstance] SetDocumentRead:doc.strDocumentID Success:^(id idResult) {
                                        doc.isNew = NO;
                                        [_tbDocument reloadData];
                                    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                                        
                                    }];
                                }
                                break;
                            }
                            case ReachableViaWWAN:
                            {
                                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"No WLAN connection. Confirm to view document now?",@"RPString", g_bundleResorce,nil);
                                RPBlockUIAlertView *alertView=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton) {
                                    if (indexButton==1)
                                    {
                                        
                                        RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
                                        vcWeb.cache = [RPSDK defaultInstance].cacheDocumentLive;
                                        //vcSignUp.delegate = self;
                                        vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                        vcWeb.strUrl = doc.strDocumentURL;
                                        vcWeb.strTitle = doc.strFileName;
                                        
                                        [self.viewController presentViewController:vcWeb animated:YES completion:^{
                                        }];
                                        
                                        if (doc.isNew) {
                                            [[RPSDK defaultInstance] SetDocumentRead:doc.strDocumentID Success:^(id idResult) {
                                                doc.isNew = NO;
                                                [_tbDocument reloadData];
                                            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                                                
                                            }];
                                        }
                                    }
                                }otherButtonTitles:strOK, nil];
                                [alertView show];
                                
                                break;
                            }
                                
                            default:
                                break;
                        }
                        
                        
                    }
                    else
                    {
                        _nExpandCellIndex=-1;
                    }
                    
                }
                [_tbDocument reloadData];
//            }
            break;
            
        }
        case DocLiveTaskType_Unfinish:
        {
//            if (!isKeyboardShow) {
            if(_nExpandCellIndex==-1)
            {
                NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
                NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to continue editing?",@"RPString", g_bundleResorce,nil);
                RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
                    
                    if (indexButton == 1) {
                        Document * doc = [_arraySearchUnfinished objectAtIndex:indexPath.row];
                        for (StoreDetailInfo * store in _arrayStore) {
                            if ([doc.strUnfinishStoreId isEqualToString:store.strStoreId])
                            {
                                switch (doc.UnfinishDocType) {
                                    case CACHETYPE_INSPECTION:
                                        [self.delegateStore OnStoreHandover:store];
                                        break;
                                    case CACHETYPE_MAINTEN:
                                        [self.delegateStore OnStoreMaintenance:store];
                                        break;
                                    case CACHETYPE_VISITING:
                                        [self.delegateStore OnStoreCVisit:store];
                                        break;
                                    case CACHETYPE_RECTIFICITION:
                                        break;
                                    case CACHETYPE_ELEARNINGEXAM:
                                        break;
                                    case CACHETYPE_BVISITING:
                                        [self.delegateStore OnStoreBVisit:store CacheDataId:doc.strDocumentID NeedLoadData:YES];
                                        break;
                                }
                                break;
                            }
                        }
                    }
                } otherButtonTitles:strOK,nil];
                [alertView show];
            }
            else
            {
                _nExpandCellIndex=-1;
                [_tbDocument reloadData];
            }
//            }
            break;
        }
        default:
            break;
    }

}

- (IBAction)unfinishedClick:(id)sender {
//    if(!isKeyboardShow)
//    {
        taskType=DocLiveTaskType_Unfinish;
    
        [_search SetSearchString:@""];
    
        [_uvReceOnly setHidden:YES];
        _uvBackground.frame=CGRectMake(_rcUvBackground.origin.x,_rcUvBackground.origin.y - 22,_rcUvBackground.size.width,_viewContent.frame.size.height - _rcUvBackground.origin.y + 22);
    
        _arraySearchUnfinished = _arrayDocUnfinish;
    
        self.lbReceived.alpha=0;
        self.lbSent.alpha=0;
        self.lbUnfinished.alpha=1;
    
        [_ivTopbar setImage:[UIImage imageNamed:@"image_topbar_p3_unfi.png"]];
    
        _nExpandCellIndex = -1;
        [self loadData];
    [self showRedPoint];
    [self UpdateUI];
    
    if (_bShowFilt) {
        _bShowFilt = NO;
        [UIView beginAnimations:nil context:nil];
        _viewFilt.frame = CGRectMake(0, _viewFilt.frame.origin.y, _viewFilt.frame.size.width, 0);
        _viewContent.frame = CGRectMake(0, _viewFilt.frame.origin.y + 8 , _viewContent.frame.size.width, self.frame.size.height - _viewFilt.frame.origin.y - 8);
        [UIView commitAnimations];
    }
//    }
}

- (IBAction)receiveClick:(id)sender {
//    if(!isKeyboardShow)
//    {
        taskType=DocLiveTaskType_Recv;
    
        [_search SetSearchString:@""];
    
        _uvBackground.frame=CGRectMake(_rcUvBackground.origin.x,_rcUvBackground.origin.y,_rcUvBackground.size.width,_viewContent.frame.size.height - _rcUvBackground.origin.y);
    
        [_uvReceOnly setHidden:NO];
        // _uvBackground.frame=CGRectMake(6, 96, 294, 260);
    
        //    _arraySearchDoc = _arrayDocAll;
    
        self.lbReceived.alpha=1;
        self.lbSent.alpha=0;
        self.lbUnfinished.alpha=0;
    
        [_ivTopbar setImage:[UIImage imageNamed:@"image_topbar_p1_docu.png"]];
    
        _nExpandCellIndex = -1;
        [self loadData];
    [self showRedPoint];
    [self UpdateUI];
    }
//}

- (IBAction)sentClick:(id)sender {
//    if (!isKeyboardShow)
//    {
        taskType=DocLiveTaskType_Sent;
        [_search SetSearchString:@""];
    
        _uvBackground.frame=CGRectMake(_rcUvBackground.origin.x,_rcUvBackground.origin.y - 22,_rcUvBackground.size.width,_viewContent.frame.size.height - _rcUvBackground.origin.y + 22);
    
    
        [_uvReceOnly setHidden:YES];
  //    _uvBackground.frame=CGRectMake(6, 66, 294, 290);
    
        _arraySearchUnsent = _arrayDocUnSent;
        _arraySearchSent=_arrayDocSent;
    
    
        self.lbReceived.alpha=0;
        self.lbSent.alpha=1;
        self.lbUnfinished.alpha=0;
    
        [_ivTopbar setImage:[UIImage imageNamed:@"image_topbar_p2_publ.png"]];
    
        _nExpandCellIndex = -1;
        [self loadData];
    [self showRedPoint];
    [self UpdateUI];
    }
//}

- (IBAction)clearClick:(id)sender {
    [self resignFirstResponder];
    [_search SetSearchString:@""];
    [self UpdateUI];
}

- (IBAction)receOnlyClick:(id)sender {
    if (![RPRights hasRightsFunc:[RPSDK defaultInstance].llRights type:RPRightsFuncType_CheckAllDomainDoc])
        return;
    
//    if(!isKeyboardShow)
//    {
        if (_isRecvOnly) {
            [_btRecOnly setBackgroundImage:[UIImage imageNamed:@"button_r_only_nochecked.png"] forState:UIControlStateNormal];
            _isRecvOnly=NO;
            _btRecOnly.alpha = 0.3;
        }
        else
        {
            [_btRecOnly setBackgroundImage:[UIImage imageNamed:@"button_r_only_checked.png"] forState:UIControlStateNormal];
            _isRecvOnly=YES;
            _btRecOnly.alpha = 1;
        }
    
        NSArray * array = _arrayDocAll;
        _arraySearchDoc = [self genSearchArray:array condition:[_search GetSearchString] receivedOnly:_isRecvOnly FiltDomainDate:YES];
        _nExpandCellIndex=-1;
        [_tbDocument reloadData];
    }
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    isKeyboardShow=YES;
//    NSLog(@"====== yes  -===");
    if (textField == _tfStartDate || textField == _tfEndDate)
    {
        _bEditingDate = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"======  no -===");
    if (textField == _tfStartDate || textField == _tfEndDate) {
        [self UpdateUI];
        _bEditingDate = NO;
    }
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *_string=[_tfSearch text];
//    [self search:_string];
//    [_tbDocument reloadData];
//    return YES;
//}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [_tfSearch resignFirstResponder];
//}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSString *str=[_tfSearch text];
//    [self search:str];
    [self endEditing:YES];
    return YES;
}

-(NSArray *)genSearchArray:(NSArray *)array condition:(NSString *)strSearch receivedOnly:(BOOL)isRecvOnly FiltDomainDate:(BOOL)bFiltDomainDate
{
    if (!strSearch) {
        strSearch=@"";
    }
    
//    if (strSearch.length == 0 && !isRecvOnly) {
//        return array;
//    }
    
    NSString *str=strSearch;
    NSMutableArray * arrayResult = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++)
    {
        Document *doc = [array objectAtIndex:i];
        
        NSRange res1 = [doc.strAuthor rangeOfString:str options:NSCaseInsensitiveSearch];
        NSRange res2 = [doc.strBrandName rangeOfString:str options:NSCaseInsensitiveSearch];
        NSRange res3 = [doc.strStoreName rangeOfString:str options:NSCaseInsensitiveSearch];
        NSRange res4 = [doc.strDocType rangeOfString:str options:NSCaseInsensitiveSearch];
        
        if (!isRecvOnly || (isRecvOnly && doc.isReceived))
        {
            if ((strSearch.length == 0) || (res1.length != 0  || res2.length != 0 || res3.length != 0 || res4.length != 0)) {
                if (bFiltDomainDate) {
                    if (_filtDomain) {
                        if (![doc.strDomainNo hasPrefix:_filtDomain.strDomainCode]) {
                            continue;
                        }
                    }
                    if (_filtStore) {
                        if (![doc.strDomainNo hasPrefix:_filtStore.strDomainNo]) {
                            continue;
                        }
                    }
                    
                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate * dateCreate = [dateformatter dateFromString:doc.strCreateTime];
                    [dateformatter setDateFormat:@"yyyy-MM-dd"];
                    NSString * strTemp = [dateformatter stringFromDate:dateCreate];
                    dateCreate = [dateformatter dateFromString:strTemp];
                    
                    NSDate * dateStart = [_datePickerStart GetDate];
                    strTemp = [dateformatter stringFromDate:dateStart];
                    dateStart = [dateformatter dateFromString:strTemp];
                    
                    NSDate * dateEnd = [_datePickerEnd GetDate];
                    strTemp = [dateformatter stringFromDate:dateEnd];
                    dateEnd = [dateformatter dateFromString:strTemp];
                    
                    if ([dateCreate compare:dateEnd] == NSOrderedDescending) continue;
                    if ([dateCreate compare:dateStart] == NSOrderedAscending) continue;
                }
                [arrayResult addObject:doc];
            }
        }
    }

    return arrayResult;
    
}

-(void)search:(UITextField*)sender
{;
    NSString *s=[sender text];
  //  NSLog(@"=====%@",s);
    switch (taskType) {
        case DocLiveTaskType_Recv:
        {
            NSArray * array = _arrayDocAll;
            _arraySearchDoc = [self genSearchArray:array condition:s receivedOnly:_isRecvOnly FiltDomainDate:YES];
            break;
        }
        case DocLiveTaskType_Sent:
        {
            NSArray * array1=_arrayDocUnSent;
            _arraySearchUnsent = [self genSearchArray:array1 condition:s receivedOnly:NO FiltDomainDate:NO];
            NSArray * array2=_arrayDocSent;
            _arraySearchSent=[self genSearchArray:array2 condition:s receivedOnly:NO FiltDomainDate:YES];
            break;
        }
        case DocLiveTaskType_Unfinish:
        {
            NSArray * array=_arrayDocUnfinish;
            _arraySearchUnfinished=[self genSearchArray:array condition:s receivedOnly:NO FiltDomainDate:NO];
            break;
        }
        default:
            break;
    }
    [_tbDocument reloadData];

}

-(void)OnDocumentTask:(Document*)doc btTag:(NSInteger)num
{
    switch (num) {
            //查看文档信息
        case 0:
        {
            UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
            _viewInfo.frame = keywindow.frame;
            _viewInfo.doc = doc;
            [keywindow addSubview:_viewInfo];
            [_viewInfo Show];
        }
            break;
            //转发文档
        case 1:
        {
            [self.delegate OnForwardDoc:doc];
            break;
        }
            //编辑文档
        case 2:
        {
            [[RPSDK defaultInstance]GetBVisitById:doc.strDocumentID Success:^(BVisitListModel * result) {
                [[RPSDK defaultInstance]GetStoreInfo:result.strStoreId Success:^(StoreDetailInfo * storeInfo) {
                    [self.delegate OnStoreBVisit:result Store:storeInfo];
                     } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                         [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
                     }];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTableInBundle(@"failure",@"RPString", g_bundleResorce,nil)];
            }];
            
            
            break;
        }
            //删除文档
        case 3:
        {
            NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
            NSString *strCancel=NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
            NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to delete?",@"RPString", g_bundleResorce,nil);
            RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
                if (indexButton == 1) {
                    //确定删除
                    [[RPSDK defaultInstance] DeleteDocument:doc.strDocumentID Success:^(id idResult) {
                        //删除成功
                        switch (taskType) {
                            case DocLiveTaskType_Recv:
                            {
                                NSMutableArray * arrayTemp = [[NSMutableArray alloc] initWithArray:_arrayDocAll];
                                [arrayTemp removeObject:doc];
                                _arrayDocAll = arrayTemp;
                                _arraySearchDoc = [self genSearchArray:_arrayDocAll condition:[_search GetSearchString] receivedOnly:_isRecvOnly FiltDomainDate:YES];
                            }
                                break;
                            case DocLiveTaskType_Sent:
                            {
                                NSMutableArray * arrayTemp = [[NSMutableArray alloc] initWithArray:_arrayDocSent];
                                [arrayTemp removeObject:doc];
                                _arrayDocSent = arrayTemp;
                                _arraySearchSent = [self genSearchArray:_arrayDocSent condition:[_search GetSearchString] receivedOnly:NO FiltDomainDate:YES];
                            }
                                break;
                            default:
                                break;
                        }
                        
                        [_tbDocument reloadData];
                        NSString * strOK2 = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
                        NSString * strDesc2 = NSLocalizedStringFromTableInBundle(@"Successfully deleted",@"RPString", g_bundleResorce,nil);
                        RPBlockUIAlertView *alertView2=[[RPBlockUIAlertView alloc]initWithTitle:nil message:strDesc2 cancelButtonTitle:strOK2 clickButton:^(NSInteger indexButton) {
                            
                        }otherButtonTitles:nil, nil];
                        [alertView2 show];
                        
                    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                        
                    }];
                }
            } otherButtonTitles:strOK,nil];
            [alertView show];
            
            _nExpandCellIndex=-1;
            break;
        }
        default:
            break;
    }
}

-(void)OnDeleteDoc:(Document *)doc
{
//    NSLog(@"delete unfinished");
//    [[RPSDK defaultInstance]ClearCacheData:doc.strUnfinishStoreId CacheType:doc.UnfinishDocType];
    [[RPSDK defaultInstance] ClearCacheDataById:doc.strDocumentID];
    
    [self loadData];
    _nExpandCellIndex=-1;
    [_tbDocument reloadData];
    
}
-(void)OnDeleteSentDoc:(Document *)doc
{
//    NSLog(@"delete sent");
    [[RPSDK defaultInstance]ClearUploadCache:doc.dataUnSent.strID];
    [self loadData];
    _nExpandCellIndex=-1;
    [_tbDocument reloadData];
}
-(void)Reload
{
    [self loadData];
}

-(IBAction)OnFilt:(id)sender
{
    if (taskType == DocLiveTaskType_Unfinish)
        return;
    
    _bShowFilt = !_bShowFilt;
    [UIView beginAnimations:nil context:nil];
    if (_bShowFilt) {
        _viewFilt.frame = CGRectMake(0, _viewFilt.frame.origin.y, _viewFilt.frame.size.width, 106);
        _viewContent.frame = CGRectMake(0, _viewFilt.frame.origin.y + 106 + 8, _viewContent.frame.size.width, self.frame.size.height - _viewFilt.frame.origin.y - 106 - 8);
    }
    else
    {
        _viewFilt.frame = CGRectMake(0, _viewFilt.frame.origin.y, _viewFilt.frame.size.width, 0);
        _viewContent.frame = CGRectMake(0, _viewFilt.frame.origin.y + 8 , _viewContent.frame.size.width, self.frame.size.height - _viewFilt.frame.origin.y - 8);
    }
    [UIView commitAnimations];
}

-(IBAction)OnResetFiltDate:(id)sender
{
    if (_bEditingDate) {
        return;
    }
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
    
//    NSTimeInterval  interval = 24*60*60*7; //1:天数
//    NSDate *dateBef = [nowDate initWithTimeIntervalSinceNow:-interval];
  
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    NSDate *dateBef = [calendar dateByAddingComponents:adcomps toDate:nowDate options:0];
    
    _datePickerStart = [[RPDatePicker alloc] init:_tfStartDate Format:dateFormatter1 curDate:dateBef canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    _datePickerEnd = [[RPDatePicker alloc] init:_tfEndDate Format:dateFormatter1 curDate:nowDate canDelete:NO Mode:UIDatePickerModeDate canFuture:NO canPreviously:YES];
    
    [self UpdateUI];
}

-(IBAction)OnSelectDomainStore:(id)sender
{
//    _viewStoreList.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height + 44);
//    _viewStoreList.tfSearch.text=@"";
//    [self addSubview:_viewStoreList];
//    
//    [UIView beginAnimations:nil context:nil];
//    _viewStoreList.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 44);
//    [UIView commitAnimations];
//    
//    [_viewStoreList reloadStore];
    [_delegateCtrl DoDomainSelect];
}

-(void)OnSelectDomain:(DomainInfo *)domain
{
    _filtDomain = domain;
    _filtStore = nil;
    _btnDeleteFiltDomain.hidden = NO;
    _tfFiltDomain.text = domain.strDomainName;
    
    [self UpdateUI];
}

-(void)OnSelectedStore:(StoreDetailInfo *)store
{
    _filtDomain = nil;
    _filtStore = store;
    _btnDeleteFiltDomain.hidden = NO;
    _tfFiltDomain.text = store.strStoreName;
    
    [self UpdateUI];
}

-(IBAction)OnClearFiltStoreDomain:(id)sender
{
    _filtDomain = nil;
    _filtStore = nil;
    _btnDeleteFiltDomain.hidden = YES;
    _tfFiltDomain.text = @"";
    
    [self UpdateUI];
}

-(void)UpdateUI
{
    NSString * s = [_search GetSearchString];
    
    switch (taskType) {
        case DocLiveTaskType_Recv:
        {
            NSArray * array = _arrayDocAll;
            _arraySearchDoc = [self genSearchArray:array condition:s receivedOnly:_isRecvOnly FiltDomainDate:YES];
            break;
        }
        case DocLiveTaskType_Sent:
        {
            NSArray * array1=_arrayDocUnSent;
            _arraySearchUnsent = [self genSearchArray:array1 condition:s receivedOnly:NO FiltDomainDate:NO];
            NSArray * array2=_arrayDocSent;
            _arraySearchSent=[self genSearchArray:array2 condition:s receivedOnly:NO FiltDomainDate:YES];
            break;
        }
        case DocLiveTaskType_Unfinish:
        {
            NSArray * array=_arrayDocUnfinish;
            _arraySearchUnfinished=[self genSearchArray:array condition:s receivedOnly:NO FiltDomainDate:NO];
            break;
        }
        default:
            break;
    }
    [_tbDocument reloadData];
}

-(void)OnSearchChange:(NSString *)strSearch
{
    [self UpdateUI];
}
@end
