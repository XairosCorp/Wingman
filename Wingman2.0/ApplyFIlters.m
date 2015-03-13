//
//  ApplyFIlters.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/21/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "ApplyFIlters.h"

@interface ApplyFIlters ()

@end

@implementation ApplyFIlters

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.normalImageView];
    [self.view bringSubviewToFront:self.mainImageView];
    [self.view bringSubviewToFront:self.marsImageView];
    [self.view bringSubviewToFront:self.bwImageView];
    [self.view bringSubviewToFront:self.tryAgainButton];
    [self.view bringSubviewToFront:self.swagButton];
    [self.view bringSubviewToFront:self.normalButton];
    [self.view bringSubviewToFront:self.marsButton];
    [self.view bringSubviewToFront:self.bwButton];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.mainImageView setImage:picture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  //  NSLog(@"ApplyFiltersLog");
 //   [super touchesBegan:touches withEvent:event];
}

-(void)setUser:(PFObject *)object image:(UIImage *)pictureImage{
    user = object;
    picture = pictureImage;
    filteredPicture = picture;
    [self.mainImageView setImage:picture];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tryAgain"]){
        //TODO: Delete
       /* TakePicture *takePicView = segue.destinationViewController;
        [takePicView setUser:user];*/
    }
    else if ([segue.identifier isEqualToString:@"confirmFilter"]){
        MenuViewController *menuView = segue.destinationViewController;
        [menuView setUser:user];
    }
}


- (IBAction)handleNormal:(id)sender {
    filteredPicture = picture;
    [self.mainImageView setImage:filteredPicture];
}

- (IBAction)handleMars:(id)sender {
    
    // Fix Orientation since CIImage takes raw data
    UIImageOrientation originalOrientation = picture.imageOrientation;
    CGFloat originalScale = picture.scale;
    
    // Create Filter
    CIImage *rawImageData = [[CIImage alloc] initWithImage:picture];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, rawImageData, @"inputIntensity", [NSNumber numberWithFloat:0.7], nil];
    CIImage *filtered = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:filtered fromRect:filtered.extent];
    // Create new image based on filter and original picture orientatoin and scale;
    UIImage *done = [UIImage imageWithCGImage:cgiimage scale:originalScale orientation:originalOrientation];

    [self.mainImageView setImage:done];
    filteredPicture = done;
}

- (IBAction)handleBW:(id)sender {
    
    // Fix Orientation since CIImage takes raw data
    UIImageOrientation originalOrientation = picture.imageOrientation;
    CGFloat originalScale = picture.scale;
    
    // Create Filter
    CIImage *rawImageData = [[CIImage alloc] initWithImage:picture];
    CIImage *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, rawImageData, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, filter, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    
    // Create new image based on filter and original picture orientatoin and scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:originalScale orientation:originalOrientation];
    
    filteredPicture = newImage;
    [self.mainImageView setImage:newImage];
}


- (IBAction)handleTryAgain:(id)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    TakePicture *takePicView = (TakePicture *)self.presentingViewController.presentingViewController;
    [takePicView setUser:user];
}

- (IBAction)handleConfirm:(id)sender {
    picture = filteredPicture;
    NSData *picData = UIImagePNGRepresentation(picture);
    PFFile *picFile = [PFFile fileWithName:@"picture.png" data:picData];
    [user setObject:picFile forKey:@"picture"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            NSLog(@"Save successful");
            [self performSegueWithIdentifier:@"confirmFilter" sender:self];
        }
        else {
            NSLog(@"Error");
        }
    }];
}
@end
