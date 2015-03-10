//
//  PeopleInVenueViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "PeopleInVenueViewController.h"

@interface PeopleInVenueViewController ()

@end

@implementation PeopleInVenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.back_button];
    [self.view bringSubviewToFront:self.matchesButton];
    [self.view bringSubviewToFront:self.nameLabel];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleBack:(id)sender {
}

- (void)setUser:(PFObject *)object the_venue:(PFObject *)ven{
    user = object;
    venue = ven;
    [self.nameLabel setText:[venue objectForKey:@"name"]];
    NSLog(@"User's name: %@\nVenue's name: %@\n", [user objectForKey:@"name"], [venue objectForKey:@"name"]);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goBackSegue"]){
        VenuesViewController *nextView = segue.destinationViewController;
        [nextView setUser:user];
    }
    
}


@end
