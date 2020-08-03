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
#import "MaterialSnackbar.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *following;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getTimeline];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    PFUser *currUser = [PFUser currentUser];
    if ([currUser[@"times"] isEqual:@0]) {
        MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
        message.text = @"Welcome to the Travel Buddies family!";
        [MDCSnackbarManager showMessage:message];
    } else {
        MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
        message.text = @"Welcome back!";
        [MDCSnackbarManager showMessage:message];
    }
    
    int times = [currUser[@"times"] intValue];
    times++;
    currUser[@"times"] = [NSNumber numberWithInt:times];
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self getTimeline];
}


-(void)getTimeline {
    
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *followingArr = currUser[@"following"];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" containedIn:followingArr];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *people, NSError *error) {
        if (people != nil) {
            self.following = (NSMutableArray *)people;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query whereKey:@"author" containedIn:self.following];
    
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

-(void)getPeople {
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *people, NSError *error) {
        if (people != nil) {
            self.people = (NSMutableArray *)people;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)onCompose:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}

- (IBAction)onLogout:(id)sender {
    
    [self getTimeline];
    [self getPeople];
    for (Post *post in self.posts) {
        post.isSaved = NO;
        post.isLiked = NO;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    }
    for (PFUser *person in self.people) {
        person[@"isFollowed"] = @"NO";
        [person saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    }
    
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
    
    PFUser *curr = [PFUser currentUser];
    
    NSMutableArray *lksArr = cell.post.likesArr;
    for (id usr in lksArr) {
        if ([usr isEqual:curr.objectId]) {
            cell.post.isLiked = YES;
            [cell.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
        }
    }
    
    if (cell.post.isLiked) {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart.fill"];
        [cell.favButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart"];
        [cell.favButton setImage:image forState:UIControlStateNormal];
    }
    
    NSMutableArray *pstArr = curr[@"savedPost"];
    NSLog(@"%@", pstArr);
    for (id pst in pstArr) {
        if ([pst isEqualToString:cell.post.objectId]) {
            cell.post.isSaved = YES;
            [cell.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
        }
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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
