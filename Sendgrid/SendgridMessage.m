//
//  SendgridMessage.m
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import "SendgridMessage.h"

@interface SendgridMessage()

@property (nonatomic, strong) NSMutableArray* mToList;
@property (nonatomic, strong) NSMutableArray* mAttachments;
@property (nonatomic, strong) NSMutableDictionary* mHeaders;

@end

@implementation SendgridMessage

-(void)setSmtpApiOptions:(SendgridSmtpOptions *)smtpApiOptions
{
	_smtpApiOptions = smtpApiOptions;
	if(_smtpApiOptions && self.mToList != nil && self.mToList.count > 0)
	{
		for(NSDictionary* dict in self.mToList)
		{
			NSString* name = [dict objectForKey:@"name"];
			NSString* email = [dict objectForKey:@"email"];
			
			[_smtpApiOptions addTo:name withName:email];
		}
	}
}

#pragma mark -
#pragma mark From scope
#pragma mark -

-(void)setFrom:(NSString *)from
{
	NSArray* fields = [Sendgrid filterEmailAndNameFromField:from];
	[self setFrom:[fields objectAtIndex:0] withName:[fields objectAtIndex:1]];
}

-(void)setFrom:(NSString *)from withName:(NSString *)name
{
	if([Sendgrid isValidEmail:from])
	{
		_fromEmail = from;
		_fromName = name;
	}
}

-(void)setReplyTo:(NSString *)reply
{
	if([Sendgrid isValidEmail:reply])
	{
		_emailToReplay = reply;
	}
}

#pragma mark -
#pragma mark To scope
#pragma mark -

-(void)addTo:(NSString *)email
{
	NSArray* fields = [Sendgrid filterEmailAndNameFromField:email];
	[self addTo:[fields objectAtIndex:0] withName:[fields objectAtIndex:1]];
}

-(void)addTo:(NSString *)email withName:(NSString *)name
{
	if(self.mToList == nil)
	{
		self.mToList = [[NSMutableArray alloc] init];
	}
	[self.mToList addObject:@{@"name":name,@"email":email}];
	
	if(self.smtpApiOptions == nil) {
		SendgridSmtpOptions* options = [[SendgridSmtpOptions alloc] init];
		[self setSmtpApiOptions:options];
	} else {
		[self.smtpApiOptions addTo:email withName:name];
	}
}

#pragma mark -
#pragma mark Header scope
#pragma mark -
-(void)setHeaderValue:(NSString*)value forKey:(NSString*)key
{
	if(self.mHeaders == nil)
	{
		self.mHeaders = [[NSMutableDictionary alloc] init];
	}
	[self.mHeaders setObject:value forKey:key];
}
-(void)removeHeaderValueForKey:(NSString*)key
{
	if(self.mHeaders)
		[self.mHeaders removeObjectForKey:key];
}
-(NSString*)headerJson
{
	NSError* error;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.mHeaders options:0 error:&error];
	if(error)
		return nil;
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark -
#pragma mark Attachment scope
#pragma mark -

-(void)addAttachment:(SendgridAttachment*)attachment
{
    if(self.mAttachments == nil)
        self.mAttachments = [[NSMutableArray alloc] init];
	[self.mAttachments addObject:attachment];
}
-(SendgridAttachment*)removeAttachmentWithToken:(NSString*)token
{
	NSUInteger index = [self.mAttachments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if([obj isKindOfClass:[SendgridAttachment class]])
		{
			return [((SendgridAttachment*)obj).token isEqualToString:token];
		}else
		{
			return NO;
		}
	}];
	if(index > 0 && index < self.mAttachments.count)
	{
		SendgridAttachment* at = [self.mAttachments objectAtIndex:index];
		[self.mAttachments removeObject:at];
		return at;
	}
	return nil;
}
-(void)updateAttachment:(SendgridAttachment*)attachment
{
	NSUInteger index = [self.mAttachments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if([obj isKindOfClass:[SendgridAttachment class]])
		{
			return [((SendgridAttachment*)obj).token isEqualToString:attachment.token];
		}else
		{
			return NO;
		}
	}];
	if(index > 0 && index < self.mAttachments.count)
	{
		[self.mAttachments replaceObjectAtIndex:index withObject:attachment];
	}
}
-(NSArray*)inlineAttachments
{
	return [self.mAttachments filteredArrayUsingPredicate:[NSPredicate
														   predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		if([evaluatedObject isKindOfClass:[SendgridAttachment class]])
		{
			return ((SendgridAttachment*)evaluatedObject).isInline;
		}else
		{
			return NO;
		}
	}]];
}

#pragma mark -
#pragma mark Utils
#pragma mark -

-(id)initWithJson:(NSString*)json
{
	self = [super init];
	if(self)
	{
		NSError* error;
		NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
															 options:NSJSONReadingAllowFragments
															   error:&error];
		if(dict)
		{
			[self loadDictionary:dict];
		}
	}
	return self;
}

-(NSDictionary*)toDictionary
{
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:(self.fromEmail == nil?@"":self.fromEmail) forKey:@"fromEmail"];
	[dict setObject:(self.fromName == nil?@"":self.fromName) forKey:@"fromName"];
	[dict setObject:(self.emailToReplay == nil?@"":self.emailToReplay) forKey:@"emailToReply"];
	if(self.toList)[dict setObject:self.toList forKey:@"toList"];
	if(self.smtpApiOptions)[dict setObject:self.smtpApiOptions forKey:@"smtpapi"];
	if(self.headers)[dict setObject:self.headers forKey:@"headers"];
	[dict setObject:(self.subject == nil?@"":self.subject) forKey:@"subject"];
	[dict setObject:(self.htmlBody == nil?@"":self.htmlBody) forKey:@"htmlBody"];
	[dict setObject:(self.simpleTextBody == nil?@"":self.simpleTextBody) forKey:@"simpleTextBody"];
	
	return dict;
}

-(void)loadDictionary:(NSDictionary*)dict
{
	_fromEmail = [dict objectForKey:@"fromEmail"];
	_fromName = [dict objectForKey:@"fromName"];
	_emailToReplay = [dict objectForKey:@"emailToReply"];
	id temp = [dict objectForKey:@"smtpapi"];
	if(temp) self.smtpApiOptions = [[SendgridSmtpOptions alloc] initWithJson:temp];
	NSArray* toList = [dict objectForKey:@"toList"];
	if(toList)
	{
		for (NSDictionary* d in toList) {
			[self addTo:[d objectForKey:@"Email"] withName:[d objectForKey:@"Name"]];
		}
	}
	self.subject = [dict objectForKey:@"subject"];
	self.htmlBody = [dict objectForKey:@"htmlBody"];
	self.simpleTextBody = [dict objectForKey:@"simpleTextBody"];
	self.mHeaders = [dict objectForKey:@"headers"];
}

- (NSString *)toJson
{
	NSError* error;
	NSData* stringData = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
	if(error)
		return nil;
	return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

#pragma mark -
#pragma mark Getters
#pragma mark -

-(NSArray*)toList
{
	return [NSArray arrayWithArray:self.mToList];
}

-(NSArray*)attachments
{
	return [NSArray arrayWithArray:self.mAttachments];
}

-(NSDictionary*)headers
{
	return [NSDictionary dictionaryWithDictionary:self.mHeaders];
}

@end
