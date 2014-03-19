//
//  SendgridMessage.h
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import <Foundation/Foundation.h>
#import "Sendgrid.h"
#import "SendgridSmtpOptions.h"
#import "SendgridAttachment.h"

/*!
@abstract	Model to retreive the message content
*/
@interface SendgridMessage : NSObject

/*! @abstract The email associated to the from */
@property (nonatomic, readonly) NSString* fromEmail;
/*! @abstract The name associated to the name */
@property (nonatomic, readonly) NSString* fromName;
/*! @abstract The email that will receive the response for the emails */
@property (nonatomic, readonly) NSString* emailToReplay;

/*!
@abstract Array list of the to of the message.
@discussion
	The to is a dictionary with the structure:
	Key: Name	- Value: The name that will be used
	Key: Email	- Value: The email that will be used
*/
@property (nonatomic, strong, readonly) NSArray* toList;

/*! @abstract Subject of the email */
@property (nonatomic, strong) NSString *subject;
/*! @abstract The html text that will be sent as the message */
@property (nonatomic, strong) NSString *htmlBody;
/*! @abstract The simple text that will be sent as the message */
@property (nonatomic, strong) NSString *simpleTextBody;
/*! @abstract Holder of the x-smtapi content */
@property (nonatomic, strong) SendgridSmtpOptions* smtpApiOptions;
/*! @abstract Holder of the attached files */
@property (nonatomic, readonly) NSArray* attachments;
/*! @abstract Holder of the header values */
@property (nonatomic, readonly) NSDictionary* headers;

#pragma mark -
#pragma mark From scope
#pragma mark -
/*!
@abstract	Set the email that will associated as the source of the email
@param	from	The source email
*/
-(void)setFrom:(NSString*)from;
/*!
@abstract	Set the email that will associated as the source of the email with a source name
@param	from	The source email
@param	name	Source name
*/
-(void)setFrom:(NSString *)from withName:(NSString*)name;
/*!
@abstract	Set the email that will receive an answer
@param	reply Email to be replyed to
*/
-(void)setReplyTo:(NSString*)reply;

#pragma mark -
#pragma mark To scope
#pragma mark -
/*!
@abstract	Add a destination email
@param	email	To destination email
*/
-(void)addTo:(NSString *)email;
/*!
@abstract	Add a destination email with an name associated to it
@param	email	To destination email
@param	name	Name that will be associated to that email
*/
-(void)addTo:(NSString*)email withName:(NSString*)name;

#pragma mark -
#pragma mark Header scope
#pragma mark -
-(void)setHeaderValue:(NSString*)value forKey:(NSString*)key;
-(void)removeHeaderValueForKey:(NSString*)key;
-(NSString*)headerJson;

#pragma mark -
#pragma mark Attachment scope
#pragma mark -
/*!
@abstract	Add an attachment to the message
@param	attachment	Attachment
*/
-(void)addAttachment:(SendgridAttachment*)attachment;
/*!
@abstract	Remove an specific attachment by the registered token
@param	token	Token that will be used to search for the attachment
*/
-(SendgridAttachment*)removeAttachmentWithToken:(NSString*)token;
/*!
@abstract	Update the content of an Attachment
@discussion	The new attachment NEED TO HAVE the same token of the old attachment
@param	attachment	The new informations
*/
-(void)updateAttachment:(SendgridAttachment*)attachment;
/*! @abstract Method to retrieve all the inline attachments of the message */
-(NSArray*)inlineAttachments;

#pragma mark -
#pragma mark Utils
#pragma mark -

/*!
@abstract	Init the model with a content json string
@discussion	The attachments are excluded from this save method
@param	json	The formatted json string
*/
-(id)initWithJson:(NSString*)json;
/*! @abstract Convert the model to a json string */
-(NSString*)toJson;

@end
