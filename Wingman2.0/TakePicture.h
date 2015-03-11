//
//  TakePicture.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TakePicture : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    PFObject *user;
    UIImage *thePicture;
}

@property (strong, nonatomic) IBOutlet UIButton *cameraButton;

- (void)setUser:(PFObject *)object;

- (IBAction)handleTakePicture:(id)sender;


@end
