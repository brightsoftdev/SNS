//
//  SettingController.m
//  SNS
//
//  Created by  on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingController.h"
#import "TKAlertCenter.h"
#import "CoreDataManager.h"
#import "Msg.h"
#import "SnsSwitchCell.h"
#import "SNSBinder.h"

NSString *const kNotificationClearMsgHistory = @"NotificationClearMsgHistory";

enum {
    kAlertTypeSinaLogout = 1,
    kAlertTypeTxLogout
} AlertType;

@interface SettingController (Private)

-(void)showPicker;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
- (void)clearMsgHistory;

@end

@implementation SettingController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"设置";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 2;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (section == 0) {
        static NSString *SnsSwitchCellIdentifier = @"SnsSwitchCellIdentifier ";
        
        SnsSwitchCell *cell = (SnsSwitchCell *)[tableView dequeueReusableCellWithIdentifier: SnsSwitchCellIdentifier];
        
        if (cell == nil)  
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SnsSwitchCell" 
                                                         owner:self options:nil];
            cell = (SnsSwitchCell *)[nib objectAtIndex:0];
            
        }
        
        switch (row) {
            case 0: {
                cell.imageview.image = [UIImage imageNamed:@"sinaIcon.png"];
                cell.textlabel.text = @"同步到新浪微博";
                cell.switchControl.on = [[SNSBinder sharedBinder] isSinaLogin];
                [cell.switchControl addTarget:self 
                                       action:@selector(bindSina:)
                             forControlEvents:UIControlEventValueChanged];
            }
                break;
                
            case 1: {
                cell.imageview.image = [UIImage imageNamed:@"tengxunIcon.png"];
                cell.textlabel.text = @"同步到腾讯微博";
                cell.switchControl.on = [[SNSBinder sharedBinder] isTxLogin];
                [cell.switchControl addTarget:self 
                                       action:@selector(bindTx:)
                             forControlEvents:UIControlEventValueChanged];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        if (section == 1) {
            cell.textLabel.text = @"清除信息流历史纪录";
        }
        else if (section == 2) {
            if (row == 0) {
                cell.textLabel.text = @"意见反馈";
            }
            else if (row == 1) {
                cell.textLabel.text = @"关于";
            }
        }

        return cell;
    }    
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {

    }
    else if ([indexPath section] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"是否清除?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
       
    }
    else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            [self showPicker];
        }
        else if ([indexPath row] == 1) {
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)showPicker
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello from California!"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"boboboa32@gmail.com"]; 
	
	[picker setToRecipients:toRecipients];
	
    [picker setSubject:@"意见反馈"];
    
	// Fill out the email body text
//	NSString *emailBody = @"";
//	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"感谢您的宝贵意见！"];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:boboboa32@gmail.com?subject=意见反馈";
	
	NSString *email = [NSString stringWithFormat:@"%@", recipients];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)clearMsgHistory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClearMsgHistory
                                                        object:nil];
}

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kAlertTypeSinaLogout) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [[SNSBinder sharedBinder] sinaLogout];
        }
        else {
            [self.tableView reloadData];
        }
    }
    else if (alertView.tag == kAlertTypeTxLogout) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [[SNSBinder sharedBinder] txLogout];
        }
        else {
            [self.tableView reloadData];
        }
    }
    else {
        [self clearMsgHistory];
    }
}

#pragma mark - delegate

- (void)bindSina:(UISwitch *)control {
    if (!control.on) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否取消同步新浪微博?"
                                                        message:@"确定取消后需重新验证"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = kAlertTypeSinaLogout;
        [alert show];
        [alert release];
    }
    else {
        [[SNSBinder sharedBinder] startSinaOauthWithNavigationController:self.navigationController];
    }
}

- (void)bindTx:(UISwitch *)control {
    if (!control.on) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否取消同步腾讯微博?"
                                                        message:@"确定取消后需重新验证"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = kAlertTypeTxLogout;
        [alert show];
        [alert release];
    }
    else {
        [[SNSBinder sharedBinder] startTxOauthWithNavigationController:self.navigationController];
    }
}

@end
