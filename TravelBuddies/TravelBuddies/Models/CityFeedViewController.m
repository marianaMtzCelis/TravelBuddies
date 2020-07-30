//
//  CityFeedViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 15/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "CityFeedViewController.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"
#import "PostDetailsViewController.h"
#import "CityCell.h"

@interface CityFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *savedPosts;

@end

@implementation CityFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.savedPosts = [[NSMutableArray alloc] init];
    
    [self getTimeline];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self getTimeline];
}

-(void)getTimeline {

    PFUser *curr = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query whereKey:@"objectId" containedIn:curr[@"savedPost"]];


    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];

    
    NSLog(@"%@", self.savedPosts);
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([[segue identifier] isEqualToString:@"cityPostDetailsSegue"]) {
            PostCell *tappedCell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
            Post *post = self.posts[indexPath.row];
            PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
            postDetailsViewController.post = post;
        }
 }
 

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTimelineCell"];
    
    Post *post = self.posts[indexPath.row];
    cell.post = post;
       
    cell.picturePostView.file = nil;
    cell.picturePostView.file = post.image;
    [cell.picturePostView loadInBackground];
    
    cell.usernameLabel.text = post.author.username;
    cell.cityLabel.text = post.city;
    
    int value = (int)cell.post.likesArr.count;
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
    if (cell.post.isLiked) {
       [cell.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
    } else {
        [cell.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    }
    
    if (cell.post.isSaved) {
        [cell.saveButton setImage:[UIImage imageNamed:@"save-pink"] forState:UIControlStateNormal];
    } else {
        [cell.saveButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    }
    
    cell.ppView.file = nil;
    cell.ppView.file = cell.post.author[@"profilePicture"];
    [cell.ppView loadInBackground];
    cell.ppView.layer.masksToBounds = true;
    cell.ppView.layer.cornerRadius = 25;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


@end
