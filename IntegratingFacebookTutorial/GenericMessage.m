//
//  GenericMessage.m
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 4/1/13.
//
//

#import "GenericMessage.h"

@implementation GenericMessage

@synthesize message;
@synthesize user_id;
@synthesize user;
@synthesize date;
@synthesize type;

- (NSComparisonResult)compare:(GenericMessage *)otherObject {
    NSLog(@"comparing %@ with %@", self.date, otherObject.date);
    return [otherObject.date compare:self.date];
}


@end
