//
//  FeedViewController.m
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/10/13.
//
//

#import "FeedViewController.h"

#import "FBMessage.h"
#import "TwitterMessage.h"
#import "GenericMessage.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize tableView;
@synthesize fbMessages;
@synthesize feed;
@synthesize twitterFeed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    FacebookAPI *facebookAPI = [FacebookAPI getSharedDataFetcher];
    [facebookAPI initWithFeed:self];
    [facebookAPI getNewsFeed];
    
    TwitterAPI *twitterAPI = [TwitterAPI getSharedDataFetcher];
    [twitterAPI initWithFeed:self];
    
    fbMessages = [[NSMutableArray alloc] initWithArray:nil];
    twitterFeed = [[NSMutableArray alloc] initWithArray:nil];
    feed = [[NSMutableArray alloc] initWithArray:nil];
    
    self.title = @"Facebook Profile";
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    // Create array for table row titles
    //_rowTitleArray = @[@"Location", @"Gender", @"Date of Birth", @"Relationship"];
    
    // Set default values for the table row data
    //_rowDataArray = [NSMutableArray arrayWithObjects:@"N/A", @"N/A", @"N/A", @"N/A", nil];
    
    
    // Create request for user's facebook data
    
}

- (void) addToFeed:(NSMutableArray*) data {
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GenericMessage * message = [[GenericMessage alloc] init];
        if([obj isKindOfClass:[FBMessage class]]) {
            message.message = ((FBMessage*)obj).message;
            message.user = ((FBMessage*)obj).user;
            message.user_id = ((FBMessage*)obj).user_id;
            message.date = ((FBMessage*)obj).date;
            message.type = 1; //FACEBOOK
            // TODO: MAKE THIS AN ENUM
        } else if ([obj isKindOfClass:[TwitterMessage class]]) {
            message.message = ((TwitterMessage*)obj).message;
            message.user = ((TwitterMessage*)obj).user;
            message.user_id = ((TwitterMessage*)obj).user_id;
            message.date = ((TwitterMessage*)obj).date;
            message.type = 2; //TWITTER
            // TODO: MAKE THIS AN ENUM
            
        }
        [feed addObject:message];
    }];
    
    
     
    NSArray * sortedArray = [feed sortedArrayUsingSelector:@selector(compare:)];
    
    
    feed = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    
    
    
    [tableView reloadData];
    
}

- (void) pushFBData:(NSMutableArray*) data {
    fbMessages = data;
    [self addToFeed:fbMessages];
}

- (void) pushTwitterData:(NSMutableArray *)data {
    twitterFeed = data;
    [self addToFeed:twitterFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    //[_imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    //_headerImageView.image = [UIImage imageWithData:_imageData];
    
    // Add a nice corner radius to the image
    //_headerImageView.layer.cornerRadius = 8.0f;
    //_headerImageView.layer.masksToBounds = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    //TODO Need to switch this based on the type of cell (i.e. Facebook / Twitter) 
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 120.0f, 44.0f)];
//        titleLabel.tag = 1; // We use the tag to set it later
//        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        
//        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake( 130.0f, 0.0f, 165.0f, 44.0f)];
//        dataLabel.tag = 2; // We use the tag to set it later
//        dataLabel.font = [UIFont systemFontOfSize:15.0f];
//        dataLabel.backgroundColor = [UIColor clearColor];
        
//        [cell.contentView addSubview:titleLabel];
//        [cell.contentView addSubview:dataLabel];
    }
    
    // Cannot select these cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    // Access labels in the cell using the tag #
//    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
//    UILabel *dataLabel = (UILabel *)[cell viewWithTag:2];
    
    // Display the data in the table
   // titleLabel.text = [_rowTitleArray objectAtIndex:indexPath.row];
    
    
    GenericMessage* message = [feed objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d: %@", message.type, message.message];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", message.date];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (IBAction)twitterLogin:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            if (![PFTwitterUtils isLinkedWithUser:user]) {
                [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
                    if ([PFTwitterUtils isLinkedWithUser:user]) {
                        NSLog(@"Woohoo, user logged in with Twitter!");
                    }
                }];
            }
            [self loadTwitterData];
        } else {
            NSLog(@"User logged in with Twitter!");
            if (![PFTwitterUtils isLinkedWithUser:user]) {
                [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
                    if ([PFTwitterUtils isLinkedWithUser:user]) {
                        NSLog(@"Woohoo, user logged in with Twitter!");
                    }
                }];
            }
            [self loadTwitterData];
        }     
    }];
}

- (void) loadTwitterData {
    
    
    [[TwitterAPI getSharedDataFetcher] getTwitterFeed];
    NSLog(@"GOT FEED");
    [tableView reloadData];
}

#pragma mark - 

- (void)logoutButtonTouchHandler:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
