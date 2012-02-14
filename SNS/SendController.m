//
//  ViewController.m
//  SNS
//
//  Created by  on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SendController.h"
#import "SettingController.h"
#import "CoreDataManager.h"
#import "Msg.h"
#import "HomeController.h"
#import "TKAlertCenter.h"

@interface SendController (Private)

- (void)createImageView:(UIImage *)image;

@end

@implementation SendController

@synthesize inputView, characterNum, sendImage;
@synthesize homeController;
@synthesize imageView;
@synthesize imageBgView;
@synthesize indicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.characterNum.text = [NSString stringWithFormat:@"%d", 
                              self.inputView.text.length];
    self.inputView.delegate = self;
    
   UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(postNewBlog)] autorelease];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    keyboardButton.frame = CGRectMake(280, 120, 30, 20);
    [self.inputView addSubview:keyboardButton];
    [keyboardButton addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageBgView.layer.cornerRadius = 4;
    self.imageBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageBgView.layer.borderWidth = 2;
}

- (void)showKeyboard {
    if ([self.inputView isFirstResponder]) {
        [self.inputView resignFirstResponder];
    }
    else {
        [self.inputView becomeFirstResponder];
    }
}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    [inputView release];
    [characterNum release];
    [sendImage release];
    [imageView release];
    [indicator release];
    [imageBgView release];

    [super dealloc];
}

- (IBAction)chooseImageFromLibary:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
}

- (IBAction)takeImageFromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init]; 
        picker.delegate = self; 
        picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
        [self presentModalViewController:picker animated:YES]; 
        [picker release];
    }
}

- (IBAction)sendLocation:(id)sender {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    [self.indicator startAnimating];
}

- (void)postNewBlog {
    NSString *postMsg;
    if (self.sendImage == nil && self.inputView.text.length == 0) {
        postMsg = @"分享图片";
    }
    else {
        postMsg = self.inputView.text;
    }
    
//    if ([[SinaManager sharedManager].sinaWeiBo isUserLoggedin]) {
//        [[SinaManager sharedManager] updateStatus:postMsg 
//                                         delegate:self
//                                   finishCallback:@selector(sinaSendFinish)
//                                     failCallback:@selector(sinaSendFail)];
//    }
//    
//    if ([[QQManager sharedManager] isUserLoggedin]) {
//        [[QQManager sharedManager] updateStatus:postMsg 
//                                       delegate:self
//                                 finishCallback:@selector(qqSendFinish)
//                                   failCallback:@selector(qqSendFail)];
//    }
//    
//    if ([[RenrenManager sharedManager].renren isSessionValid]) {
//        [[RenrenManager sharedManager] updateStatus:postMsg
//                                           delegate:self
//                                     finishCallback:@selector(renrenSendFinish)
//                                       failCallback:@selector(renrenSendFail)];
//    }
    
    Msg *msgData = (Msg *)[[CoreDataManager sharedManager] addNewObjectOfClass:[Msg class]];
    msgData.time = [NSDate date];
    msgData.msg = postMsg;
    
    if (self.sendImage != nil) {
        msgData.imageID = [NSString stringWithFormat:@"%d", (int)[msgData.time timeIntervalSince1970]];
        NSData *imageData = UIImageJPEGRepresentation(self.sendImage, 0.1f);
        NSString *imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", msgData.imageID];
        [imageData writeToFile:imagePath atomically:YES];
        
        self.sendImage = nil;
    }
    
    [self.homeController reloadData];
    
    [[CoreDataManager sharedManager] saveContext];
    
    [self back];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.characterNum.text = [NSString stringWithFormat:@"%d", 
                              self.inputView.text.length];
}

#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    self.sendImage = image;
    [self createImageView:image];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    [self createImageView:image];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.indicator stopAnimating];
    
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&zoom=14&size=400x200&sensor=true&markers=color:red|%f,%f",
                              coordinate.latitude, coordinate.longitude,coordinate.latitude, coordinate.longitude];    
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
    self.sendImage = image;
    [self createImageView:image];
    
    [manager stopUpdatingLocation];
    [manager release];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.indicator stopAnimating];
}

#pragma mark - Private 

- (void)createImageView:(UIImage *)image {
    self.imageView.image = image;
    
    self.imageView.userInteractionEnabled = YES;
    
    float imageViewRate = self.imageView.frame.size.width / self.imageView.frame.size.height;
    float imageRate = image.size.width / image.size.height;
    float scale;
    if (imageViewRate > imageRate) {
        scale = self.imageView.frame.size.height / image.size.height;
    }
    else {
        scale = self.imageView.frame.size.width / image.size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [button setImage:[UIImage imageNamed:@"delete.png"] 
            forState:UIControlStateNormal];
    button.frame = CGRectMake(- 15 + self.imageView.frame.size.width/2 - image.size
                              .width/2 * scale,
                              -15, 30, 30);
    [self.imageView addSubview:button];
    [button addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeImage {
    self.imageView.image = nil;
    for (UIView *view in self.imageView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (void)viewDidUnload {
    [self setImageBgView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}
@end
