//
//  SignupViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onSignup:(id)sender {
    
    self.signupButton.layer.backgroundColor = [UIColor blackColor].CGColor;
    
    if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""] || [self.emailTextField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"All Fields Required" message:@"Please enter your email, username, and password" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{ }];
        self.signupButton.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = self.usernameTextField.text;
        newUser.password = self.passwordTextField.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{}];
            } else {
                NSLog(@"User registered successfully");
                newUser[@"savedPost"] = [[NSMutableArray alloc] init];
                newUser[@"following"] = [[NSMutableArray alloc] init];
                [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) { }];
                [self performSegueWithIdentifier:@"signupSuccessSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)onCancel:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
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
