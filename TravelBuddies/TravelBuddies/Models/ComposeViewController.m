//
//  ComposeViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 14/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "ComposeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Post.h"
#import "PhotoMapViewController.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UITextField *placeTextBox;
@property (weak, nonatomic) IBOutlet UITextField *cityTextBox;
@property (weak, nonatomic) IBOutlet UITextView *recommendationsTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postPictureView;
@property (strong, nonatomic) NSMutableArray *tagsArr;
@property (strong, nonatomic) NSNumber *searchNum;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagsArr = [NSMutableArray new];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onPost:(id)sender {
    
    double lt = [self.latitude doubleValue];
    double ln = [self.longitude doubleValue];
    
    NSNumber *lat = [NSNumber numberWithDouble:lt];
    NSNumber *lng = [NSNumber numberWithDouble:ln];
    
    [Post postUserImage:self.postPictureView.image withCaption:self.recommendationsTextView.text withPlace:self.placeTextBox.text withCity:self.cityTextBox.text withTags:self.tagsArr withLng:lng withLat:lat withSearchNum:self.searchNum withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post Success");
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"Post Fail");
        }
    }];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    //TODO: resize image using resizeImage func
    //TODO: place image on postPictureView
    //self.postPictureView.image = [self resizeImage:editedImage withSize:CGSizeMake(360, 169)];
    self.postPictureView.image = [self resizeImage:editedImage withSize:CGSizeMake(150, 150)];
    //self.postPictureView.image = editedImage;
    
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

- (IBAction)onFood:(id)sender {
    [self.tagsArr addObject:@"Food"];
}

- (IBAction)onMuseums:(id)sender {
    [self.tagsArr addObject:@"Museums"];
}

- (IBAction)onNL:(id)sender {
    [self.tagsArr addObject:@"Night Life"];
}

- (IBAction)onCommerce:(id)sender {
    [self.tagsArr addObject:@"Commerce"];
}

- (IBAction)onEntertainment:(id)sender {
    [self.tagsArr addObject:@"Entertainment"];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onPin:(id)sender {
    [self performSegueWithIdentifier:@"detailsMapSegue" sender:nil];
}

- (void)photoMapViewController:(PhotoMapViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    [self saveValues:latitude longitude:longitude];
    
}

- (void) saveValues:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    self.latitude = latitude;
    self.longitude = longitude;
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailsMapSegue"]) {
            PhotoMapViewController *photoMapViewController = [segue destinationViewController];
            photoMapViewController.delegate = self;
        }
}


@end
