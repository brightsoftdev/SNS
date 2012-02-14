//
//  HomeController.m
//  SNS
//
//  Created by Bobo on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HomeController.h"
#import "SendController.h"
#import "MsgCell.h"
#import "CoreDataManager.h"
#import "Msg.h"
#import "SettingController.h"

@implementation HomeController

@synthesize msgDatas;

- (void)dealloc {
    [msgDatas release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"信息流";

 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                              target:self
                                              action:@selector(goToSendController)] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMsg)
                                                 name:kNotificationClearMsgHistory
                                               object:nil];
    
    [self reloadData];
}

- (void)reloadData {
    self.msgDatas = [NSMutableArray array];
    NSArray *msgs = [[CoreDataManager sharedManager] getAllObjectOfClass:[Msg class]
                                                                 orderBy:@"time"
                                                               ascending:NO];
    [self.msgDatas addObjectsFromArray:msgs];
    
    [self.tableView reloadData];
}

- (void)clearMsg {
    for (Msg *msg in self.msgDatas) {
         NSString *imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", msg.imageID];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                                   error:&error];
    }
    
    [[CoreDataManager sharedManager] deleteAllObjectsOfClass:[Msg class]];
    [self.msgDatas removeAllObjects];
    [self.tableView reloadData];
}

- (void) goToSendController {
    SendController *sendController = [[[SendController alloc] init] autorelease];
    sendController.homeController = self;

    [self.navigationController pushViewController:sendController animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.msgDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    Msg *msgData = [self.msgDatas objectAtIndex:[indexPath row]];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    ((MsgCell *)cell).time.text = [dateFormatter stringFromDate:msgData.time];
    ((MsgCell *)cell).msg.text = msgData.msg;
    
    if (msgData.imageID != nil) {
        NSString *imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", msgData.imageID];
        ((MsgCell *)cell).image.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float padding = 10;
    
    Msg *msgData = [self.msgDatas objectAtIndex:[indexPath row]];
    NSString *text = msgData.msg;
    
    CGSize msgSize = [text sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(240, MAXFLOAT)];
    float msgHeight = msgSize.height;
    
    float timeLabelHeight = 20;
    
    float imageHeight = 0;
    if (msgData.imageID != nil) {
        imageHeight = 100;
    }
    
    float height = timeLabelHeight + msgHeight + imageHeight + padding*3;
    
    return height;
}


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
