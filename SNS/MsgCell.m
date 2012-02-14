//
//  MsgCell.m
//  SNS
//
//  Created by Bobo on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell

@synthesize time;
@synthesize msg;
@synthesize image;

static float kPadding = 10;

- (void)dealloc {
    [time release];
    [msg release];
    [image release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(kPadding,
                                                              kPadding,
                                                              320 - 2*kPadding,
                                                              20)];
        self.time.backgroundColor = [UIColor clearColor];
        self.time.textColor = [UIColor grayColor];
        self.time.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.time];
        
        self.msg = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 
                                                             kPadding + 20 + kPadding,
                                                             320 - 2*kPadding,
                                                             0)]; // height set later
        self.msg.backgroundColor = [UIColor clearColor];
        self.msg.textColor = [UIColor blackColor];
        self.msg.font = [UIFont systemFontOfSize:14];
        self.msg.numberOfLines = 0;
        [self.contentView addSubview:self.msg];
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectZero]; // size later
        [self.contentView addSubview:self.image];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize msgSize = [self.msg.text sizeWithFont:self.msg.font
                               constrainedToSize:CGSizeMake(self.msg.frame.size.width, MAXFLOAT)];
    CGRect msgFrame = self.msg.frame;
    msgFrame.size.height = msgSize.height;
    self.msg.frame = msgFrame;
    
    if (self.image.image) {
        self.image.frame = CGRectMake(160 - 100, 
                                      msgFrame.origin.y + msgFrame.size.height, 200, 100);
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.image.image = nil;
}

@end
