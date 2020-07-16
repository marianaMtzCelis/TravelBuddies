//
//  ComposeViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "ComposeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraButton.layer.borderWidth = 2.0f;
    self.cameraButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (IBAction)onCancel:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onPost:(id)sender {
    
    // TODO: Send post to Parse
    
    [self dismissViewControllerAnimated:true completion:nil];
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
