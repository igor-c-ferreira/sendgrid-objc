//
//  Sendgrid.h
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import <Foundation/Foundation.h>
#import "SendgridFilter.h"
#import "SendgridSmtpOptions.h"
#import "SendgridAttachment.h"
#import "SendgridMessage.h"

@class SendgridMessage;

/*! @abstract Main class*/
@interface Sendgrid : NSObject

#pragma mark -
#pragma mark Sendgrid configuration
#pragma mark -
/*! @abstract Shared instance (Singleton) */
+(instancetype)sharedInstance;
/*!
@abstract Config the shared instance with a SendGrid user and a SendGrid password
@param	user		The SendGrid user
@param	password	The SendGrid password
*/
-(void)configSendgridWithUser:(NSString*)user andPassword:(NSString*)password;

#pragma mark -
#pragma mark Mail Endpoint container
#pragma mark -
/*!
@abstract	Create a new message with a empty SendgridSmtpOptions
@return	Empty message
*/
-(SendgridMessage*)createNewMessage;
/*!
@abstract	Create a new message with a empty SendgridSmtpOptions
@param	options	The SendgridSmtpOptions that will be associated to the message
@return	Empty message
*/
-(SendgridMessage*)createNewMessageWithSmtpOptions:(SendgridSmtpOptions*)options;
/*!
@abstract	Async operation to send the message
@param	message	Message that will be sent
@param	success	Block that will be called in the success of the operation
@param	error	Block that will be called in the error of the operation
*/
-(void)sendMessage:(SendgridMessage*)message
	   withSuccess:(void(^)(NSString* message))success
		  andError:(void(^)(NSString* message, NSArray* errors))error;
/*!
@abstract	Operation to save a message to the NSUserDefault
@param	message	Message that will be saved
@return	The token of the saved draft
*/
-(NSString*)saveDraft:(SendgridMessage*)message;
/*!
@abstract	Load a saved draft
@param	token	The token of the saved draft
@return	The saved message
*/
-(SendgridMessage*)loadDraft:(NSString*)token;

#pragma mark -
#pragma mark Utils
#pragma mark -
+(BOOL)isValidEmail:(NSString*)email;
+(NSArray*)filterEmailAndNameFromField:(NSString*)field;

@end
