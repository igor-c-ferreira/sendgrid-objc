//
//  SendgridFilters.m
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import "SendgridFilter.h"

@interface SendgridFilter()

@property (nonatomic, strong) NSMutableDictionary* options;
@property (nonatomic, strong) NSString* mType;

@end

@implementation SendgridFilter

#pragma mark -
#pragma mark Factory
#pragma mark -

+(instancetype)createBCCFilterEnabled:(BOOL)enabled withEmail:(NSString *)email
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"bcc"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:email forFilterSettings:@"email"];
	return filter;
}

+(instancetype)createBypassFilterEnabled:(BOOL)enabled
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"bypass_list_management"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	return filter;
}

+(instancetype)createClickTrackFilterEnabled:(BOOL)enabled
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"clicktrack"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	return filter;
}

+(instancetype)createDkimFilterWithDomain:(NSString *)domain usingFrom:(BOOL)useFrom
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"dkim"];
	[filter setObject:domain forFilterSettings:@"domain"];
	[filter setObject:[NSNumber numberWithBool:useFrom] forFilterSettings:@"use_from"];
	return filter;
}

+(instancetype)createDomainKeysFilterEnabled:(BOOL)enabled withDomain:(NSString *)domain sendingHeader:(BOOL)header
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"domainkeys"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:domain forFilterSettings:@"domain"];
	[filter setObject:[NSNumber numberWithBool:header] forFilterSettings:@"sender"];
	return filter;
}

+(instancetype)createFooterFilterEnabled:(BOOL)enabled withHTMLText:(NSString *)html andSimpleText:(NSString *)simple
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"footer"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:[html stringByReplacingOccurrencesOfString:@"\n" withString:@""] forFilterSettings:@"text/html"];
	[filter setObject:simple forFilterSettings:@"text/plain"];
	return filter;
}

+(instancetype)createForwardSpamFilterEnabled:(BOOL)enabled toEmail:(NSString *)email
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"forwardspam"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:email forFilterSettings:@"email"];
	return filter;
}

+(instancetype)createGAnalyticsFilterEnabled:(BOOL)enabled
								  withSource:(NSString *)source
									  medium:(NSString *)medium
										term:(NSString *)term
									 content:(NSString *)content
								 andCampaign:(NSString *)campaign
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"ganalytics"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:source forFilterSettings:@"utm_source"];
	[filter setObject:medium forFilterSettings:@"utm_medium"];
	[filter setObject:term forFilterSettings:@"utm_term"];
	[filter setObject:content forFilterSettings:@"utm_content"];
	[filter setObject:campaign forFilterSettings:@"utm_campaign"];
	return filter;
}

+(instancetype)createGravatarFilterEnabled:(BOOL)enabled
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"gravatar"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	return filter;
}

+(instancetype)createOpenTrackFitlerEnabled:(BOOL)enabled
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"opentrack"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	return filter;
}

+(instancetype)createSpamCheckFilterEnabled:(BOOL)enabled withMaxScore:(CGFloat)maxScore andUrl:(NSString*)url
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"spamcheck"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:[NSNumber numberWithFloat:maxScore] forFilterSettings:@"maxscore"];
	if(url && url.length > 0)
		[filter setObject:url forFilterSettings:@"url"];
	return filter;
}

+(instancetype)createSubscriptionTrackFilterEnabled:(BOOL)enabled
										   withHTML:(NSString*)html
										 simpleText:(NSString*)simple
											 andTag:(NSString*)tag
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"subscriptiontrack"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:[html stringByReplacingOccurrencesOfString:@"\n" withString:@""] forFilterSettings:@"text/html"];
	[filter setObject:simple forFilterSettings:@"text/plain"];
	if(tag && tag.length > 0)
		[filter setObject:tag forFilterSettings:@"replace"];
	return filter;
}

+(instancetype)createTemplateFilterEnabled:(BOOL)enabled withHtml:(NSString*)html
{
	SendgridFilter* filter = [[SendgridFilter alloc] initWithType:@"template"];
	[filter setObject:[NSNumber numberWithBool:enabled] forFilterSettings:@"enable"];
	[filter setObject:[html stringByReplacingOccurrencesOfString:@"\n" withString:@""] forFilterSettings:@"text/html"];
	return filter;
}

#pragma mark -
#pragma mark Filter initialization
#pragma mark -

-(id)init
{
	self = [super init];
	if(self)
	{
		[self startFilter];
	}
	return self;
}

-(id)initWithType:(NSString*)type
{
	self = [super init];
	if(self)
	{
		[self startFilter];
		self.mType = type;
	}
	return self;
}

-(id)initWithDicitionary:(NSDictionary*)dict
{
	self = [super init];
	if(self)
	{
		[self startFilter];
		[self loadDictInformation:dict];
	}
	return self;
}

-(id)initWithJson:(NSString*)json
{
	self = [super init];
	if(self)
	{
		[self startFilter];
		NSError* error;
		NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
															 options:NSJSONReadingAllowFragments
															   error:&error];
		if(!error)
			[self loadDictInformation:dict];
	}
	return self;
}

-(void)startFilter
{
	self.options = [[NSMutableDictionary alloc] init];
}

#pragma mark -
#pragma mark Setters
#pragma mark -

-(void)setObject:(id)obj forFilterSettings:(NSString*)settings
{
	[self.options setObject:obj forKey:settings];
}

-(void)setEnabled:(BOOL)enabled
{
	if([[self.mType lowercaseString] isEqualToString:@"dkim"])
		return;
	[self.options setObject:[NSNumber numberWithBool:enabled] forKey:@"enable"];
}

#pragma mark -
#pragma mark Getters
#pragma mark -

-(NSString *)type
{
	return self.mType;
}

-(NSDictionary *)settings
{
	return [NSDictionary dictionaryWithDictionary:self.options];
}

-(BOOL)enabled
{
	if([[self.mType lowercaseString] isEqualToString:@"dkim"])
		return true;
	else
	{
		NSNumber* item = [self.options objectForKey:@"enable"];
		if(item == nil)
			return false;
		else
			return [item boolValue];
	}
}

#pragma mark -
#pragma mark Utils
#pragma mark -

-(NSString*)toJson
{
	NSError* error;
	
	NSData* data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:&error];
	
	if(error) {
		return nil;
	} else {
		return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
}

-(void) loadDictInformation:(NSDictionary*)dict
{
	NSEnumerator* keys = [dict keyEnumerator];
	NSString* key = [keys nextObject];
	if(key)
	{
		id settings = [dict objectForKey:key];
		if(settings && [settings isKindOfClass:[NSDictionary class]])
		{
			self.mType = key;
			settings = [settings objectForKey:@"settings"];
			if(settings && [settings isKindOfClass:[NSDictionary class]])
				self.options = [NSMutableDictionary dictionaryWithDictionary:settings];
			else
				self.mType = nil;
		}
	}
}

-(NSDictionary*)toDictionary
{
	NSMutableDictionary* settings = [[NSMutableDictionary alloc] init];
	[settings setObject:self.options forKey:@"settings"];
	return settings;
}

@end
