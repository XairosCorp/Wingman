//
//  TakePicture.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "TakePicture.h"
#import "ConfirmPicture.h"

@interface TakePicture ()

@end

@implementation TakePicture

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.cameraButton];
 /*
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not have a camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
*/
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleBack:(id)sender {
}

- (void)setUser:(PFObject *)object{
    user = object;
}

- (IBAction)handleTakePicture:(id)sender {
  
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not have a camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    [self performSegueWithIdentifier:@"confirmPicture" sender:self];
   
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosen = info[UIImagePickerControllerEditedImage];
    thePicture = chosen;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ConfirmPicture *confirmPicView = segue.destinationViewController;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [confirmPicView setUser:user image:[UIImage imageNamed:@"see more blank.jpg"]];
    }
    else {
        [confirmPicView setUser:user image:thePicture];
    }
}

@end
