//
//  TimelineViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "TimelineViewController.h"
#import "PostCell.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "PFImageView.h"
#import "PostDetailsViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) int loadedTimes;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    
    self.loadedTimes = 0;
    
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getTimeline];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    self.loadedTimes++;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self getTimeline];
}


-(void)getTimeline {

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)onCompose:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}

- (IBAction)onLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *) self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    NSLog(@"User logged out successfully");
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"feedDetailsSegue"]) {
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
    }
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    cell.post = post;
       
    cell.photoView.file = nil;
    cell.photoView.file = post.image;
    [cell.photoView loadInBackground];
    
    cell.usernameLabel.text = post.author.username;
    cell.cityLabel.text = post.city;
    
    int value = (int)cell.post.likesArr.count;
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
    cell.ppView.file = nil;
    cell.ppView.file = cell.post.author[@"profilePicture"];
    [cell.ppView loadInBackground];
    cell.ppView.layer.masksToBounds = true;
    cell.ppView.layer.cornerRadius = 25;
    
    if (self.loadedTimes == 0) {
        NSMutableArray * arr = cell.post.likesArr;
        for(id user in arr) {
            if([user isEqual:[PFUser currentUser].objectId]) {
                cell.post.isLiked = YES;
                [cell.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
                NSLog(@"Likeada");
                NSLog(@"%@", cell.post.likesArr);
            } else {
                [cell.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
            }
        }
    } else {
        if (cell.post.isLiked) {
          [cell.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
        } else {
          [cell.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
