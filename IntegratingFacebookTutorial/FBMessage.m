//
//  FBMessage.m
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/11/13.
//
//

#import "FBMessage.h"

@implementation FBMessage

@synthesize message, story;
@synthesize user;
@synthesize user_id;


-(NSString*) getContent {
    if(self.message == nil)
        return story;
    else if (self.story == nil)
        return message;
    else
        return @"NO DATA";
}

@end
