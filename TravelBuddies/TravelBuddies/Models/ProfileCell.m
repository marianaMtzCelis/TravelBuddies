//
//  ProfileCell.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 16/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
