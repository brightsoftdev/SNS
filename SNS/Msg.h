//
//  Msg.h
//  SNS
//
//  Created by Bobo on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Msg : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * imageID;

@end
