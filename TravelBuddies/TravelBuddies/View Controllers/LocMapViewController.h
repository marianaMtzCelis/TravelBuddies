//
//  LocMapViewController.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 23/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocMapViewController : UIViewController

@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
