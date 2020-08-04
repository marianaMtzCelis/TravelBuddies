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

@end
