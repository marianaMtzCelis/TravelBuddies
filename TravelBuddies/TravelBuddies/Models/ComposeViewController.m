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
@property (strong, nonatomic) NSMutableArray *tags;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *museumButton;
@property (weak, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (weak, nonatomic) IBOutlet UIButton *commerceButton;
@property (weak, nonatomic) IBOutlet UIButton *nightLifeButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagsArr = [NSMutableArray new];
    self.tags = [[NSMutableArray alloc] initWithObjects: @0, @0, @0, @0, @0, nil];
    self.searchNum = 0;
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

typedef NS_ENUM(NSUInteger, MyEnum) {
    Food = 0,
    Museum = 1,
    Entertainment = 2,
    Commerce = 3,
    NightLife = 4,
};

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
    self.postPictureView.image = [self resizeImage:editedImage withSize:CGSizeMake(150, 150)];
    
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
    if ([self.tags[0]  isEqual: @0]) {
        [self calculateSearchNumber:Food addOrSubtract:0];
    } else {
        [self calculateSearchNumber:Food addOrSubtract:1];
    }
}

- (IBAction)onMuseums:(id)sender {
    if ([self.tags[1]  isEqual: @0]) {
          [self calculateSearchNumber:Museum addOrSubtract:0];
      } else {
          [self calculateSearchNumber:Museum addOrSubtract:1];
      }
}

- (IBAction)onNL:(id)sender {
    if ([self.tags[4]  isEqual: @0]) {
           [self calculateSearchNumber:NightLife addOrSubtract:0];
       } else {
           [self calculateSearchNumber:NightLife addOrSubtract:1];
       }
}

- (IBAction)onCommerce:(id)sender {
     if ([self.tags[3]  isEqual: @0]) {
           [self calculateSearchNumber:Commerce addOrSubtract:0];
       } else {
           [self calculateSearchNumber:Commerce addOrSubtract:1];
       }
}

- (IBAction)onEntertainment:(id)sender {
     if ([self.tags[2]  isEqual: @0]) {
           [self calculateSearchNumber:Entertainment addOrSubtract:0];
       } else {
           [self calculateSearchNumber:Entertainment addOrSubtract:1];
       }
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

-(void)calculateSearchNumber:(MyEnum)tag addOrSubtract:(int)aOrS {
    int value;
    double power = pow(2,tag);
    value = (aOrS == 0) ? ([self.searchNum intValue] + power) : ([self.searchNum intValue] - power);
    self.searchNum = [NSNumber numberWithInt:value];
    NSLog(@"%@", self.searchNum);
    
    switch (tag) {
            
        case Food:
            if (aOrS == 0) {
                [self.foodButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[0] = @1;
            } else {
                [self.foodButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[0] = @0;
            }
            break;
            
        case Museum:
            if (aOrS == 0) {
                [self.museumButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[1] = @1;
            } else {
                [self.museumButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[1] = @0;
            }
            break;
            
        case Entertainment:
            if (aOrS == 0) {
                [self.entertainmentButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[2] = @1;
            } else {
                [self.entertainmentButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[2] = @0;
            }
            break;
            
        case Commerce:
            if (aOrS == 0) {
                [self.commerceButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[3] = @1;
            } else {
                [self.commerceButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[3] = @0;
            }
            break;
            
        case NightLife:
            if (aOrS == 0) {
                [self.nightLifeButton setTitleColor:[UIColor selected] forState:UIControlStateNormal];
                self.tags[4] = @1;
            } else {
                [self.nightLifeButton setTitleColor:[UIColor unselected] forState:UIControlStateNormal];
                self.tags[4] = @0;
            }
            break;
            
        default:
            break;
    }

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detailsMapSegue"]) {
            PhotoMapViewController *photoMapViewController = [segue destinationViewController];
            photoMapViewController.delegate = self;
        }
}


@end
