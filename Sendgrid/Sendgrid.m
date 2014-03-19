//
//  Sendgrid.m
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import "Sendgrid.h"
#import "AFNetworking.h"

#define SendgridDomain @"https://api.sendgrid.com"
#define MailEndpoint @"/api/mail.send.json"

#define regexEmail @"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,4}"

@interface Sendgrid()

@property (nonatomic, strong) NSString* user;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) AFHTTPRequestOperationManager* manager;

@end

@implementation Sendgrid

+(instancetype)sharedInstance
{
	static Sendgrid* instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[Sendgrid alloc] init];
	});
	return instance;
}

-(void)configSendgridWithUser:(NSString*)user andPassword:(NSString*)password
{
	self.user = user;
	self.password = password;
}

-(NSString*)user
{
	return _user;
}

-(NSString*)password
{
	return _password;
}

-(void)sendMessage:(SendgridMessage*)message
	   withSuccess:(void(^)(NSString* message))success
		  andError:(void(^)(NSString* message, NSArray* errors))error
{
	if(![Sendgrid isValidEmail:message.fromEmail])
	{
		if(error)
			error(nil,[NSArray arrayWithObjects:[NSError errorWithDomain:@"Invalid from email" code:500 userInfo:nil], nil]);
		return;
	}
	
	if(message.toList == nil || message.toList.count == 0)
	{
		if(error)
			error(nil,[NSArray arrayWithObjects:[NSError errorWithDomain:@"Empty to list" code:400 userInfo:nil], nil]);
		return;
	}

	if(self.manager == nil) {
		self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SendgridDomain]];
	}
	
	[self.manager POST:[NSString stringWithFormat: @"%@%@",SendgridDomain, MailEndpoint]
			parameters:[self parametersDictionaryForMessage:message] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
				if(message.attachments != nil)
				{
					for(SendgridAttachment* at in message.attachments)
					{
						[formData appendPartWithFileData:at.binaryContent
													name:[NSString stringWithFormat:@"files[%@]",at.fileName]
												fileName:at.fileName
												mimeType:at.mimeType];
					}
				}
			}
			   success:^(AFHTTPRequestOperation *operation, id responseObject) {
				   if(success)
				   {
					   NSString* message = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
					   
					   if(message && message.length > 0)
					   {
						   NSError* jsonError;
						   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&jsonError];
						   if(!jsonError)
						   {
							   success([json objectForKey:@"message"]);
						   }
					   } else
					   {
						   success(@"message");
					   }
				   }
			   } failure:^(AFHTTPRequestOperation *operation, NSError *e) {
				   if(error)
				   {
					   NSString* message = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
					   
					   if(message && message.length > 0)
					   {
						   NSError* jsonError;
						   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&jsonError];
						   if(!jsonError)
						   {
							   NSArray* errors = [json objectForKey:@"errors"];
							   NSMutableArray* es = [[NSMutableArray alloc] init];
							   for(NSString* s in errors)
							   {
								   [es addObject:[NSError errorWithDomain:s code:501 userInfo:nil]];
							   }
							   error([json objectForKey:@"message"],es);
						   }else
						   {
							   error(message,@[e]);
						   }
					   }else
					   {
						   error(message,@[e]);
					   }
				   }
			   }];

}

