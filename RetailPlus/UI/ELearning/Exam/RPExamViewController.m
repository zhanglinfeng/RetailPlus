//
//  RPExamViewController.m
//  RetailPlus
//
//  Created by zhanglinfeng on 14-7-24.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPExamViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

extern NSBundle * g_bundleResorce;
@interface RPExamViewController ()

@end

@implementation RPExamViewController

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
    _viewFrame.layer.cornerRadius=10;
    
    
    _lbPaperCode.text=_paper.strNo;
    _lbPaperTitle.text=_paper.strTitle;
    [self addPreTip];
    _viewFinished.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_viewFinished];
    
    _bFirstAppear = YES;
    _ivTemp = [[UIImageView alloc] init];
//    NSLog(@"*********%f",_viewExam.frame.size.height);
}

-(NSInteger)calcLabelHeight:(NSString *)strText
{
    NSInteger nLableHeight = 20;
    
    CGSize size = [strText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(281, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height >20) {
        nLableHeight = size.height;
    }
    else
    {
        nLableHeight = 20;
    }
    
    return nLableHeight;
}

//考前提示
-(void)addPreTip
{
    
    UIWindow *keyWindow=[[UIApplication sharedApplication]keyWindow];
    _viewExamInfoBG.frame=keyWindow.frame;
    [keyWindow addSubview:_viewExamInfoBG];
    _viewExamInfo.layer.cornerRadius=10;
    _btOK.layer.cornerRadius=5;
    _lbExamInfo.text=_paper.strReminder;
    _lbExamInfo.frame=CGRectMake(_lbExamInfo.frame.origin.x, _lbExamInfo.frame.origin.y, _lbExamInfo.frame.size.width, [self calcLabelHeight:_paper.strReminder]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)OnNavBack
{
    if (_bFinishedView)
    {
        [UIView beginAnimations:nil context:nil];
        _viewFinished.frame=CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        _bFinishedView=NO;
    }
    else
    {
        NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
        NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
        NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
        
        RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
            if (indexButton == 1) {
                [self DoNavBack];
            }
        } otherButtonTitles:strOK,nil];
        [alertView show];
    }
    
}

-(void)CacheImg:(NSInteger)nCacheImgIndex
{
    __block RPExamViewController *blockSelf = self;
    if (nCacheImgIndex >= _paper.arrayQuestions.count) {
        return;
    }
    
    RPELQuestion * question = [_paper.arrayQuestions objectAtIndex:nCacheImgIndex];
    if (question.strThumbUrl && question.strThumbUrl.length > 0) {
//        [SVProgressHUD showWithStatus:@""];
        
        [_ivTemp setImageWithURLString:question.strThumbUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [blockSelf CacheImg:(nCacheImgIndex + 1)];
//            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        [self CacheImg:(nCacheImgIndex + 1)];
    }
}

-(void)loadQuestion
{
    [SVProgressHUD showWithStatus:@""];
    
    [[RPSDK defaultInstance]GetQuestionList:_paper.strId Success:^(NSMutableArray *arrayResult) {
         [SVProgressHUD dismiss];
        
        _paper.arrayQuestions=arrayResult;
        
        [self CacheImg:0];
        
        _lbTotalCount.text=[NSString stringWithFormat:@"/%i",_paper.arrayQuestions.count];
        if (_paper.arrayQuestions.count==0)
        {
            _lbCurrentCount.text=@"0";
            _tbOptions.hidden=YES;
        }
        else
        {
            _lbCurrentCount.text=@"1";
            _tbOptions.hidden=NO;
            [_tbOptions reloadData];
            
            if (((RPELQuestion*)[_paper.arrayQuestions objectAtIndex:0]).questionsType==1 ) {
                _lbQuestionType.text=NSLocalizedStringFromTableInBundle(@"1 VALID ANSWER",@"RPString", g_bundleResorce,nil);
                _ivAnswerType.image=[UIImage imageNamed:@"icon_single_check@2x.png"];
                
                
            }
            else
            {
                _lbQuestionType.text=NSLocalizedStringFromTableInBundle(@"MULTIPLE ANSWER",@"RPString", g_bundleResorce,nil);
                _ivAnswerType.image=[UIImage imageNamed:@"icon_multi_check@2x.png"];
            }
            
        }
        
    } Failed:^(NSInteger nErrorCode, NSString *strDesc)
    {
        [SVProgressHUD dismiss];
    }];
}
-(void)setPaper:(RPELPaper *)paper
{
    _paper=paper;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_bFirstAppear) {
        [self setupHorizonTalView];
        [self loadQuestion];
        _bFirstAppear = NO;
    }
    
}
- (void)setupHorizonTalView {
	CGRect frameRect	= CGRectMake(0,0, _viewExam.frame.size.width, _viewExam.frame.size.height);
    
	_tbOptions	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:10 ofWidth:_viewExam.frame.size.width];
	
	_tbOptions.delegate	= self;
	_tbOptions.tableView.backgroundColor=[UIColor clearColor];
    _tbOptions.backgroundColor = [UIColor clearColor];
	_tbOptions.tableView.allowsSelection	= YES;
	_tbOptions.tableView.separatorColor		= [UIColor darkGrayColor];
	_tbOptions.cellBackgroundColor			= [UIColor clearColor];
	_tbOptions.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	_tbOptions.tableView.pagingEnabled = YES;
    
	[_viewExam addSubview:_tbOptions];
