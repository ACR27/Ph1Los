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


@interface FeedViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) NSMutableArray * fbMessages;


- (void) pushFBData:(NSMutableArray*) data;

@end
