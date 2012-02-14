//
//  ViewController.h
//  SNS
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

@class HomeController;

@interface SendController : UIViewController 
<UITextViewDelegate, 
UIImagePickerControllerDelegate, 
UINavigationControllerDelegate,
CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet UITextView *inputView;
@property (nonatomic, retain) IBOutlet UILabel *characterNum;
@property (nonatomic, retain) UIImage *sendImage;
@property (nonatomic, assign) HomeController *homeController;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIView *imageBgView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


- (IBAction)chooseImageFromLibary:(id)sender;
- (IBAction)takeImageFromCamera:(id)sender;
- (IBAction)sendLocation:(id)sender;

@end
