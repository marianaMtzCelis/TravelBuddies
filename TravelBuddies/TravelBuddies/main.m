//
//  main.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 13/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
