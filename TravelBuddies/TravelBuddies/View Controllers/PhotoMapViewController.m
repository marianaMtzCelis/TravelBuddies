//
//  PhotoMapViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 23/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "PhotoMapViewController.h"
#import <MapKit/MapKit.h>
#import "LocationsViewController.h"

@interface PhotoMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lng;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: Change to the user's destination region
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    self.post.lat = latitude;
    self.post.lng = longitude;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = @"Here!";
    [self.mapView addAnnotation:annotation];
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)onSave:(id)sender {
    //TODO: Send lng and lat to new post
    
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:@"locSegue"]) {
         LocationsViewController *locationsViewController = [segue destinationViewController];
         locationsViewController.delegate = self;
     }
 }
 

@end
