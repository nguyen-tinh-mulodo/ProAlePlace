//
//  APStadiumViewController.m
//  AlePlace
//
//  Created by Apple on 6/7/14.
//
//

#import "APStadiumViewController.h"
#import "FMUtils.h"
#import "APPlaceTableViewCell.h"
#import "APStadiumTableViewCell.h"
#import "APCallAPI.h"
#import "APStadium.h"
#import "UIImageView+AFNetworking.h"
#import "FMConstants.h"
#import "APDetailStadiumViewController.h"
#import "APShowFullMapViewController.h"
@interface APStadiumViewController ()
{
    NSMutableArray *listStadiums;
    NSInteger page;
    NSMutableDictionary *dictionary;
    APDetailStadiumViewController *detailStadiumViewController;
     APShowFullMapViewController *showFullMapViewController;
}
@end

@implementation APStadiumViewController
@synthesize tableStadium;
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
    listStadiums = [[NSMutableArray alloc] init];
    page = 1;
    self.navigationItem.leftBarButtonItem = [FMUtils backArrowButtonWithTarget:self action:@selector(popViewControllerAnimated)];
    [[NSNotificationCenter defaultCenter]postNotificationName:kAleViewController object:self userInfo:@{kNameView:@"APStadiumViewController"}];
    // Do any additional setup after loading the view from its nib.
    [self callAPIGetStadium];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView) name:kRemoveStadiumViewController object:nil];
    NSString *title = titleStadium;
    [[NSNotificationCenter defaultCenter]postNotificationName:editTitle object:self userInfo:@{editTitle: title}];
}
-(void)removeView{
    [self.view removeFromSuperview];
}
-(void)popViewControllerAnimated{
    [self.view removeFromSuperview];
}
-(void)callAPIGetStadium{
    dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"json" forKey:@"format"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dictionary setValue:@"5d7299e5d3ea2698b9ef43527eae374e1ce439da" forKey:@"esapikey"];
    [APCallAPI getStadiums:^(NSArray *listEvent, NSObject *error) {
        listStadiums = [NSMutableArray arrayWithArray:listEvent];
        [self.tableStadium reloadData];
    } parameters:dictionary didFail:^(NSObject *error) {
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [listStadiums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"APAleViewCellBt";
    APStadiumTableViewCell *cell = nil;
    cell = (APStadiumTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.tag = indexPath.row;
    if (cell == nil) {
        // cell = [[APEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"APStadiumTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        cell.delegate = self;
        
    }
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    APStadium *stadium = [listStadiums objectAtIndex:indexPath.row];
    cell.titileStadium.text = stadium.nameStadium;
    [cell.imageStadium setImageWithURL:[NSURL URLWithString: [stadium.thumb_photoStadium stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"placeholder"]];
   [cell.imageStadium setContentMode:UIViewContentModeScaleAspectFit];
    cell.country.text = stadium.country;
    cell.city.text = stadium.city;
    cell.add.text = stadium.address;
    [cell.btMap setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    detailStadiumViewController = [[APDetailStadiumViewController alloc] initWithNibName:@"APDetailStadiumViewController" bundle:nil];
    detailStadiumViewController.stadium = [listStadiums objectAtIndex:indexPath.row];
    detailStadiumViewController.view.frame = self.view.frame;
    [self.view addSubview:detailStadiumViewController.view];
}

//- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
//    // get the imageView that was tapped
//    UIImageView *imageView = gestureRecognizer.view;
//    imageView.image = [UIImage imageNamed:NSLocalizedString(@"button_continue",@"")];
//    // do something else
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (void)showMap:(int)tapCell{
    showFullMapViewController = [[APShowFullMapViewController alloc] initWithNibName:@"APShowFullMapViewController" bundle:nil];
    APStadium *_stadium= [listStadiums objectAtIndex:tapCell];
    showFullMapViewController.flgShowStadium = TRUE;
    showFullMapViewController.stadium = _stadium;
    showFullMapViewController.view.frame = self.view.frame;
   
    [self.view addSubview:showFullMapViewController.view];
}
@end
