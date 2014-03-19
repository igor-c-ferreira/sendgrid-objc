//
//  SendgridFilters.h
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import <Foundation/Foundation.h>

/*!
@abstract	Class created to be a factory to the SMTP API filter objects
@discussion
	Following are the apps that can be specified in the filters section of the X-SMTPAPI header.
	For more information on the utility of these apps, please check out the Apps section ( http://sendgrid.com/docs/Apps/ ).
*/
@interface SendgridFilter : NSObject

#pragma mark -
#pragma mark Properties
#pragma mark -

/*! @abstract	Type of the filter. After the creation, this type cannot be changed */
@property (nonatomic, readonly) NSString* type;
/*! @abstract	The holder of the configuration of the filter */
@property (nonatomic, readonly) NSDictionary* settings;
/*! @abstract	Flag to indicate if the filter is enabled or not (The same configuration will be send to the API) */
@property (nonatomic, assign) BOOL enabled;

#pragma mark -
#pragma mark Initialization
#pragma mark -

/*!
@abstract	Init an empty filter with a specific type
@param	type Type of the filter
@return Empty filter
*/
-(id)initWithType:(NSString*)type;

#pragma mark -
#pragma mark Utils
#pragma mark -

-(NSString*)toJson;
-(id)initWithJson:(NSString*)json;
-(NSDictionary*)toDictionary;
-(id)initWithDicitionary:(NSDictionary*)dict;

#pragma mark -
#pragma mark Factory
#pragma mark -

/*!
@abstract	Sends a BCC copy of the email created in this transaction to the address specified.
@param	enabled	Disable or enable this App
@param	email	Email address destination for the bcc message
@return	Formatted Filter
*/
+(instancetype)createBCCFilterEnabled:(BOOL)enabled withEmail:(NSString*)email;
/*!
@abstract	Some emails are too important to do normal list management checks, such as password resets or critical alerts.
 Enabling this filter will bypass the normal unsubscribe / bounce / spam report checks and queue the e-mail for delivery.
@param	enabled	Disable or enable this App
@return	Formatted Filter
*/
+(instancetype)createBypassFilterEnabled:(BOOL)enabled;
/*!
@abstract	Rewrites links in e-mail text and html bodies to go through our webservers, allowing for tracking when a link is clicked on.
@param	enabled	Disable or enable this App
@return	Formatted Filter
*/
+(instancetype)createClickTrackFilterEnabled:(BOOL)enabled;
/*!
@abstract	Allows you to specify the domain to use to sign messages with DKIM certification.
 This domain should match the domain in the From address of your e-mail.
 For more info, check out these details on DKIM ( http://sendgrid.com/docs/Apps/dkim.html ).
@param	domain	The domain you would like your DKIM certification signed with
@param	useFrom	If enabled, the domain in the From: header of the email will be used to sign your DKIM
@return	Formatted Filter
*/
+(instancetype)createDkimFilterWithDomain:(NSString*)domain usingFrom:(BOOL)useFrom;
/*!
@abstract	Allows you to specify the domain to use to sign messages with Domain Keys.
 This domain should match the domain in the From address of your e-mail.
 For more info, check out these details on Domain Keys ( http://sendgrid.com/docs/Apps/domain_keys.html ).
@param	enabled	Disable or enable this App
@param	domain	The domain to sign messages as
@param	header	Insert a Sender header if the domain specified does not match the From address.
@return	Formatted Filter
*/
+(instancetype)createDomainKeysFilterEnabled:(BOOL)enabled withDomain:(NSString*)domain sendingHeader:(BOOL)header;
/*!
@abstract	Inserts a footer at the bottom of the text and HTML bodies.
@param	enabled	Disable or enable this App
@param	html	String containing html body
@param	simple	String containing text body
@return	Formatted Filter
*/
+(instancetype)createFooterFilterEnabled:(BOOL)enabled withHTMLText:(NSString*)html andSimpleText:(NSString*)simple;
/*!
@abstract	Allows for a copy of spam reports to be forwarded to an email address.
@param	enabled	Disable or enable this App
@param	email	Email address destination for spam report to go to
@return	Formatted Filter
*/
+(instancetype)createForwardSpamFilterEnabled:(BOOL)enabled toEmail:(NSString*)email;
/*!
@abstract	Re-writes links to integrate with Google Analytics.
@param	enabled		Disable or enable this App
@param	source		Value for the utm_source field
@param	medium		Value for the utm_medium field
@param	term		Value for the utm_term field
@param	content		Value for the utm_content field
@param	campaign	Value for the utm_campaign field
@return	Formatted Filter
*/
+(instancetype)createGAnalyticsFilterEnabled:(BOOL)enabled
								  withSource:(NSString*)source
									  medium:(NSString*)medium
										term:(NSString*)term
									 content:(NSString*)content
								 andCampaign:(NSString*)campaign;
/*!
@abstract	Inserts an img tag at the bottom of the html section of an e-mail to display the gravatar associated with the mail sender.
@param	enabled	Disable or enable this App
@return	Formatted Filter
*/
+(instancetype)createGravatarFilterEnabled:(BOOL)enabled;
/*!
@abstract	Inserts an <img> tag at the bottom of the html section of an e-mail which will be used to track if an e-mail is opened.
@param	enabled	Disable or enable this App
@return	Formatted Filter
*/
+(instancetype)createOpenTrackFitlerEnabled:(BOOL)enabled;
/*!
@abstract	Tests message with SpamAssassin ( http://spamassassin.apache.org/ ) to determine if it is spam, and drop it if it is.
@param	enabled	Disable or enable this App
@param	maxScore	Score after which the message will be dropped (default is 5.0, higher scores indicate higher likelihood of spam)
@param	url			An optional url to POST the email and a copy of the report to
@return	Formatted Filter
*/
+(instancetype)createSpamCheckFilterEnabled:(BOOL)enabled withMaxScore:(CGFloat)maxScore andUrl:(NSString*)url;
/*!
@abstract	Inserts a subscription management link at the bottom of the text and html bodies or insert the link anywhere in the email.
 If you wish to append an unsubscription link, use the text/html and text/plain paremeters.
 However, if you wish to have the link replace a tag (such as [unsubscribe]), use the replace parameter.
@param	enabled	Disable or enable this App
@param	html	HTML to be appended to the email, with the subscription tracking link. You may control where the link is by using a tag like so: <% link text %>
@param	simple	Text to be appended to the email, with the subscription tracking link. You may control where the link is by using a tag like so: <% %>
@param	tag		A tag that will be replaced with the unsubscribe URL (e.g. -unsubscribe_link-). If this parameter is included, it will override html and plain.
@return	Formatted Filter
*/
+(instancetype)createSubscriptionTrackFilterEnabled:(BOOL)enabled
										   withHTML:(NSString*)html
										 simpleText:(NSString*)simple
											 andTag:(NSString*)tag;
/*!
@abstract	Wraps a template around your email content. Useful for sending out marketing email and other nicely formatted messages.
@param	enabled	Disable or enable this App
@param	html	String containing html content for the template (must contain a <% body %> tag)
@return	Formatted Filter
*/
+(instancetype)createTemplateFilterEnabled:(BOOL)enabled withHtml:(NSString*)html;

@end
