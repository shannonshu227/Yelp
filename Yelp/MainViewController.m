//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "SVPullToRefresh.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"b3qQrz6ZIlI6R4MefIsahw";
NSString * const kYelpConsumerSecret = @"PfifemOlbWEytvyBdJfxiXckWkc";
NSString * const kYelpToken = @"uoHHYF3S9dCf4ATVHLEcCXhnV41Nrvgc";
NSString * const kYelpTokenSecret = @"VH5OBKvsPIUK49xcTj20kPCbj0Q";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSMutableArray *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *dropdownSelectedIndexPath;

-(IBAction)filterView: (id) sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        /*
         [self.client searchWithTerm:@"Thai" atOffset:@"0" success:^(AFHTTPRequestOperation *operation, id response) {
         NSLog(@"response: %@", response);
         NSArray *businessesDictionaries = response[@"businesses"];
         self.businesses = [Business businessesWithDictionaries:businessesDictionaries];
         [self.tableView reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error: %@", [error description]);
         }];
         */
        
        //allocate space for properties..!!!
        self.filters = [NSDictionary dictionary];
        self.selectedIndexPath = [NSMutableArray array];
        self.dropdownSelectedIndexPath = [NSMutableArray array];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCellID"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //    self.title = @"Yelp";
    //    UISearchBar *searchBar = [UISearchBar new];
    //    searchBar.showsCancelButton = YES;
    //    [searchBar sizeToFit];
    //    UIView *barWrapper = [[UIView alloc]initWithFrame:searchBar.bounds];
    //    [barWrapper addSubview:searchBar];
    //    self.navigationItem.titleView = barWrapper;
    self.searchBar = [UISearchBar new];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self insertRowAtBottom];
    }];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Filter"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(filterView:)];
    self.navigationItem.leftBarButtonItem = filterButton;
    //[filterButton release];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView triggerPullToRefresh];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCellID"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    
    [self.client searchWithTerm:searchBar.text atOffset:@"0" withParams:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessesDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaries:businessesDictionaries];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
}

- (void)insertRowAtBottom {
    
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSString *offset =[NSString stringWithFormat:@"%lu", (unsigned long)self.businesses.count];
        [self.client searchWithTerm:self.searchBar.text atOffset:offset withParams:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
            
            NSLog(@"response: %@", response);
            NSArray *businessesDictionaries = response[@"businesses"];
            NSArray *newbusinesses = [Business businessesWithDictionaries:businessesDictionaries];
            NSMutableArray *allbusinesses = [NSMutableArray arrayWithArray:self.businesses];
            [allbusinesses addObjectsFromArray:newbusinesses];
            self.businesses = allbusinesses;
            NSLog(@"%lu", self.businesses.count);
            
            [self.tableView reloadData];
            
            //set the scroll index so that the new data will show on top of screen
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(self.businesses.count-10) inSection:0];
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
        
        
        [self.tableView.infiniteScrollingView stopAnimating];
    });
}

-(IBAction)filterView: (id) sender {
    FilterViewController *vc = [[FilterViewController alloc] initWithFilters:self.filters withSelectedIndexPath:self.selectedIndexPath withDropdownSelectedIndexPath: self.dropdownSelectedIndexPath];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void) filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters atIndexPath:(NSMutableArray *)selectedIndexPath withDropdownSelected:(NSMutableArray *)dropdownSelectedIndexPath {
    NSLog(@"filter change...");
    self.filters = filters;
    self.selectedIndexPath = selectedIndexPath;
    self.dropdownSelectedIndexPath = dropdownSelectedIndexPath;
    NSLog(@"dropdown:%lu", (unsigned long)self.dropdownSelectedIndexPath.count);
    
}

@end
