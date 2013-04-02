//
//  GenericMessage.h
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 4/1/13.
//
//

#import <Foundation/Foundation.h>

@interface GenericMessage : NSObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, readwrite) NSInteger type;

@end
