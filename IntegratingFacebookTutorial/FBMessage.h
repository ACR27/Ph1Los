//
//  FBMessage.h
//  IntegratingFacebookTutorial
//
//  Created by Amar Rao on 2/11/13.
//
//

#import <Foundation/Foundation.h>

@interface FBMessage : NSObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * story;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user;


-(NSString*) getContent;

@end
