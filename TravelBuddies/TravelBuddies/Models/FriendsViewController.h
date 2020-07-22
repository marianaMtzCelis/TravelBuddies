//
//  FriendsViewController.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 16/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsViewController : UIViewController

@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
