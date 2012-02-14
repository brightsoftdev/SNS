//
//  HomeController.h
//  SNS
//
//  Created by Bobo on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface HomeController : UITableViewController 
<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *msgDatas;

- (void)reloadData;

@end
