//
//  FeedViewController.h
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FacebookAPI.h"
#import "TwitterAPI.h"


@interface FeedViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) NSMutableArray * fbMessages;
@property (nonatomic, retain) NSMutableArray * twitterFeed;
@property (nonatomic, copy) NSMutableArray * feed;


- (void) pushFBData:(NSMutableArray*) data;
- (void) pushTwitterData:(NSMutableArray*) data;
- (IBAction) twitterLogin:(id) sender;
- (void) loadTwitterData;


@end
