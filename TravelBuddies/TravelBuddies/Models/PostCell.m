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
    self.buttonsArr = [[NSMutableArray alloc] initWithObjects: @0, @0, nil];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)refreshData {
    
    if (self.isLiked) {
        [self.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
    } else {
        [self.favButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    }
    
    int value = (int)self.post.likesArr.count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
    
}

- (IBAction)onHeart:(id)sender {
    
    NSString *userID = [PFUser currentUser].objectId;
    
    if (!self.isLiked) {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr addObject:userID];
        self.post.likesArr = likesArr;
        self.isLiked = YES;
    } else {
        NSMutableArray *likesArr = self.post.likesArr;
        [likesArr removeObject:userID];
        self.post.likesArr = likesArr;
        self.isLiked = NO;
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
    [self.saveButton setImage:[UIImage imageNamed:@"save-pink"] forState:UIControlStateNormal];
}


@end
