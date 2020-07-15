//
//  LoginViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    /*
    [super viewDidLoad];
    self.loginButton.layer.borderWidth = 2.0f;
    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    */
}

- (IBAction)onLogin:(id)sender {
    self.loginButton.layer.backgroundColor = [UIColor blackColor].CGColor;
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
}

- (IBAction)onSignup:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