- (NSDictionary *)parametersDictionaryForMessage:(SendgridMessage*)message
{
    //Building up Parameter Dictionary
    NSMutableDictionary *parameters =[NSMutableDictionary dictionaryWithDictionary:@{@"api_user": self.user,
                                                                                     @"api_key": self.password,
                                                                                     @"subject":message.subject,
                                                                                     @"from":message.fromEmail
                                                                                     }];
    
	
	if(message.toList && message.toList.count > 0)
	{
		NSDictionary* to = [message.toList objectAtIndex:0];
		NSString* email = [to objectForKey:@"email"];
		NSString* name = [to objectForKey:@"name"];
		[parameters setObject:email forKey:@"to"];
		if(name && name.length > 0 && ![name isEqualToString:email])
			[parameters setObject:name forKey:@"toname"];
	}
	
	if(message.smtpApiOptions != nil)
		[parameters setObject:[message.smtpApiOptions toJson] forKey:@"x-smtpapi"];
	if(message.simpleTextBody != nil)
		[parameters setObject:message.simpleTextBody forKey:@"text"];
	if(message.htmlBody != nil)
		[parameters setObject:message.htmlBody forKey:@"html"];
    if(message.fromName != nil)
        [parameters setObject:message.fromName forKey:@"fromname"];
    if(message.emailToReplay != nil)
        [parameters setObject:message.emailToReplay forKey:@"replyto"];
    if(message.inlineAttachments != nil)
	{
		for(SendgridAttachment* attachment in message.inlineAttachments)
		{
			[parameters setObject:attachment.fileName forKey:[NSString stringWithFormat:@"content[%@]",attachment.fileName]];
		}
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
	[parameters setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
    
    return parameters;
}

-(SendgridMessage *)createNewMessage
{
	return [self createNewMessageWithSmtpOptions:[[SendgridSmtpOptions alloc] init]];
}

-(SendgridMessage *)createNewMessageWithSmtpOptions:(SendgridSmtpOptions*)options
{
	SendgridMessage* message = [[SendgridMessage alloc] init];
	[message setSmtpApiOptions:options];
	return message;
}

-(NSString*)saveDraft:(SendgridMessage*)message
{
	NSString* jsonString = [message toJson];
	NSString* token = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
	NSArray* messages = nil;
	messages = [[NSUserDefaults standardUserDefaults] objectForKey:@"SenGrid_messages"];
	NSMutableArray* temp;
	if(messages == nil)
	{
		temp = [[NSMutableArray alloc] init];
	}else
	{
		temp = [[NSMutableArray alloc] initWithArray:messages];
	}
	[temp addObject:@{@"Token":token, @"Message":jsonString}];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:temp] forKey:@"SendGrid_messages"];
	
	return token;
}
-(SendgridMessage*)loadDraft:(NSString*)token
{
	NSArray* messages = [[NSUserDefaults standardUserDefaults] objectForKey:@"SenGrid_messages"];
	if(messages == nil || messages.count == 0)
		return nil;
	for(NSDictionary* dict in messages)
	{
		if([token isEqualToString:[dict objectForKey:@"Token"]])
		{
			return [[SendgridMessage alloc] initWithJson:[dict objectForKey:@"Message"]];
		}
	}
	return nil;
}

+(BOOL)isValidEmail:(NSString*)email
{
	if(email == nil || email.length == 0)
		return NO;
	
	NSError* error;
	
	NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:regexEmail
																	  options:NSRegularExpressionAllowCommentsAndWhitespace
																		error:&error];
	if(error)
		return NO;
	return ([regex rangeOfFirstMatchInString:email options:0 range:NSMakeRange(0, email.length)].location != NSNotFound);
}

+(NSArray*)filterEmailAndNameFromField:(NSString*)field
{
	NSString* email = nil;
	NSString* name = nil;
	
	NSError* error;
	
	NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:regexEmail
																	  options:NSRegularExpressionAllowCommentsAndWhitespace
																		error:&error];
	if(!error)
	{
		NSArray* mathces = [regex matchesInString:field options:0 range:NSMakeRange(0, field.length)];
		if(mathces && mathces.count > 0)
		{
			NSTextCheckingResult* regexResult = [mathces objectAtIndex:0];
			email = [field substringWithRange:regexResult.range];
			name = [field substringWithRange:NSMakeRange(0, regexResult.range.location)];
			if(name && name.length > 0)
			{
				name = [name stringByReplacingOccurrencesOfString:@"<" withString:@""];
				name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			}
		}
	}
	
	return @[email, name];
}

@end