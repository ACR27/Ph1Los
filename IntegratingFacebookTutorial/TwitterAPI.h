//
//  TwitterAPI.h
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 3/10/13.
//
//

#import <Foundation/Foundation.h>
#import "FeedViewController.h"
#import <Accounts/Accounts.h>
#import "TwitterMessage.h"

@class FeedViewController;
@interface TwitterAPI : NSObject

@property (nonatomic,retain) FeedViewController* feed;
@property (nonatomic) ACAccountStore *accountStore;


// Class Methods
+ (id)getSharedDataFetcher;
- (void) initWithFeed:(FeedViewController*) fvc;
- (void) getTwitterFeed;
- (void)storeAccountWithAccessToken:(NSString *)token secret:(NSString *)secret;

@end
