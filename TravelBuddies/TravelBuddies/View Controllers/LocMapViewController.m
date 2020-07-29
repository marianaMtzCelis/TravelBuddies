//
//  LocMapViewController.m
//  TravelBuddies
//
//  Created by Mariana Martinez on 23/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import "LocMapViewController.h"
#import <MapKit/MapKit.h>

@interface LocMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation LocMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: Change to the user's destination region
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake([self.post.lat doubleValue], [self.post.lng doubleValue]), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.lat.floatValue, self.lng.floatValue);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = @"Here!";
    [self.mapView addAnnotation:annotation];
    [self.navigationController popToViewController:self animated:YES];
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
