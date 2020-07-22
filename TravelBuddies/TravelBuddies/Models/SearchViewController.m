//
//  SearchViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "SearchViewController.h"
#import "ProfileCell.h"
#import "CityCell.h"
#import <Parse/Parse.h>
#import "PFImageView.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *peoplePlacesControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *filteredPeople;
@property (nonatomic, strong) NSMutableArray *cities;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self getPeople];
    [self getTimeline];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.peoplePlacesControl.selectedSegmentIndex == 0) {
        
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
        PFUser *author = self.filteredPeople[indexPath.row];
        cell.user = author;
        
        cell.usernameLabel.text = author.username;
        
        /*
        cell.ppView.file = nil;
        cell.ppView.file = author[@"profilePicture"];
        [cell.ppView loadInBackground];
        cell.ppView.layer.masksToBounds = true;
        cell.ppView.layer.cornerRadius = 35;
        */
        return cell;
        
    } else {
        
        CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitiesCell" forIndexPath:indexPath];
        
        Post *post = self.cities[indexPath.row];
        
        cell.cityLabel.text = post.city;
        
        return cell;
        
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.peoplePlacesControl.selectedSegmentIndex == 0) {
        return self.filteredPeople.count;
    } else {
        return self.cities.count;
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

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.cities = (NSMutableArray *)posts;
            
            /*
            for (Post *post in self.cities) {
                NSString *city = post.city;
                NSLog(@"%@", city);
            }
             */
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
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
    
    [self.tableView reloadData];
 
}


@end
