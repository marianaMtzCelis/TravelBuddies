//
//  PostDetailsViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "PostDetailsViewController.h"
#import <Parse/Parse.h>
#import "PFImageView.h"
#import "DateTools.h"
#import "NSDate+TimeAgo.h"
#import "LocMapViewController.h"
#import "CommentCell.h"
#import "Comment.h"

@interface PostDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet PFImageView *ppView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) NSMutableArray *lastComment;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCommentArray];
    
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCommentArray) forControlEvents:UIControlEventValueChanged];
    [self.commentTableView addSubview:self.refreshControl];
    
    self.photoView.file = nil;
    self.photoView.file = self.post.image;
    [self.photoView loadInBackground];
    
    self.usernameLabel.text = self.post.author.username;
    self.cityLabel.text = self.post.city;
    self.placeLabel.text = self.post.place;
    self.recommendationsLabel.text = self.post.caption;
    
    NSDate *createdAt = [self.post createdAt];
    NSString *ago = [createdAt timeAgo];
    NSString *createdAtString = ago;
    self.dateLabel.text = createdAtString;
    
    if (self.post.isLiked) {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart.fill"];
        [self.favButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart"];
        [self.favButton setImage:image forState:UIControlStateNormal];
    }
    
    if (self.post.isSaved) {
        UIImage *image = [UIImage systemImageNamed:@"pin.fill"];
        [self.saveButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"pin"];
        [self.saveButton setImage:image forState:UIControlStateNormal];
    }
    
    int value = (int)self.post.likesArr.count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
    self.ppView.file = nil;
    self.ppView.file = self.post.author[@"profilePicture"];
    [self.ppView loadInBackground];
    self.ppView.layer.masksToBounds = true;
    self.ppView.layer.cornerRadius = 25;
    
    self.heartImage.alpha = 0;
    
    [self.recommendationsLabel sizeToFit];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponder:)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
}

-(void)tapResponder: (UIGestureRecognizer *)sender {
    NSString *userID = [PFUser currentUser].objectId;
    
    if (!self.post.isLiked) {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr addObject:userID];
        self.post.likesArr = likesArr;
        self.post.isLiked = YES;
        [UIView animateWithDuration:0 animations:^{
            self.heartImage.alpha = 1;
        }];
        [UIView animateWithDuration:1 animations:^{
            self.heartImage.alpha = 0;
        }];
    } else {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr removeObject:userID];
        self.post.likesArr = likesArr;
        self.post.isLiked = NO;
    }
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    
    [self refreshData];
}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshData];
}

-(void)refreshData {
    
    if (self.post.isLiked) {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart.fill"];
        [self.favButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart"];
        [self.favButton setImage:image forState:UIControlStateNormal];
    }
    
    int value = (int)self.post.likesArr.count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
    if (self.post.isSaved) {
        UIImage *image = [UIImage systemImageNamed:@"pin.fill"];
        [self.saveButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"pin"];
        [self.saveButton setImage:image forState:UIControlStateNormal];
    }
    
}

- (IBAction)onHeart:(id)sender {
    
    NSString *userID = [PFUser currentUser].objectId;
    
    if (!self.post.isLiked) {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr addObject:userID];
        self.post.likesArr = likesArr;
        self.post.isLiked = YES;
        self.heartImage.image = [UIImage systemImageNamed:@"suit.heart.fill"];
        [UIView animateWithDuration:0 animations:^{
            self.heartImage.alpha = 1;
        }];
        [UIView animateWithDuration:1 animations:^{
            self.heartImage.alpha = 0;
        }];
    } else {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr removeObject:userID];
        self.post.likesArr = likesArr;
        self.post.isLiked = NO;
    }
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    
    [self refreshData];
}

- (IBAction)onSave:(id)sender {
    
    PFUser *curr = [PFUser currentUser];
    
    if (!self.post.isSaved) {
        NSMutableArray *savedArr = curr[@"savedPost"];
        [savedArr addObject:self.post.objectId];
        curr[@"savedPost"] = savedArr;
        self.post.isSaved = YES;
        NSLog(@"Post saveado");
        self.heartImage.image = [UIImage systemImageNamed:@"pin.fill"];
        [UIView animateWithDuration:0 animations:^{
            self.heartImage.alpha = 1;
        }];
        [UIView animateWithDuration:1 animations:^{
            self.heartImage.alpha = 0;
        }];
    } else {
        NSMutableArray *savedArray = curr[@"savedPost"];
        [savedArray removeObject:self.post.objectId];
        curr[@"savedPost"] = savedArray;
        self.post.isSaved = NO;
        NSLog(@"Post unsaveado");
    }
    
    [curr saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"updated saved array");
        } else {
            NSLog(@"Error updating saved array");
        }
    }];
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    
    [self refreshData];
}

- (IBAction)onPin:(id)sender {
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"mapLocSegue"]) {
        LocMapViewController *locMapViewController = [segue destinationViewController];
        locMapViewController.lat = self.post.lat;
        locMapViewController.lng = self.post.lng;
        locMapViewController.post = self.post;
    }
    
}

-(void)getCommentArray {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query whereKey:@"post" equalTo:self.post];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            self.comments = (NSMutableArray *)comments;
            [self.commentTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    Comment *comment = self.comments[indexPath.row];
    cell.deleteButton.alpha = 0;
    cell.comment = comment;
    
    cell.ppView.file = nil;
    cell.ppView.file = cell.comment.author[@"profilePicture"];
    [cell.ppView loadInBackground];
    cell.ppView.layer.masksToBounds = true;
    cell.ppView.layer.cornerRadius = 20;
    
    cell.usernameLabel.text = cell.comment.author.username;
    cell.commentLabel.text = cell.comment.comment;
    
    int value = (int)cell.comment.likesArr.count;
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
    cell.comment.isLiked = NO;
    
    PFUser *curr = [PFUser currentUser];
    NSMutableArray *lksArr = cell.comment.likesArr;
    for (id usr in lksArr) {
        if ([usr isEqual:curr.objectId]) {
            cell.comment.isLiked = YES;
        }
    }
    
    [cell.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    
    if (cell.comment.isLiked) {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart.fill"];
        [cell.favButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart"];
        [cell.favButton setImage:image forState:UIControlStateNormal];
    }
    
    if ([cell.comment.author.objectId isEqual:curr.objectId] || [self.post.author.objectId isEqual:curr.objectId]) {
        cell.deleteButton.alpha = 1;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (IBAction)onAddComment:(id)sender {
    
    [Comment postComment:self.commentTextField.text toPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Comment success");
            self.commentTextField.text = @"";
        } else {
            NSLog(@"Failed to add comment");
        }
    }];
    
    [self getCommentArray];
    [self.commentTableView reloadData];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}


@end
