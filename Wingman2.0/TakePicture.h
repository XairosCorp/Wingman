//
//  TakePicture.h
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface TakePicture : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{
    PFObject *user;
    UIImage *thePicture;
}

@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIView *imageView;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

- (void)setUser:(PFObject *)object;

- (IBAction)handleTakePicture:(id)sender;

@end
