//
//  FacebookAPI.h
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import "FeedViewController.h"
@class FeedViewController;
@interface FacebookAPI : NSObject
@property (nonatomic,retain) FeedViewController* feed;


// Class Methods
+ (id)getSharedDataFetcher;

// Feed Methods
- (void) initWithFeed:(FeedViewController*) fvc;
- (void) getNewsFeed;


@end
