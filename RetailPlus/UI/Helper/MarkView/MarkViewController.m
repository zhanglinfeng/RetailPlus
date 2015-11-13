
#import <QuartzCore/QuartzCore.h>
#import "MarkViewController.h"
#import "MarkView.h"

@implementation MarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cadImage:(UIImage *)image curentPoint:(CGPoint)ptCurrent isMarked:(BOOL)bMarked
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _image = image;
        _ptCurrent = ptCurrent;
        _bMarked = bMarked;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _markView = [[MarkView alloc] initWithFrame:CGRectMake(0, 0, _viewFrame.frame.size.width, _viewFrame.frame.size.height) image:_image currentPoint:_ptCurrent isMarked:_bMarked];
    _markView.edelegate = self;
    [_viewFrame addSubview:_markView];
}

-(void)viewDidAppear:(BOOL)animated
{
    _markView.frame = CGRectMake(0, 0, _viewFrame.frame.size.width, _viewFrame.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnConfirm:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(Markend:isMarked:)]) {
        [self.delegate Markend:_ptCurrent isMarked:_bMarked];
    }
}

- (void)OnMarkInPoint:(CGPoint)pt isMarked:(BOOL)bMarked{
    _ptCurrent = pt;
    _bMarked = bMarked;
}

@end