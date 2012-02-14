//
//  SnsSwitchCell.m
//  SNS
//
//  Created by it on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SnsSwitchCell.h"

@implementation SnsSwitchCell

@synthesize imageview;
@synthesize textlabel;
@synthesize switchControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)dealloc {
    [imageview release];
    [textlabel release];
    [switchControl release];
    
    [super dealloc];
}


@end
