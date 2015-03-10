//
//  ConfirmPicture.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "ConfirmPicture.h"

@interface ConfirmPicture ()

@end

@implementation ConfirmPicture

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.tryAgainButton];
    [self.view bringSubviewToFront:self.lookingGoodButton];
    [self.view bringSubviewToFront:self.pictureView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(PFObject *)object image:(UIImage *)picture{
    user = object;
    userPicture = picture;
    [self.view bringSubviewToFront:self.pictureView];
    [self.pictureView setImage:picture];
    NSLog(@"\n\n%@", [object objectForKey:@"name"]);
    NSLog(@"\n%@", userPicture);
}

- (IBAction)handleLookingGood:(id)sender {
    NSData *picData = UIImagePNGRepresentation(userPicture);
    PFFile *picFile = [PFFile fileWithName:@"picture.png" data:picData];
    [user setObject:picFile forKey:@"picture"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSLog(@"Save successful");
            [self performSegueWithIdentifier:@"lookingGood" sender:self];
        }
        else {
            NSLog(@"Error");
        }
    }];
    
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ApplyFIlters *filterView = segue.destinationViewController;
    [filterView setUser:user image:userPicture];
    
}


@end
