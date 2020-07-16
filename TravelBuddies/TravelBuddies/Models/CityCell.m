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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onHeart:(id)sender {
    [self.favButton setImage:[UIImage imageNamed:@"fav-red"] forState:UIControlStateNormal];
}

- (IBAction)onSave:(id)sender {
    [self.saveButton setImage:[UIImage imageNamed:@"save-pink"] forState:UIControlStateNormal];
}

@end
