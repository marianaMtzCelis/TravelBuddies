//
//  ProfileCell.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 16/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UITableViewCell
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ppView;
@end

NS_ASSUME_NONNULL_END
