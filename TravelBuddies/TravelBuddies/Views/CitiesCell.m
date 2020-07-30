//
//  CitiesCell.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 22/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "CitiesCell.h"
#import "TimelineViewController.h"

@implementation CitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)refreshData {
    
    if (self.post.isLiked) {
        [self.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
    } else {
        [self.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    }
    
    int value = (int)self.post.likesArr.count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
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
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"updated post");
        } else {
            NSLog(@"Error updating post");
        }
    }];
    
    [self refreshData];

}

- (IBAction)onSave:(id)sender {
}

@end
