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
    
    self.ppView.file = nil;
    self.ppView.file = self.post.author[@"profilePicture"];
    [self.ppView loadInBackground];
    self.ppView.layer.masksToBounds = true;
    self.ppView.layer.cornerRadius = 25;
    
    [self.recommendationsLabel sizeToFit];
    
    //TODO: MAP
}

- (IBAction)onHeart:(id)sender {
    [self.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
}

- (IBAction)onSave:(id)sender {
    [self.saveButton setImage:[UIImage imageNamed:@"save-pink"] forState:UIControlStateNormal];
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
