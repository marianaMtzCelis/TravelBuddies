//
//  SearchViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "SearchViewController.h"
#import "ProfileCell.h"
#import "CitiesCell.h"
#import <Parse/Parse.h>
#import "PFImageView.h"
#import "Post.h"
#import "PostDetailsViewController.h"
#import "FriendsViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *peoplePlacesControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *filteredPeople;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *filteredCities;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *tags;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *museumButton;
@property (weak, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (weak, nonatomic) IBOutlet UIButton *commerceButton;
@property (weak, nonatomic) IBOutlet UIButton *nightLifeButton;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.tableView.rowHeight = 218;
    
    self.scrollView.alpha = 0;
    
    [self getPeople];
    [self getTimeline];
    
    self.tags = [[NSArray alloc] initWithObjects: @0, @0, @0, @0, @0, nil];
    
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([[segue identifier] isEqualToString:@"cityPostDetailsSegue"]) {
         CitiesCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         Post *post = self.filteredCities[indexPath.row];
         PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
         postDetailsViewController.post = post;
         
     } else if ([[segue identifier] isEqualToString:@"discoverProfileSegue"]) {
         ProfileCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         PFUser *user = self.filteredPeople[indexPath.row];
         FriendsViewController *friendsViewController = [segue destinationViewController];
         friendsViewController.user = user;
     }

 }
 

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.peoplePlacesControl.selectedSegmentIndex == 0) {
        
        self.scrollView.alpha = 0;
        
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
        PFUser *author = self.filteredPeople[indexPath.row];
        cell.user = author;
        
        cell.usernameLabel.text = author.username;
        
        //cell.ppView.file = nil;
        
        cell.ppView.file = cell.user[@"profilePicture"];
        [cell.ppView loadInBackground];
        NSLog(@"profile picture");
        
        cell.ppView.layer.masksToBounds = true;
        cell.ppView.layer.cornerRadius = 35;
        
        return cell;
        
    } else {
        
        self.scrollView.alpha = 1;
        
        CitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitiesCell" forIndexPath:indexPath];
        
        Post *post = self.filteredCities[indexPath.row];
        cell.post = post;
        
        cell.picturePostView.file = nil;
        cell.picturePostView.file = post.image;
        [cell.picturePostView loadInBackground];
        
        cell.usernameLabel.text = post.author.username;
        cell.cityLabel.text = post.city;

        cell.ppView.file = nil;
        cell.ppView.file = cell.post.author[@"profilePicture"];
        [cell.ppView loadInBackground];
        cell.ppView.layer.masksToBounds = true;
        cell.ppView.layer.cornerRadius = 25;
        
        return cell;
        
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.peoplePlacesControl.selectedSegmentIndex == 0) {
        return self.filteredPeople.count;
    } else {
        return self.filteredCities.count;
    }
}

- (IBAction)segmentChanged:(id)sender {
    [self.tableView reloadData];
}

-(void)getPeople {
    
    PFQuery *query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *people, NSError *error) {
        if (people != nil) {
            self.people = (NSMutableArray *)people;
            self.filteredPeople = (NSMutableArray *)people;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)getTimeline {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.cities = (NSMutableArray *)posts;
            self.filteredCities = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (self.peoplePlacesControl.selectedSegmentIndex == 0) {
        
        if (searchText.length != 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PFUser *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject.username containsString:searchText];
            }];
            self.filteredPeople = [self.people filteredArrayUsingPredicate:predicate];
            
            NSLog(@"%@", self.filteredPeople);
            
        }
        else {
            self.filteredPeople = self.people;
        }
        
        [PFFileObject clearAllCachedDataInBackground];
        [self.tableView reloadData];
        
    } else {
        
        if (searchText.length != 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Post *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject.city containsString:searchText];
            }];
            self.filteredCities = [self.cities filteredArrayUsingPredicate:predicate];
            
            NSLog(@"%@", self.filteredCities);
            
        }
        else {
            self.filteredCities = self.cities;
        }
        
        [PFFileObject clearAllCachedDataInBackground];
        [self.tableView reloadData];
        
    }
    
}

- (IBAction)onFood:(id)sender {
}

- (IBAction)onMuseums:(id)sender {
}

- (IBAction)onEntertainment:(id)sender {
}

- (IBAction)onCommerce:(id)sender {
}

- (IBAction)onNightLife:(id)sender {
}

@end
