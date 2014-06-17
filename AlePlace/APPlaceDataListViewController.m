//
//  APPlaceDataListViewController.m
//  AlePlace
//
//  Created by Apple on 6/11/14.
//
//

#import "APPlaceDataListViewController.h"

#import "FMUtils.h"
#import "APPlaceTableViewCell.h"
#import "APStadiumTableViewCell.h"
#import "APCallAPI.h"
#import "APStadium.h"
#import "UIImageView+AFNetworking.h"
#import "FMConstants.h"
#import "APDetailPlaceViewController.h"
#import "APShowFullMapViewController.h"
@interface APPlaceDataListViewController ()
{
    NSMutableArray *listStadiums;
    NSInteger page;
    NSMutableDictionary *dictionary;
    APDetailPlaceViewController *detailPlaceViewController;
    APShowFullMapViewController *showFullMapViewController;
}
@end

@implementation APPlaceDataListViewController
@synthesize tableStadium,city_id,catagoryId;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:kAleViewController object:self userInfo:@{kNameView:@"APPlaceDataListTableViewController"}];
    // Do any additional setup after loading the view from its nib.
    [self callAPIGetStadiumData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView) name:kRemoveDataListViewController object:nil];
}
-(void)removeView{
    [self.view removeFromSuperview];
}
-(void)popViewControllerAnimated{
    [self.view removeFromSuperview];
}
-(void)callAPIGetStadiumData{
    dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"json" forKey:@"format"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dictionary setValue:city_id forKey:@"cityId"];

    [dictionary setValue:catagoryId forKey:@"categoryId"];

    [dictionary setValue:@"5d7299e5d3ea2698b9ef43527eae374e1ce439da" forKey:@"esapikey"];
    [APCallAPI getStadiumData:^(NSArray *listEvent, NSObject *error) {
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
    
    static NSString *CellIdentifier = @"APStadiumTableViewCell";
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
    APPlace *place = [listStadiums objectAtIndex:indexPath.row];
    
    cell.fromView=@"PlaceMap";
    cell.countryTitle.text=@"Phone:";
    cell.cityTitle.text=@"Hours:";
    cell.titileStadium.text = place.nameplace;
    [cell.imageStadium setImageWithURL:[NSURL URLWithString: [place.thumb_photoplace stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.imageStadium setContentMode:UIViewContentModeScaleAspectFit];
    cell.country.text = place.phone;
    cell.city.text = place.service_hour;
    cell.add.text = place.address;
    [cell.btMap setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    detailPlaceViewController = [[APDetailPlaceViewController alloc] initWithNibName:@"APDetailPlaceViewController" bundle:nil];
    detailPlaceViewController.place = [listStadiums objectAtIndex:indexPath.row];
    detailPlaceViewController.view.frame = self.view.frame;
    [self.view addSubview:detailPlaceViewController.view];
}

//- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
//    // get the imageView that was tapped
//    UIImageView *imageView = gestureRecognizer.view;
//    imageView.image = [UIImage imageNamed:NSLocalizedString(@"button_continue",@"")];
//    // do something else
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)showMap:(int)tapCell{
    showFullMapViewController = [[APShowFullMapViewController alloc] initWithNibName:@"APShowFullMapViewController" bundle:nil];
    APPlace * place=[listStadiums objectAtIndex:tapCell];
    showFullMapViewController.place = place;
    showFullMapViewController.view.frame = self.view.frame;
    [self.view addSubview:showFullMapViewController.view];
    
}

@end
