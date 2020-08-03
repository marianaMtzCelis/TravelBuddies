//
//  FriendsViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 16/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCollectionViewCell.h"
#import "ProfileCell.h"
#import "PostDetailsViewController.h"
#import <Parse/Parse.h>
#import "PFImageView.h"

@interface FriendsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet PFImageView *ppView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) PFUser *friendUser;
@property (nonatomic, assign) bool isFollowed;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.ppView.layer.masksToBounds = true;
    self.ppView.layer.cornerRadius = 25;
    
    self.friendUser = self.user;
    
    [self getTimeline];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);

    self.usernameLabel.text = self.user.username;
    
    self.ppView.file = nil;
    self.ppView.file = self.user[@"profilePicture"];
    [self.ppView loadInBackground];
    self.ppView.layer.masksToBounds = true;
    self.ppView.layer.cornerRadius = 25;
    
    self.isFollowed = NO;
    
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *followingArr = currUser[@"following"];
    for (id prsn in followingArr) {
        if ([prsn isEqualToString:self.user.objectId]) {
            self.isFollowed = YES;
            [self.followButton setTitle:@"following" forState:UIControlStateNormal];
            [self.followButton setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
    
    if (!self.isFollowed) {
        [self.followButton setTitle:@"follow" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorWithRed:127.5/255.0 green:104.55/255.0 blue:22.95/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

-(void)getTimeline {

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.user];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"friendsPostDetailsSegue"]) {
        ProfileCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
    }
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    FriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCollectionViewCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    cell.post = post;
       
    cell.postPhotoView.file = nil;
    cell.postPhotoView.file = post.image;
    [cell.postPhotoView loadInBackground];

    cell.cityLabel.text = post.city;
    
    return cell;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (IBAction)onFollow:(id)sender {
    
    PFUser *currUser = [PFUser currentUser];
    NSMutableArray *followArr = currUser[@"following"];
    
    if (self.isFollowed == NO) {
        [self.followButton setTitle:@"following" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0] forState:UIControlStateNormal];
        [followArr addObject:self.user.objectId];
        self.isFollowed = YES;
    } else {
        [self.followButton setTitle:@"follow" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorWithRed:127.5/255.0 green:104.55/255.0 blue:22.95/255.0 alpha:1.0] forState:UIControlStateNormal];
        [followArr removeObject:self.user.objectId];
        self.isFollowed = NO;
    }
    
    currUser[@"following"] = followArr;
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Added to following array");
        } else {
            NSLog(@"Failed to save in following array");
        }
    }];

}


@end
