//
//  PhotoMapViewController.h
//  TravelBuddies
//
//  Created by Mariana Martinez on 23/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class PhotoMapViewController;

@protocol PhotoMapViewControllerDelegate

- (void)photoMapViewController:(PhotoMapViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end

@interface PhotoMapViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) CLLocationManager *location;
@property (weak, nonatomic) id<PhotoMapViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
