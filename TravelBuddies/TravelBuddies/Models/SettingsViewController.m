//
//  SettingsViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 16/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "PFImageView.h"

@interface SettingsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *ppView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    self.usernameLabel.text = self.user.username;
    
    if (self.user[@"profilePicture"] != nil) {
        self.ppView.file = self.user[@"profilePicture"];
        [self.ppView loadInBackground];
    }
}

- (IBAction)onCamera:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)onLibrary:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)onChangePhoto:(id)sender {
    self.user[@"profilePicture"] = [self getPFFileFromImage:self.ppView.image];
    self.user[@"times"] = @1;
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Changed Profile Picture");
            [self performSegueWithIdentifier:@"refreshPPSegue" sender:nil];
        } else {
            NSLog(@"Error changing profile picture");
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.ppView.image = [self resizeImage:editedImage withSize:CGSizeMake(500, 500)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
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
