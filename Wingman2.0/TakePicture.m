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

- (void)viewDidAppear:(BOOL)animated {
    [self initializeCamera];
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
        
        // Move to next view anyways
        [self performSegueWithIdentifier:@"confirmPicture" sender:self];
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        //[self presentViewController:picker animated:YES completion:NULL];
        [self capImage];
        
    }
   
}

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.imageView.bounds;
    [self.imageView.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self imageView];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!frontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (frontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:_stillImageOutput];
    
    [session startRunning];
}

- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (void) processImage:(UIImage *)image {
    
    //process captured image, crop, resize and rotate
    CGRect outputRect = [_imageView.layer.sublayers[0] metadataOutputRectOfInterestForRect:_imageView.bounds];
    CGImageRef takenCGImage = image.CGImage;
    size_t width = CGImageGetWidth(takenCGImage);
    size_t height = CGImageGetHeight(takenCGImage);
    CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
    
    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
    image = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:image.imageOrientation];
    CGImageRelease(cropCGImage);
    
    // Rotate the image right-side up
    UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                scale:image.scale
                                          orientation:UIImageOrientationLeftMirrored];
    
    thePicture = flippedImage;
    
    [self performSegueWithIdentifier:@"confirmPicture" sender:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosen = info[UIImagePickerControllerEditedImage];
    thePicture = chosen;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // TODO: Decide if needed, added to allow camera process to continue
    [self performSegueWithIdentifier:@"confirmPicture" sender:self];
    
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
