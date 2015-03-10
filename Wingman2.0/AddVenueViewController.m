//
//  AddVenueViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "AddVenueViewController.h"

@interface AddVenueViewController ()

@end

@implementation AddVenueViewController {
    CLLocationManager *locationManager;
    CLLocation *myLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.swagButton];
    [self.view bringSubviewToFront:self.ohSnapButton];
    [self.view bringSubviewToFront:self.venueImageView];
    [self.view bringSubviewToFront:self.venueNameField];
    [self.view bringSubviewToFront:self.radiusSlider];
    [self.view bringSubviewToFront:self.photoEditButton];
    [self.view bringSubviewToFront:self.distanceLabel];
    [self.view bringSubviewToFront:self.mapView];
    [self.view bringSubviewToFront:self.feetLabel];
    
    radius = 25.0 + self.radiusSlider.value*100.0;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", radius];
    saved = NO;
    
    identifier = @"7ANcBJ77NF";
  /*
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
 */
//    myLocation = [[CLLocation alloc] initWithLatitude:32.999243 longitude:-110.954000];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationmanager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"GPS Failure" message:@"Failed to get your location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //  NSLog(@"didUpateToLocation: %@", newLocation);
     NSLog(@"%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    
    myLocation = newLocation;
    [locationManager stopUpdatingLocation];

    //    [self addLocationMarker];
}

- (IBAction)handleAddVenue:(id)sender {

    if (self.venueNameField.text.length > 0 && self.venueImageView.image != nil){
        PFGeoPoint *thePoint = [PFGeoPoint geoPointWithLatitude:myLocation.coordinate.latitude  longitude:myLocation.coordinate.longitude];
        PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
        [query whereKey:@"location" nearGeoPoint:thePoint withinMiles:0.25];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                NSLog(@"Number of objects found: %lu", (unsigned long)objects.count);
                int i = 0;
                BOOL canVenueBeCreated = YES;
                for (i = 0; i < objects.count; i++){
                    NSString *name = [objects[i] objectForKey:@"name"];
                    NSNumber *objectRadius = [objects[i] objectForKey:@"radius"];
                    PFGeoPoint *otherVenuePoint = [objects[i] objectForKey:@"location"];
                    NSLog(@"Object: %@, with radius %@\n", name, objectRadius);
                    double dist = [self calculateDistanceGPS:myLocation.coordinate.latitude lon1:myLocation.coordinate.longitude lat2:otherVenuePoint.latitude lon2:otherVenuePoint.longitude];
 
                    if (dist < (radius + [objectRadius floatValue]) || isnan(dist)){
                        canVenueBeCreated = NO;
                    }
                    NSLog(@"The distance is: %f feet", dist);
                }
                if (canVenueBeCreated){
                    NSLog(@"\n\n\nThe venue can be created\n\n\n");
                    PFObject *newVenue = [PFObject objectWithClassName:@"Venue"];
                    PFGeoPoint *locationPoint = [PFGeoPoint geoPointWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude];
                    [newVenue setObject:locationPoint forKey:@"location"];
                    [newVenue setObject:self.venueNameField.text forKey:@"name"];
                    [newVenue setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
                    NSData *picData = UIImageJPEGRepresentation(self.venueImageView.image, 1.0);
                    PFFile *picFile = [PFFile fileWithName:@"picture.jpg" data:picData];
                    [newVenue setObject:picFile forKey:@"picture"];
                    
    /*                PFRelation *relation = [newVenue relationForKey:@"members"];
                    PFQuery *query = [PFQuery queryWithClassName:@"User"];
                    [query whereKey:@"name" equalTo:[user objectForKey:@"name"]];
                    NSLog(@"\n\n %@ \n", [user objectForKey:@"name"]);
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (!error){
                            
                            [object save];
                            [relation addObject:object];
                         //   [newVenue saveInBackground];
                        }
                    }];
     
     
     */             NSLog(@"\n\n\nemail: %@\n\n", [user objectForKey:@"email"]);
                    venueLocation = locationPoint;
                    [newVenue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(!error){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your venue has been created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert show];
                            [self.venueNameField setText:@""];
                      //      venueId = [newVenue objectForKey:@"objectId"];
                            [self addUserToVenue];
                            
                            
         
         /*                   PFRelation *relation = [newVenue relationForKey:@"members"];
                            PFObject *temp = [PFObject objectWithClassName:@"User"];
                            [temp setObject:@"Zane" forKey:@"name"];
                            [temp save];
                            [relation addObject:temp];
        
                            [newVenue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if(!error){
                                    NSLog(@"Saved");
                                }
                                else {
                                    NSLog(@"%@", error);
                                }
                            }];
          */
                        }
                        else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your venue could not be created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }];
                    
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create venue, conflict with nearby venue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }];
    }
    else if (self.venueImageView.image == nil && self.venueNameField.text.length > 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please supply a venue photo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (self.venueNameField.text.length == 0 && self.venueImageView.image != nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please name the venue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please name the venue and choose a photo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (IBAction)sliderValueChanged:(id)sender {
    NSLog(@"Slider value changed: %f, x50: %f\n", self.radiusSlider.value, self.radiusSlider.value*100.0);
    radius = 25.0 + self.radiusSlider.value*100.0;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", self.radiusSlider.value*100.0 + 25.0];
}

- (void)setUser:(PFObject *)object{
    user = object;
    NSLog(@"AddVenue: %@", [user objectForKey:@"name"]);
}

- (void)addUserToVenue{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"email" equalTo:[user objectForKey:@"email"]];
//    NSLog(@"\n\n\n%@\n\n\n", userID);
    PFObject *me = [query getFirstObject];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Venue"];
    [query2 whereKey:@"location" equalTo:venueLocation];
    PFObject *venue = [query2 getFirstObject];
    PFRelation *relation = [venue relationForKey:@"members"];
    [me save];
    [relation addObject:me];
    [venue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSLog(@"Saved");
            [self performSegueWithIdentifier:@"backToVenueListSegue" sender:self];
        }
        else {
            NSLog(@"Error");
        }
    }];
}

