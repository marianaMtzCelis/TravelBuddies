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

@interface PostDetailsViewController ()

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

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


@end
