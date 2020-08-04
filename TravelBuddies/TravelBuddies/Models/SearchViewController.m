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
@property (strong, nonatomic) NSMutableArray *tags;
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
    
    self.scrollView.alpha = 0;
    
    [self getPeople];
    [self getTimeline];
    
    self.tags = [[NSMutableArray alloc] initWithObjects: @0, @0, @0, @0, @0, nil];
    self.searchNum = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self getTimeline];
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
        self.tableView.rowHeight = 94;
        
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
        PFUser *author = self.filteredPeople[indexPath.row];
        cell.user = author;
        
        cell.usernameLabel.text = author.username;
        
        cell.ppView.file = cell.user[@"profilePicture"];
        [cell.ppView loadInBackground];
        
        cell.ppView.layer.masksToBounds = true;
        cell.ppView.layer.cornerRadius = 25;
        
        cell.isFollowed = NO;
        
        PFUser *currUser = [PFUser currentUser];
        NSMutableArray *followingArr = currUser[@"following"];
        for (id prsn in followingArr) {
            if ([prsn isEqualToString:cell.user.objectId]) {
                cell.isFollowed = YES;
                [cell.followButton setTitle:@"following" forState:UIControlStateNormal];
                [cell.followButton setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
        
        if (!cell.isFollowed) {
            [cell.followButton setTitle:@"follow" forState:UIControlStateNormal];
            [cell.followButton setTitleColor:[UIColor colorWithRed:127.5/255.0 green:104.55/255.0 blue:22.95/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        
        return cell;
        
    } else {
        
        self.scrollView.alpha = 1;
        self.tableView.rowHeight = 294;
        
        CitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitiesCell" forIndexPath:indexPath];
        
        Post *post = self.filteredCities[indexPath.row];
        cell.post = post;
        
        cell.picturePostView.file = nil;
        cell.picturePostView.file = post.image;
        [cell.picturePostView loadInBackground];
        
        cell.usernameLabel.text = post.author.username;
        cell.cityLabel.text = post.city;
        cell.heartImage.alpha = 0;
        
        int value = (int)cell.post.likesArr.count;
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
        
        cell.ppView.file = nil;
        cell.ppView.file = cell.post.author[@"profilePicture"];
        [cell.ppView loadInBackground];
        cell.ppView.layer.masksToBounds = true;
        cell.ppView.layer.cornerRadius = 25;
        
        if (cell.post.isLiked) {
            UIImage *image = [UIImage systemImageNamed:@"suit.heart.fill"];
            [cell.favButton setImage:image forState:UIControlStateNormal];
        } else {
            UIImage *image = [UIImage systemImageNamed:@"suit.heart"];
            [cell.favButton setImage:image forState:UIControlStateNormal];
        }
        
        if (cell.post.isSaved) {
            UIImage *image = [UIImage systemImageNamed:@"pin.fill"];
            [cell.saveButton setImage:image forState:UIControlStateNormal];
        } else {
            UIImage *image = [UIImage systemImageNamed:@"pin"];
            [cell.saveButton setImage:image forState:UIControlStateNormal];
        }
        
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

-(void)getTimelineTags {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query whereKey:@"searchNum" equalTo:self.searchNum];
    
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
    
    if ([self.tags[0]  isEqual: @0]) {
        [self calculateSearchNumber:Food addOrSubtract:0];
    } else {
        [self calculateSearchNumber:Food addOrSubtract:1];
    }
    
}

- (IBAction)onMuseums:(id)sender {
    
    if ([self.tags[1]  isEqual: @0]) {
        [self calculateSearchNumber:Museum addOrSubtract:0];
    } else {
        [self calculateSearchNumber:Museum addOrSubtract:1];
    }
}

- (IBAction)onEntertainment:(id)sender {
    
    if ([self.tags[2]  isEqual: @0]) {
        [self calculateSearchNumber:Entertainment addOrSubtract:0];
    } else {
        [self calculateSearchNumber:Entertainment addOrSubtract:1];
    }
}

- (IBAction)onCommerce:(id)sender {
    
    if ([self.tags[3]  isEqual: @0]) {
        [self calculateSearchNumber:Commerce addOrSubtract:0];
    } else {
        [self calculateSearchNumber:Commerce addOrSubtract:1];
    }
}

- (IBAction)onNightLife:(id)sender {
    
    if ([self.tags[4]  isEqual: @0]) {
        [self calculateSearchNumber:NightLife addOrSubtract:0];
    } else {
        [self calculateSearchNumber:NightLife addOrSubtract:1];
    }
}

-(void)calculateSearchNumber:(MyEnum)tag addOrSubtract:(int)aOrS {
    int value;
    double power = pow(2,tag);
    value = (aOrS == 0) ? ([self.searchNum intValue] + power) : ([self.searchNum intValue] - power);
    self.searchNum = [NSNumber numberWithInt:value];
    NSLog(@"%@", self.searchNum);
    
    switch (tag) {
            
        case Food:
            if (aOrS == 0) {
                [self.foodButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[0] = @1;
            } else {
                [self.foodButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[0] = @0;
            }
            break;
            
        case Museum:
            if (aOrS == 0) {
                [self.museumButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[1] = @1;
            } else {
                [self.museumButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[1] = @0;
            }
            break;
            
        case Entertainment:
            if (aOrS == 0) {
                [self.entertainmentButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[2] = @1;
            } else {
                [self.entertainmentButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[2] = @0;
            }
            break;
            
        case Commerce:
            if (aOrS == 0) {
                [self.commerceButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[3] = @1;
            } else {
                [self.commerceButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[3] = @0;
            }
            break;
            
        case NightLife:
            if (aOrS == 0) {
                [self.nightLifeButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[4] = @1;
            } else {
                [self.nightLifeButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[4] = @0;
            }
            break;
            
        default:
            break;
    }
    
    if ([self.searchNum  isEqual: @0]) {
        [self getTimeline];
    } else {
        [self getTimelineTags];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    self.filteredCities = self.cities;
    self.filteredPeople = self.people;
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

@end
