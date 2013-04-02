//
//  TwitterAPI.m
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 3/10/13.
//
//

#import "TwitterMessage.h"
#import "TwitterAPI.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation TwitterAPI

@synthesize feed;
@synthesize accountStore;

static TwitterAPI *sharedDataFetcher= nil;


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
    accountStore = [[ACAccountStore alloc] init];
    
    NSString *token = [[PFTwitterUtils twitter] authToken];
    NSString *secret = [[PFTwitterUtils twitter] authTokenSecret];
    [self storeAccountWithAccessToken:token secret:secret];
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) getTwitterFeed {
    NSMutableArray * results = [[NSMutableArray alloc] initWithArray:nil];
    if(feed != nil)
    {
        //  Step 0: Check that the user has local Twitter accounts
        if ([self userHasAccessToTwitter]) {
            
            //  Step 1:  Obtain access to the user's Twitter accounts
            ACAccountType *twitterAccountType = [self.accountStore
                                                 accountTypeWithAccountTypeIdentifier:
                                                 ACAccountTypeIdentifierTwitter];
            [self.accountStore
             requestAccessToAccountsWithType:twitterAccountType
             options:NULL
             completion:^(BOOL granted, NSError *error) {
                 if (granted) {
                     //  Step 2:  Create a request
                     NSArray *twitterAccounts =
                     [self.accountStore accountsWithAccountType:twitterAccountType];
                     
                     // GET YOUR OWN TIMELINE (messages you have posted)
                     NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                                   @"/1.1/statuses/home_timeline.json"];
                     NSDictionary *params = @{@"include_rts" : @"0"};
                     SLRequest *request =
                     [SLRequest requestForServiceType:SLServiceTypeTwitter
                                        requestMethod:SLRequestMethodGET
                                                  URL:url
                                           parameters:params];
                     
                     //  Attach an account to the request
                     [request setAccount:[twitterAccounts lastObject]];
                     
                     //  Step 3:  Execute the request
                     [request performRequestWithHandler:^(NSData *responseData,
                                                          NSHTTPURLResponse *urlResponse,
                                                          NSError *error) {
                         if (responseData) {
                             if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                 NSError *jsonError;
                                 NSMutableArray *timelineData =
                                  
                                 [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:NSJSONReadingAllowFragments error:&jsonError];
                                 
                                 if (timelineData) {
                                     //NSLog(@"%@", timelineData);
                                     [timelineData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                         TwitterMessage *message = [[TwitterMessage alloc] init];
                                         message.message = obj[@"text"];
                                         message.user = obj[@"user"][@"name"];
                                         
                                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                         NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                                         [dateFormatter setLocale:usLocale];
                                         [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                                         [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
                                         
                                         // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
                                         [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
                                         
                                         message.date = [dateFormatter dateFromString:[obj objectForKey:@"created_at"]];
                                         
                                         //NSTimeInterval seconds = [date timeIntervalSince1970];
                                         //Sun May 03 06:13:07 +0000 2009
                                         NSLog(@"%@", message.date);
                                         [results addObject:message];
                                     }];
                                     [feed pushTwitterData:results];
                                 }
                                 else {
                                     // Our JSON deserialization went awry
                                     NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                 }
                             }
                             else {
                                 // The server did not respond successfully... were we rate-limited?
                                 NSLog(@"The response status code is %d", urlResponse.statusCode);
                             }
                         }
                     }];
                 }
                 else {
                     // Access was not granted, or an error occurred
                     NSLog(@"%@", [error localizedDescription]);
                 }
             }];
        }
    }
}


- (void)fetchTimelineForUser:(NSString *)username
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/user_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : username};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *timelineData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);

                                 NSLog(@"Text: %@", timelineData[@"text"]);
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}



- (void)storeAccountWithAccessToken:(NSString *)token secret:(NSString *)secret
{
    //  Each account has a credential, which is comprised of a verified token and secret
    ACAccountCredential *credential =
    [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    
    //  Obtain the Twitter account type from the store
    ACAccountType *twitterAcctType =
    [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Create a new account of the intended type
    ACAccount *newAccount = [[ACAccount alloc] initWithAccountType:twitterAcctType];
    
    //  Attach the credential for this user
    newAccount.credential = credential;
    
    //  Finally, ask the account store instance to save the account
    //  Note: that the completion handler is not guaranteed to be executed
    //  on any thread, so care should be taken if you wish to update the UI, etc.
    [accountStore saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            // we've stored the account!
            NSLog(@"the account was saved!");
        }
        else {
            //something went wrong, check value of error
            NSLog(@"the account was NOT saved");
            
            // see the note below regarding errors...
            //  this is only for demonstration purposes
            if ([[error domain] isEqualToString:ACErrorDomain]) {
                
                // The following error codes and descriptions are found in ACError.h
                switch ([error code]) {
                    case ACErrorAccountMissingRequiredProperty:
                        NSLog(@"Account wasn't saved because "
                              "it is missing a required property.");
                        break;
                    case ACErrorAccountAuthenticationFailed:
                        NSLog(@"Account wasn't saved because "
                              "authentication of the supplied "
                              "credential failed.");
                        break;
                    case ACErrorAccountTypeInvalid:
                        NSLog(@"Account wasn't saved because "
                              "the account type is invalid.");
                        break;
                    case ACErrorAccountAlreadyExists:
                        NSLog(@"Account wasn't added because "
                              "it already exists.");
                        break;
                    case ACErrorAccountNotFound:
                        NSLog(@"Account wasn't deleted because"
                              "it could not be found.");
                        break;
                    case ACErrorPermissionDenied:
                        NSLog(@"Permission Denied");
                        break;
                    case ACErrorUnknown:
                    default: // fall through for any unknown errors...
                        NSLog(@"An unknown error occurred.");
                        break;
                }
            } else {
                // handle other error domains and their associated response codes...
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    }];
    
    
}

@end
