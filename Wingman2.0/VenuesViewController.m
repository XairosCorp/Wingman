//
//  VenuesViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "VenuesViewController.h"

@interface VenuesViewController ()

@end

@implementation VenuesViewController{
    CLLocationManager *locationManager;
    CLLocation *myLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.addVenueButton];
    [self.view bringSubviewToFront:self.menuButton];
    [self.view bringSubviewToFront:self.venue1ImageView];
    [self.view bringSubviewToFront:self.venue1NameLabel];
    [self.view bringSubviewToFront:self.venue1Button];
    
    [self.view bringSubviewToFront:self.venue2ImageView];
    [self.view bringSubviewToFront:self.venue2NameLabel];
    [self.view bringSubviewToFront:self.venue2Button];
    
    [self.view bringSubviewToFront:self.venue3ImageView];
    [self.view bringSubviewToFront:self.venue3NameLabel];
    [self.view bringSubviewToFront:self.venue3Button];
    
    [self.venue1NameLabel setText:@""];
    [self.venue2NameLabel setText:@""];
    [self.venue3NameLabel setText:@""];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    myLocation = [[CLLocation alloc] initWithLatitude:32.999243 longitude:-110.954000];
    
    [self loadVenues];
    
    // UI Customizations
    _addVenueButton.layer.cornerRadius = 20;
    
    // Set Nav Customizations
    self.navigationItem.title = @"venues";
    
    // Left BBI
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Close"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleMenuButton:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    // Nav Color
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // Title Font
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"STHeitiSC-Light" size:21],
      NSFontAttributeName, nil]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleAddVenue:(id)sender {
    [self performSegueWithIdentifier:@"addVenueSegue" sender:self];
}

- (IBAction)handleVenue1:(id)sender {
    if (self.venue1NameLabel.text.length != 0){
        _currentVenueNumber = 1;
        [self performSegueWithIdentifier:@"venueSegue" sender:self];
    }
}

- (IBAction)handleVenue2:(id)sender {
    if (self.venue2NameLabel.text.length != 0){
        _currentVenueNumber = 2;
        [self performSegueWithIdentifier:@"venueSegue" sender:self];
    }
}

- (IBAction)handleVenue3:(id)sender {
    if (self.venue3NameLabel.text.length != 0){
        _currentVenueNumber = 3;
        [self performSegueWithIdentifier:@"venueSegue" sender:self];
    }
}

- (IBAction)handleMenuButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    MenuViewController *nextView = (MenuViewController *)self.presentingViewController;
    [nextView setUser:user];
}

- (void)setUser:(PFObject *)object{
    user = object;
    NSLog(@"Venues: %@", [user objectForKey:@"name"]);
}

- (void)loadVenues{
    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    PFGeoPoint *thePoint = [PFGeoPoint geoPointWithLatitude:myLocation.coordinate.latitude  longitude:myLocation.coordinate.longitude];
    [query whereKey:@"location" nearGeoPoint:thePoint withinMiles:0.05];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            int i = 0;
            for (i = 0; i < objects.count; i++){
                if (i == 0){
                    NSLog(@"%@\n", [objects[i] objectForKey:@"name"]);
                    venue1 = objects[i];
                    [self.venue1NameLabel setText:[objects[i] objectForKey:@"name"]];
                    PFFile *picFile = [objects[i] objectForKey:@"picture"];
                    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if(!error){
                            UIImage *pic1 = [UIImage imageWithData:data];
                            [self.venue1ImageView setImage:pic1];
                        }
                    }];
                }
                else if (i == 1){
                    NSLog(@"I is 1, %@", [objects[i] objectForKey:@"name"]);
                    venue2 = objects[i];
                    [self.venue2NameLabel setText:[objects[i] objectForKey:@"name"]];
                    PFFile *picFile = [objects[i] objectForKey:@"picture"];
                    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if(!error){
                            UIImage *pic2 = [UIImage imageWithData:data];
                            [self.venue2ImageView setImage:pic2];
                        }
                    }];
                }
                else if (i == 2){
                    NSLog(@"I is 2, %@", [objects[i] objectForKey:@"name"]);
                    venue3 = objects[i];
                    [self.venue2NameLabel setText:[objects[i] objectForKey:@"name"]];
                    PFFile *picFile = [objects[i] objectForKey:@"picture"];
                    [picFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if(!error){
                            UIImage *pic3 = [UIImage imageWithData:data];
                            [self.venue3ImageView setImage:pic3];
                        }
                    }];
                }
            }
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addVenueSegue"]){
        AddVenueViewController *nextView = segue.destinationViewController;
        [nextView setUser:user];
    }
    else if ([segue.identifier isEqualToString:@"venueSegue"]){
        
        PeopleInVenue *nextView = (PeopleInVenue *)segue.destinationViewController;
        
        if (_currentVenueNumber == 1) {
            [nextView passUser:user aVenue:venue1];
        } else if (_currentVenueNumber == 2) {
            [nextView passUser:user aVenue:venue2];
        } else if (_currentVenueNumber == 3) {
            [nextView passUser:user aVenue:venue3];
        }
    }
    /*else if ([segue.identifier isEqualToString:@"venue1Segue"]){
        PeopleInVenue *nextView = segue.destinationViewController;
        [nextView passUser:user aVenue:venue1];
    }
    else if ([segue.identifier isEqualToString:@"venue2Segue"]){
        PeopleInVenue *nextView = segue.destinationViewController;
        [nextView passUser:user aVenue:venue2];
    }
    else if ([segue.identifier isEqualToString:@"venue3Segue"]){
        PeopleInVenue *nextView = segue.destinationViewController;
        [nextView passUser:user aVenue:venue3];
    }*/
    /* TODO: Delete this
    else if ([segue.identifier isEqualToString:@"backToMenuSegue"]){
        MenuViewController *nextView = segue.destinationViewController;
        [nextView setUser:user];
    }*/
    
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
    
    
    //    myLocation = newLocation;
}



@end
