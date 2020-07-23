//
//  CitiesCell.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 22/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CitiesCell : UITableViewCell
@property (strong, nonatomic) Post *post;

@property (weak, nonatomic) IBOutlet PFImageView *picturePostView;
@property (weak, nonatomic) IBOutlet PFImageView *ppView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@end

NS_ASSUME_NONNULL_END