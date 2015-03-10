//
//  ViewController.m
//  Wingman2.0
//
//  Created by Zane Sheets on 2/20/15.
//  Copyright (c) 2015 Zane Sheets. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.signInButton];
    [self.view bringSubviewToFront:self.learnMoreButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
