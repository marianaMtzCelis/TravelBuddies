//
//  PostCell.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "PostCell.h"
#import <Parse/Parse.h>

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)viewWillAppear {
    [self refreshData];
}

-(void)refreshData {
    
    if (self.post.isLiked) {
        [self.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
    } else {
        [self.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    }
    
    int value = (int)self.post.likesArr.count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
    if (self.post.isSaved) {
           [self.saveButton setImage:[UIImage imageNamed:@"save-pink"] forState:UIControlStateNormal];
       } else {
           [self.saveButton setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
       }
    
}

- (IBAction)onHeart:(id)sender {
    
    NSString *userID = [PFUser currentUser].objectId;
    
    if (!self.post.isLiked) {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr addObject:userID];
        self.post.likesArr = likesArr;
        self.post.isLiked = YES;
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


@end
