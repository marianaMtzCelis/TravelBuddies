//
//  AppDelegate.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 13/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"travel-buddies-mmc";
        configuration.server = @"https://travel-buddies-mmc.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    NSMutableArray *arr = @[@"holi", @"holi2", @"holi3"];
    
    double lt = 37.77598956961178;
    double ln = -122.4197465761723;
    
    NSNumber *lat = [NSNumber numberWithDouble:lt];
    NSNumber *lng = [NSNumber numberWithDouble:ln];
    
    [Post postUserImage:nil withCaption:@"test" withPlace:@"place" withCity:@"city" withTags:arr withLng:lng withLat:lat withSearchNum:@101 withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post success");
        } else {
            NSLog(@"Post fail");
        }
    }];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
