//
//  APMoreViewController.m
//  AlePlace
//
//  Created by Apple on 6/9/14.
//
//

#import "APMoreViewController.h"
#import "FMConstants.h"
#import "FMUtils.h"
@interface APMoreViewController ()
{
    UILabel *titleAB;
    UILabel *titleCT;
    UILabel *titleVote;
}
@end

@implementation APMoreViewController
@synthesize aboud,contact,vote,image,nameApp;
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
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popView) name:kRevovemore object:nil];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [FMUtils backArrowButtonWithTarget:self action:@selector(popViewControllerAnimated)];
    
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 20, 100, 100)];
    [image setImage:[UIImage imageNamed:@"app-icon.png"]];
     [image setContentMode:UIViewContentModeScaleAspectFit];
    nameApp = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(image.frame), self.view.frame.size.width-40, 30)];
    nameApp.textAlignment = NSTextAlignmentCenter;
    nameApp.text = @"AlePlace Free";
    titleAB = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(nameApp.frame), 90, 30)];
    titleAB.text = @"Aboud us:";
    aboud = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleAB.frame)+10,CGRectGetMaxY(nameApp.frame), self.view.frame.size.width, 30)];
    aboud.text = @"http://aleplace.com";
    aboud.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    aboud.delegate = self;
    NSRange range = [aboud.text rangeOfString:@"http://aleplace.com"];
    [aboud addLinkToURL:[NSURL URLWithString:@"http://aleplace.com"] withRange:range];
    [aboud setTextColor:[UIColor greenColor]];
    
    
    titleCT = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleAB.frame), 90, 30)];
    titleCT.text = @"Contact us:";
    
    contact= [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleAB.frame)+10,CGRectGetMaxY(aboud.frame), self.view.frame.size.width, 30)];
     contact.text = @"http://esoluz.com";
    contact.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    contact.delegate = self;
    
    NSRange range1 = [contact.text rangeOfString:@"http://esoluz.com"];
    [contact addLinkToURL:[NSURL URLWithString:@"http://esoluz.com"] withRange:range1];
    [contact setTextColor:[UIColor greenColor]];
    
    
    titleVote = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleCT.frame), 90, 30)];
    titleVote.text = @"Vote us:";
    
    vote= [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleVote.frame)+10,CGRectGetMaxY(contact.frame), self.view.frame.size.width-100, 50)];
    vote.lineHeightMultiple = 2;
    [vote setNumberOfLines:2];
    vote.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    vote.delegate = self;
    vote.text = @"http://play.google.com/store/search?q=esoluz.com";
    NSRange range2 = [contact.text rangeOfString:@"http://play.google.com/store/search?q=esoluz.com"];
    [vote addLinkToURL:[NSURL URLWithString:@"http://play.google.com/store/search?q=esoluz.com"] withRange:range2];
    [vote setTextColor:[UIColor greenColor]];
    [self.view addSubview:image];
    [self.view addSubview:aboud];
    [self.view addSubview:contact];
    [self.view addSubview:vote];
    [self.view addSubview:nameApp];
    [self.view addSubview:titleVote];
    [self.view addSubview:titleCT];
    [self.view addSubview:titleAB];
}
-(void)popViewControllerAnimated{
    
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
