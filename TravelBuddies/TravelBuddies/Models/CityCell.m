//
//  CityCell.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 16/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ppView.layer.masksToBounds = true;
    self.ppView.layer.cornerRadius = 25;
    self.heartImage.alpha = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)viewWillAppear {
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

@end
