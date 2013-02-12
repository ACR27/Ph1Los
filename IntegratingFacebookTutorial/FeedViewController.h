//
//  FeedViewController.h
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface FeedViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView * tableView;

@end