//    NSLog(@"*********%f",_viewExam.frame.origin.y);
//    NSLog(@"*********%f",_tbOptions.frame.origin.y);

}

#pragma mark -
#pragma mark Utility Methods

//- (void)borderIsSelected:(BOOL)selected forView:(UIView *)view {
//	UIImageView *borderView		= (UIImageView *)[view viewWithTag:BORDER_VIEW_TAG];
//	NSString *borderImageName	= (selected) ? @"selected_border.png" : @"image_border.png";
//	borderView.image			= [UIImage imageNamed:borderImageName];
//}


#pragma mark -
#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
	RPExamDetailView * view = [[[NSBundle mainBundle] loadNibNamed:@"RPExamDetailView" owner:nil options:nil] objectAtIndex:0];
    view.backgroundColor=[UIColor clearColor];
    view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    view.delegateSelect=self;
    return view;
}

// Second delegate populates the views with data from a data source

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
    RPExamDetailView * detailView=(RPExamDetailView *)view;
    detailView.question=[_paper.arrayQuestions objectAtIndex:indexPath.row];
//    [detailView.question.arrayAnswers removeAllObjects];
}

// Optional delegate to track the selection of a particular cell

- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView {
//	[self borderIsSelected:YES forView:selectedView];
//	
//	if (deselectedView)
//		[self borderIsSelected:NO forView:deselectedView];
//	
//	UILabel *label	= (UILabel *)selectedView;
//	bigLabel.text	= label.text;
}

#pragma mark -
#pragma mark Optional EasyTableView delegate methods for section headers and footers

//#ifdef SHOW_MULTIPLE_SECTIONS

// Delivers the number of sections in the TableView
//- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView{
//    return NUM_OF_SECTIONS;
//}

 //Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section {
    return _paper.arrayQuestions.count;
}
-(void)easyTableView:(EasyTableView *)easyTableView scrolledToOffset:(CGPoint)contentOffset
{
    NSInteger nIndex = (int)(contentOffset.x/304+1);
    if (nIndex == 0)
    {
        nIndex = 1;
    }
    if (nIndex==1)
    {
        _ivLeft.alpha=0.4;
    }
    else if(nIndex>1)
    {
        _ivLeft.alpha=1;
    }
    if (nIndex==_paper.arrayQuestions.count)
    {
        _ivRight.alpha=0.4;
    }
    else if(nIndex<_paper.arrayQuestions.count)
    {
        _ivRight.alpha=1;
    }
    _lbCurrentCount.text=[NSString stringWithFormat:@"%i",nIndex];
    
    if (((RPELQuestion*)[_paper.arrayQuestions objectAtIndex:(int)(contentOffset.x/304)]).questionsType==1 ) {
        _lbQuestionType.text=NSLocalizedStringFromTableInBundle(@"1 VALID ANSWER",@"RPString", g_bundleResorce,nil);
        
        _ivAnswerType.image=[UIImage imageNamed:@"icon_single_check@2x.png"];
    }
    else
    {
        _lbQuestionType.text=NSLocalizedStringFromTableInBundle(@"MULTIPLE ANSWER",@"RPString", g_bundleResorce,nil);
        _ivAnswerType.image=[UIImage imageNamed:@"icon_multi_check@2x.png"];
    }
}
- (IBAction)OnOK:(id)sender
{
    _viewExamInfoBG.hidden=YES;
}

- (IBAction)OnSubmit:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    _viewFinished.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _viewFinished.paper=_paper;
    _viewFinished.delegate=self;
    _bFinishedView=YES;
}

- (IBAction)OnShowTip:(id)sender {
     _viewExamInfoBG.hidden=!_viewExamInfoBG.hidden;
}
-(void)selectQuestion:(NSInteger)nQuestion
{
    [UIView beginAnimations:nil context:nil];
    _viewFinished.frame=CGRectMake(0,self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    _bFinishedView=NO;
    [_tbOptions setContentOffset:CGPointMake(nQuestion*304, 0)];
}
-(IBAction)OnQuit:(id)sender
{
    [self.view endEditing:YES];
    NSString * strDesc = NSLocalizedStringFromTableInBundle(@"Confirm to exit?",@"RPString", g_bundleResorce,nil);
    NSString * strOK = NSLocalizedStringFromTableInBundle(@"OK",@"RPString", g_bundleResorce,nil);
    NSString * strCancel = NSLocalizedStringFromTableInBundle(@"CANCEL",@"RPString", g_bundleResorce,nil);
    
    RPBlockUIAlertView *alertView = [[RPBlockUIAlertView alloc] initWithTitle:nil message:strDesc cancelButtonTitle:strCancel clickButton:^(NSInteger indexButton){
        if (indexButton == 1) {
            [self DoQuit];
        }
    } otherButtonTitles:strOK,nil];
    [alertView show];
    
    
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

-(void)addSubmitPaper:(RPELPaper *)paper
{
    [self.delegateSubmit addPaperTemp:paper];
    [self DoNavBack];
}
-(void)selectOption
{
    _viewCheckColor.backgroundColor=[UIColor colorWithRed:135.0/255 green:150.0/255 blue:85.0/255 alpha:1];
    for (RPELQuestion *question in _paper.arrayQuestions)
    {
        if (question.arrayAnswers.count<1)
        {
            _viewCheckColor.backgroundColor=[UIColor colorWithRed:202.0/255 green:82.0/255 blue:43.0/255 alpha:1];
            return;
        }
    }
}
@end
