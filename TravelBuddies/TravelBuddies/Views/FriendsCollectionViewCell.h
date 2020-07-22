//
//  FriendsCollectionViewCell.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 22/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *postPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

NS_ASSUME_NONNULL_END
