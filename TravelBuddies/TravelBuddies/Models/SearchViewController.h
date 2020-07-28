//
//  SearchViewController.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController

@end

@interface UIColor (ProjectName)

+(UIColor *) selected;
+(UIColor *) unselected;

@end

@implementation UIColor (ProjectName)

+(UIColor *) selected { return [UIColor colorWithRed:127.5/255.0 green:104.55/255.0 blue:22.95/255.0 alpha:1.0]; }
+(UIColor *) unselected { return [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0]; }

@end

NS_ASSUME_NONNULL_END
