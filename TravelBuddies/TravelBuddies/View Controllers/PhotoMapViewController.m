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
#import "ComposeViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PhotoMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *accuracy;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    
    self.location = [[CLLocationManager alloc] init];
    self.location.delegate = self;
    self.location.desiredAccuracy = kCLLocationAccuracyBest;
    self.location.distanceFilter = kCLDistanceFilterNone;
    [self.location startUpdatingLocation];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    [super viewDidLoad];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(nonnull CLLocation *)newLocation fromLocation:(nonnull CLLocation *)oldLocation {
    
    double lt = newLocation.coordinate.latitude;
    double ln = newLocation.coordinate.longitude;
    double ac = newLocation.horizontalAccuracy;
    
    self.latitude = [NSNumber numberWithDouble:lt];
    self.longitude = [NSNumber numberWithDouble:ln];
    self.accuracy = [NSNumber numberWithDouble:ac];
    
    NSLog(@"Latitude");
    NSLog(@"%@", self.latitude);
    NSLog(@"Longitude");
    NSLog(@"%@", self.longitude);
    NSLog(@"Accuracy");
    NSLog(@"%@", self.accuracy);
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    MKCoordinateRegion region;
    region.center = newLocation.coordinate;
    region.span = span;
    [self.mapView setRegion:region animated:false];
    //[self.mapView setShowsUserLocation:YES];
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error obtaining location" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    double lt = [latitude doubleValue];
    double ln = [longitude doubleValue];
    self.lat = [NSNumber numberWithDouble:lt];
    self.lng = [NSNumber numberWithDouble:ln];
    [self.delegate photoMapViewController:self didPickLocationWithLatitude:latitude longitude:longitude];
    [self saveValues:latitude longitude:longitude];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = @"Here!";
    [self.mapView addAnnotation:annotation];
    [self.navigationController popToViewController:self animated:YES];
}

- (void) saveValues:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    self.lat = latitude;
    self.lng = longitude;
}

- (IBAction)onTap:(id)sender {
    [self performSegueWithIdentifier:@"locSegue" sender:nil];
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"locSegue"]) {
        LocationsViewController *locationsViewController = [segue destinationViewController];
        locationsViewController.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"mapComposeSegue"]) {
        ComposeViewController *composeViewController = [segue destinationViewController];
        composeViewController.latitude = self.lat;
        composeViewController.longitude = self.lng;
    }
}

@end
