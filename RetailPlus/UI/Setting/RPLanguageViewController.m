//
//  RPLanguageViewController.m
//  RetailPlus
//
//  Created by lin dong on 13-11-6.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPLanguageViewController.h"
#import "RPLanguageCell.h"

extern NSBundle * g_bundleResorce;

@interface RPLanguageViewController ()

@end

@implementation RPLanguageViewController

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
    self.strTaskName = NSLocalizedStringFromTableInBundle(@"LANGUAGE SETTING",@"RPString", g_bundleResorce,nil);
    _viewFrame.layer.cornerRadius = 8;
    _tbLanguage.layer.cornerRadius = 6;
    _tbLanguage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tbLanguage.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RPLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPLanguageCell"];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RPLanguageCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    BOOL bSelect = NO;
    if (indexPath.row == self.type) {
        bSelect = YES;
    }
    
    switch (indexPath.row) {
        case 0:
            [cell SetLang:@"Auto" Selected:bSelect];
            break;
        case 1:
            [cell SetLang:@"English" Selected:bSelect];
            break;
        case 2:
            [cell SetLang:@"中文简体" Selected:bSelect];
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != indexPath.row) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.type = indexPath.row;
        [_tbLanguage reloadData];
        
        [self.delegate OnChgLangEnd:self.type];
    }
}
@end
