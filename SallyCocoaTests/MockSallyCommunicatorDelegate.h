//
//  MockSallyCommunicatorDelegate.h
//  Sally
//
//  Created by Zaid Al-Jarrah on 2014-03-25.
//  Copyright (c) 2014 Tokenize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SallyCommunicatorDelegate.h"

@interface MockSallyCommunicatorDelegate : NSObject <SallyCommunicatorDelegate>

@property NSError *error;
@property NSString *apiToken;
@property NSArray *trips;
@property NSArray *locations;
@property NSDictionary *trip;
@property NSDictionary *location;

@end
