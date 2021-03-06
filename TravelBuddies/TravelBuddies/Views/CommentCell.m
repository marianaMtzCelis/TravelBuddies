//
//  CommentCell.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 04/08/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ppView.layer.masksToBounds = true;
    self.ppView.layer.cornerRadius = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)viewWillAppear {
}

-(void)refreshData {
    
    if (self.comment.isLiked) {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart.fill"];
        [self.favButton setImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image = [UIImage systemImageNamed:@"suit.heart"];
        [self.favButton setImage:image forState:UIControlStateNormal];
    }
    
    int value = (int)self.comment.likesArr.count;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%i", value];
}

- (IBAction)onDelete:(id)sender {
    
    [self.comment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Comment deleted");
        }
    }];
    
    [self refreshData];
}

- (IBAction)onHeart:(id)sender {
    
    NSString *userId = [PFUser currentUser].objectId;
    
    if (!self.comment.isLiked) {
        NSMutableArray *likesArr = self.comment.likesArr;
        [likesArr addObject:userId];
        self.comment.likesArr = likesArr;
        self.comment.isLiked = YES;
    } else {
        NSMutableArray *likesArr = self.comment.likesArr;
        [likesArr removeObject:userId];
        self.comment.likesArr = likesArr;
        self.comment.isLiked = NO;
    }
    
    [self.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
    
    [self refreshData];
}


@end
