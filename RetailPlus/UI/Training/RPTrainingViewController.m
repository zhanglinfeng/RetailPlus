//
//  RPTrainingViewController.m
//  RetailPlus
//
//  Created by lin dong on 14-3-13.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import "RPTrainingViewController.h"
#import "RPTrainingDocCell.h"
#import "RPTrainingFolderCell.h"
#import "RPWebDocViewController.h"
#import "RPBlockUIAlertView.h"
#import "SVProgressHUD.h"
extern NSBundle * g_bundleResorce;

@interface RPTrainingViewController ()

@end

@implementation RPTrainingViewController

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
    _viewFrame.layer.cornerRadius = 8;
    _btnBack.hidden = YES;
    
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"TRAINING COURSEWARE",@"RPString", g_bundleResorce,nil);
    [self ReloadData];
    [self addHeader];
}

-(void)ReloadData
{
    [SVProgressHUD showWithStatus:@""];
    [[RPSDK defaultInstance] GetTraningFolderDocsSuccess:^(NSMutableArray * array) {
        _bShowFolder = YES;
        _arrayFolders = array;
        _arrayDocs = nil;
        [_tbDocs reloadData];
        [SVProgressHUD dismiss];
    } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
        
    }];
}
-(BOOL)isHave
{
    for (int i=0; i<_arrayFolders.count; i++)
    {
        if ([_folder.strFolderName isEqualToString:[[_arrayFolders objectAtIndex:i]strFolderName] ])
        {
            _folder=[_arrayFolders objectAtIndex:i];
            return YES;
        }
    }
    return NO;
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tbDocs;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [refreshView endRefreshing];
        if (_bShowFolder)
        {
            [self ReloadData];
        }
        else
        {
            [SVProgressHUD showWithStatus:@""];
            [[RPSDK defaultInstance] GetTraningFolderDocsSuccess:^(NSMutableArray * array) {
                _arrayFolders = array;
                if ([self isHave])
                {
                    _bShowFolder = NO;
                    _arrayDocs = _folder.arrayDoc;
                }
                else
                {
                    _bShowFolder = YES;
                    _arrayDocs = nil;
                }
                [_tbDocs reloadData];
                [SVProgressHUD dismiss];
            } Failed:^(NSInteger nErrorCode, NSString *strDesc) {
                
            }];
        }
    };
    _headerDoc = header;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_bShowFolder) {
        TrainingFolder * folder = [_arrayFolders objectAtIndex:indexPath.row];
        _folder=folder;
        _arrayDocs = folder.arrayDoc;
        _bShowFolder = NO;
        _btnBack.hidden = NO;
        [_tbDocs reloadData];
    }
    else
    {
        RPWebDocViewController * vcWeb = [[RPWebDocViewController alloc] initWithNibName:NSStringFromClass([RPWebDocViewController class]) bundle:nil];
        vcWeb.cache = [RPSDK defaultInstance].cacheTraining;
        
        TrainingDoc * doc = (TrainingDoc *)[_arrayDocs objectAtIndex:indexPath.row];
        
        //NSDictionary * dict = [[RPSDK defaultInstance].cacheTraining cachedResponseHeadersForURL:[NSURL URLWithString:doc.strUrl]];
        
        //vcSignUp.delegate = self;
        
        vcWeb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        vcWeb.strUrl = doc.strUrl;
        vcWeb.strTitle = doc.strFileName;
        
        [self.vcFrame presentViewController:vcWeb animated:YES completion:^{
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_bShowFolder)
        return _arrayFolders.count;
    else
        return _arrayDocs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bShowFolder) {
        RPTrainingFolderCell *cell=(RPTrainingFolderCell *)[tableView dequeueReusableCellWithIdentifier:@"RPTrainingFolderCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RPTrainingDocCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        cell.folder = [_arrayFolders objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        RPTrainingDocCell *cell=(RPTrainingDocCell *)[tableView dequeueReusableCellWithIdentifier:@"RPTrainingDocCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RPTrainingDocCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.doc = [_arrayDocs objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (IBAction)OnHelp:(id)sender
{
    [RPGuide ShowGuide:self.view];
}

- (IBAction)OnBackFolder:(id)sender
{
    _btnBack.hidden = YES;
    _bShowFolder = YES;
    [_tbDocs reloadData];
}

-(BOOL)OnBack
{
    if (!_bShowFolder)
    {
        [self OnBackFolder:nil];
        return NO;
    }
    return YES;
}
@end
