//
//  FacebookAPI.m
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/11/13.
//
//
#import "Parse/Parse.h"
#import "FBMessage.h"
#import "FacebookAPI.h"

@implementation FacebookAPI

@synthesize feed;

static FacebookAPI *sharedDataFetcher= nil;

#pragma mark Singleton Methods
+ (id)getSharedDataFetcher {
    @synchronized(self) {
        if (sharedDataFetcher == nil)
            sharedDataFetcher = [[self alloc] init];
    }
    return sharedDataFetcher;
}

- (void) initWithFeed:(FeedViewController*) fvc{
    feed = fvc;
}

- (void) getNewsFeed {
    
    if(feed != nil)
    {
    NSMutableArray * results = [[NSMutableArray alloc] initWithArray:nil];
    
    NSString *requestPath = @"me/home";
    // Send request to Facebook
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            // FB RESPONSE
            //NSLog(@"%@", userData);
            
            NSArray * data = result[@"data"];
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {                
                NSDictionary * object = (NSDictionary*) obj;
                // Collect Facebook Data from request
                NSString *user = object[@"from"][@"name"];
                NSString* user_id = object[@"from"][@"id"];
                NSString* message = object[@"message"];
                NSString* story = object[@"story"];
                
                //NSDateFormatter *df = [[NSDateFormatter alloc] init];
                //2010-12-01T21:35:43+0000
                //[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
                //NSDate *date = [df dateFromString:[[object objectForKey:@"created_time"]// stringByReplacingOccurrencesOfString:@"T" withString:@""]];
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
                NSDate* date = [dateFormatter dateFromString:object[@"created_time"]];
                
                
                // TODO get more facebook data info
                
                // Store the message
                if(message != nil && ![message isEqualToString:@""]) {
                    FBMessage * fbpost  = [[FBMessage alloc] init];
                    fbpost.user = user;
                    fbpost.user_id = user_id;
                    fbpost.message = message;
                    
                    fbpost.story = story;
                    fbpost.date = date;
                    
                    NSLog(@"FB: %@",date);
                    [results addObject:fbpost];
                }
                
                
                
            }];
            
            [feed pushFBData:results];
        }
    }];
    }
}




@end
