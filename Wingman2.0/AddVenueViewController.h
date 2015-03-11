//
//  AddVenueViewController.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "VenuesViewController.h"

@interface AddVenueViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    float radius;
    MKCircle *testCircle;
    PFObject *user;
    BOOL saved;
 //   PFObject *newVenue;
    NSString *identifier;
    NSString *venueId;
    PFGeoPoint *venueLocation;
    NSString *userID;
}

@property (strong, nonatomic) IBOutlet UIButton *swagButton;

@property (strong, nonatomic) IBOutlet UIButton *ohSnapButton;

@property (strong, nonatomic) IBOutlet UITextField *venueNameField;

@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;

@property (strong, nonatomic) IBOutlet UIImageView *venueImageView;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UIButton *photoEditButton;

@property (strong, nonatomic) IBOutlet UILabel *feetLabel;

//@property (strong, nonatomic) MKCircle *testCircle;

- (void)locationmanager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (IBAction)handleAddVenue:(id)sender;

- (IBAction)sliderValueChanged:(id)sender;

- (void)setUser:(PFObject *)object;

- (void)addUserToVenue;

- (IBAction)editPicture:(id)sender;

- (IBAction)handleOhSnap:(id)sender;


-(void)addLocationMarker;

-(double)calculateDistanceGPS:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2;

@end