- (IBAction)editPicture:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not have a camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
        [self.venueImageView setImage:[UIImage imageNamed:@"done button.jpg"]];
        
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)handleOhSnap:(id)sender {
    [self performSegueWithIdentifier:@"backToVenueListSegue" sender:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosen = info[UIImagePickerControllerEditedImage];
    self.venueImageView.image = chosen;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)addLocationMarker{
   /*
    id userAnnotation = self.mapView.userLocation;
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations removeObject:userAnnotation];
    [self.mapView removeAnnotations:annotations];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    [self.mapView addAnnotation:point];
    */
    self.mapView.showsUserLocation = YES;
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(32.224585, -110.954028);
    [self.mapView addAnnotation:point];
    
    MKMapPoint annotationPoint = MKMapPointForCoordinate(point.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.2, 0.2);
    [self.mapView setVisibleMapRect:pointRect animated:YES];
    
    
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:point.coordinate radius:radius*0.3048];
    testCircle = circle;
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:testCircle];
}

-(MKCircleRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}

-(double)calculateDistanceGPS:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2 {
    
    double a = 6378137.0;
    double b = 6356752.314245;
    double f = 1 / 298.257223563;
    double L = (lon2 -lon1)*M_PI/180.0;
    double U1 = atan(1-f)*tan(lat1*M_PI/180.0);
    double U2 = atan(1-f)*tan(lat2*M_PI/180.0);
    
    double sinU1 = sin(U1);
    double cosU1 = cos(U1);
    double sinU2 = sin(U2);
    double cosU2 = cos(U2);
    
    double lambda = L;
    double lambdaP = 100;
    int iterLimit = 100;
    double sinLambda = 0, cosLambda = 0, sinSigma = 0, cosSigma = 0;
    double sigma = 0, sinAlpha = 0, cosSqAlpha = 0, cos2SigmaM = 0;
    double C = 0;
    
    while (abs(lambda - lambdaP) > 1e-12 && iterLimit > 0){
        sinLambda = sin(lambda);
        cosLambda = cos(lambda);
        sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
        if (sinSigma == 0){
            NSLog(@"Coincident points");
        }
        cosSigma = sinU1*sinU2 + cosU1*cosU2*cosLambda;
        sigma = atan2(sinSigma, cosSigma);
        sinAlpha = cosU1*cosU2*sinLambda/sinSigma;
        cosSqAlpha = 1 - sinAlpha*sinAlpha;
        cos2SigmaM = cosSigma - 2*sinU1*sinU2/cosSqAlpha;
        
        if (cos2SigmaM == NAN){
            cos2SigmaM = 0;
        }
        C = f/16*cosSqAlpha*(4+f*(4-3*cosSqAlpha));
        lambdaP = lambda;
        lambda = L + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
        
        
        iterLimit--;
 //       NSLog(@"iterLimit: %d", iterLimit);
    }
    if (iterLimit == 0){
        NSLog(@"Failed to find distance");
    }
    double uSq = cosSqAlpha*(a*a-b*b)/(b*b);
    double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
    double s = b * A * (sigma - deltaSigma);
    
//    NSLog(@"Distance in meters: %f", s);
    double s_feet = s * 3.28084;
    if (isnan(s_feet)){
        NSLog(@"\n\nNaN\n\n");
    }
//    NSLog(@"\n\nDistance in feet: %f\n\n", s_feet);
    return s_feet;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backToVenueListSegue"]){
        VenuesViewController *newView = segue.destinationViewController;
        [newView setUser:user];
    }
}


@end
