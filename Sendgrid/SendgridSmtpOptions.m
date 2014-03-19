//
//  SendgridSmtpOptions.m
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import "SendgridSmtpOptions.h"
#import "Sendgrid.h"

@interface SendgridSmtpOptions()

@property (nonatomic, strong) NSMutableArray* mCategories;
@property (nonatomic, strong) NSMutableDictionary* mUniqueArgs;
@property (nonatomic, strong) NSMutableDictionary* mFilters;
@property (nonatomic, strong) NSMutableDictionary* mSections;
@property (nonatomic, strong) NSMutableArray* mToList;
@property (nonatomic, strong) NSMutableDictionary* mSubs;

@end

@implementation SendgridSmtpOptions

#pragma mark -
#pragma mark To list control
#pragma mark -
-(void)addTo:(NSString*)email withName:(NSString*)name
{
	if(self.mToList == nil)
	{
		self.mToList = [[NSMutableArray alloc] init];
		[self.mToList addObject:@{@"email":email,@"name":name}];
	} else
	{
		NSUInteger index = [self.mToList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			if([obj isKindOfClass:[NSDictionary class]])
			{
				return [email isEqualToString:[((NSDictionary*)obj) objectForKey:@"email"]];
			}
			else
				return NO;
		}];
		if(index == NSNotFound)
		{
			[self.mToList addObject:@{@"email":email,@"name":name}];
			if(self.mSubs)
			{
				NSEnumerator *keyEnumerator = [self.mSubs keyEnumerator];
				NSString* key;
				while (key = [keyEnumerator nextObject])
				{
					[self setSubstitutionValue:@"" forKey:key onEmail:email];
				}
			}
		}
	}
}
-(void)removeTo:(NSString*)email
{
	NSUInteger index = [self.mToList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if([obj isKindOfClass:[NSDictionary class]])
		{
			return [email isEqualToString:[((NSDictionary*)obj) objectForKey:@"email"]];
		}
		else
			return NO;
	}];
	if(index != NSNotFound)
	{
		[self.mToList removeObjectAtIndex:index];
		if(self.mSubs)
		{
			NSEnumerator *keyEnumerator = [self.mSubs keyEnumerator];
			NSString* key;
			while (key = [keyEnumerator nextObject])
			{
				NSMutableArray* values = [self.mSubs objectForKey:key];
				if(index < values.count)
					[values removeObjectAtIndex:index];
			}
		}
	}
}

#pragma mark -
#pragma mark Subs list control
#pragma mark -

-(void)setSubstitutionValue:(NSString*)value forKey:(NSString*)key onEmail:(NSString*)email
{
	NSUInteger index = [self.mToList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if([obj isKindOfClass:[NSDictionary class]])
		{
			return [email isEqualToString:[((NSDictionary*)obj) objectForKey:@"email"]];
		}
		else
			return NO;
	}];
	if(index == NSNotFound)
		return;
	if(self.mSubs == nil)
	{
		self.mSubs = [[NSMutableDictionary alloc] init];
		NSMutableArray* values = [[NSMutableArray alloc] init];
		for(int i = 0; i < self.mToList.count; ++i)
		{
			if(i != index)
				[values addObject:@""];
			else
				[values addObject:value];
		}
		return;
	}
	
	NSMutableArray* values = [self.mSubs objectForKey:key];
	if(values.count > index)
	{
		[values replaceObjectAtIndex:index withObject:value];
	}else
	{
		[values addObject:value];
	}
	
}
-(NSString*)getSubstitutionValueForKey:(NSString*)key onEmail:(NSString*)email
{
	if(self.mSubs == nil)
		return nil;
	NSMutableArray* array = [self.mSubs objectForKey:key];
	if(array == nil || array.count == 0)
		return nil;
	NSUInteger index = [self.mToList indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if([obj isKindOfClass:[NSDictionary class]])
		{
			return [email isEqualToString:[((NSDictionary*)obj) objectForKey:@"email"]];
		}
		else
			return NO;
	}];
	if(index == NSNotFound || index >= array.count)
		return nil;
	return [array objectAtIndex:index];
}
-(void)addSubstitutionKey:(NSString*)key
{
	if(self.mSubs == nil)
	{
		self.mSubs = [[NSMutableDictionary alloc] init];
	}
	NSMutableArray* values = [[NSMutableArray alloc] init];
	int i = 0;
	while (i < self.mToList.count) {
		[values addObject:@""];
		i++;
	}
	[self.mSubs setObject:values forKey:key];
}
-(NSArray*)substitutionValuesForKey:(NSString*)key
{
	if(self.mSubs == nil) return nil;
	NSMutableArray* values = [self.mSubs objectForKey:key];
	if(values == nil) return nil;
	return [NSArray arrayWithArray:values];
}
-(void)removeSubstitutionValuesWithKey:(NSString*)key
{
	if(self.mSubs)
		[self.mSubs removeObjectForKey:key];
}

#pragma mark -
#pragma mark Section list control
#pragma mark -

-(void)addSection:(NSString*)section withValue:(NSString*)value
{
	if(self.mSections == nil)
	{
		self.mSections = [[NSMutableDictionary alloc] init];
	}
	[self.mSections setObject:value forKey:section];
}
-(void)removeSection:(NSString*)section
{
	if(self.mSections)
		[self.mSections removeObjectForKey:section];
}

#pragma mark -
#pragma mark Category list control
#pragma mark -

-(void)addCategory:(NSString*)category
{
	if(self.mCategories == nil) {
		self.mCategories = [[NSMutableArray alloc] init];
		[self.mCategories addObject:category];
	} else {
		NSUInteger integer = [self.mCategories indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			if([obj isKindOfClass:[NSString class]])
				return [((NSString*)obj) isEqualToString:category];
			return NO;
		}];
		if(integer == NSNotFound)
			[self.mCategories addObject:category];
	}
}
-(void)removeCategory:(NSString*)category
{
	NSUInteger integer = [self.mCategories indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if([obj isKindOfClass:[NSString class]])
			return [((NSString*)obj) isEqualToString:category];
		return NO;
	}];
	if(integer < self.mCategories.count)
		[self.mCategories removeObjectAtIndex:integer];
}

#pragma mark -
#pragma mark Unique args list control
#pragma mark -

-(void)addUniqueArg:(NSString*)arg withValue:(NSString*)value
{
	if(self.mUniqueArgs == nil) {
		self.mUniqueArgs = [[NSMutableDictionary alloc] init];
	}
	
	[self.mUniqueArgs setObject:value forKey:arg];
}
-(void)removeUniqueArg:(NSString*)arg
{
	if(self.uniqueArgs)
		[self.mUniqueArgs removeObjectForKey:arg];
}

#pragma mark -
#pragma mark Filter list control
#pragma mark -

-(void)addFilter:(SendgridFilter*)filter
{
	if(self.mFilters == nil) {
		self.mFilters = [[NSMutableDictionary alloc] init];
	}
	[self.mFilters setObject:filter forKey:filter.type];
}
-(SendgridFilter*)filterOfType:(NSString*)type
{
	if(self.mFilters == nil)
		return nil;
	return [self.mFilters objectForKey:type];
}
-(void)removeFilterOfType:(NSString*)type
{
	if(self.mFilters)
		[self.mFilters removeObjectForKey:type];
}

#pragma mark -
#pragma mark Utils
#pragma mark -

-(id)initWithJson:(NSString *)json
{
	self = [super init];
	if(self) {
		NSError* error;
		NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
															 options:NSJSONReadingAllowFragments
															   error:&error];
		if(!error)
		{
			[self loadDictionaryInformation:dict];
		}
	}
	return self;
}

-(void)loadDictionaryInformation:(NSDictionary*)dict
{
	id temp = nil;
	temp = [dict objectForKey:@"tos"];
	
	if(temp && [temp isKindOfClass:[NSArray class]])
	{
		NSArray* tos = (NSArray*)temp;
		for(NSString* to in tos)
		{
			NSArray* fields = [Sendgrid filterEmailAndNameFromField:to];
			[self addTo:[fields objectAtIndex:0] withName:[fields objectAtIndex:1]];
		}
	}
	
	temp = [dict objectForKey:@"sub"];
	if(temp && [temp isKindOfClass:[NSDictionary class]])
	{
		self.mSubs = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)temp];
	}
	
	temp = [dict objectForKey:@"section"];
	if(temp && [temp isKindOfClass:[NSDictionary class]])
	{
		self.mSections = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)temp];
	}
	
	temp = [dict objectForKey:@"category"];
	if(temp && [temp isKindOfClass:[NSArray class]])
	{
		self.mCategories = [NSMutableArray arrayWithArray:(NSArray*)temp];
	}
	
	temp = [dict objectForKey:@"unique_args"];
	if(temp && [temp isKindOfClass:[NSDictionary class]])
	{
		self.mUniqueArgs = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)temp];
	}
	
	temp = [dict objectForKey:@"filters"];
	if(temp && [temp isKindOfClass:[NSDictionary class]])
	{
		self.mFilters = nil;
		NSDictionary* tDict = (NSDictionary*)temp;
		NSEnumerator *keyEnumerator = [tDict keyEnumerator];
		NSString* key;
		while (key = [keyEnumerator nextObject])
		{
			temp = [tDict objectForKey:key];
			if(temp && [temp isKindOfClass:[NSDictionary class]])
				[self addFilter:[[SendgridFilter alloc] initWithDicitionary:(NSDictionary*)temp]];
		}
	}
}

-(NSDictionary*)toDictionary
{
	NSMutableDictionary* holder = [[NSMutableDictionary alloc] init];
	
	if(self.mToList)
	{
		NSMutableArray* tos = [[NSMutableArray alloc] init];
		for(NSDictionary* dict in self.mToList)
		{
			[tos addObject:[NSString stringWithFormat:@"%@ <%@>", [dict objectForKey:@"name"], [dict objectForKey:@"email"]]];
		}
		[holder setObject:tos forKey:@"tos"];
	}
	
	if(self.mSubs)
	{
		[holder setObject:self.mSubs forKey:@"sub"];
	}
	
	if(self.mSections)
	{
		[holder setObject:self.mSections forKey:@"section"];
	}
	
	if(self.mCategories)
	{
		[holder setObject:self.mCategories forKey:@"category"];
	}
	
	if(self.mUniqueArgs)
	{
		[holder setObject:self.mUniqueArgs forKey:@"unique_args"];
	}
	
	if(self.mFilters)
	{
		NSMutableDictionary* filters = [[NSMutableDictionary alloc] init];
		NSEnumerator *keyEnumerator = [self.mFilters keyEnumerator];
		NSString* key;
		while (key = [keyEnumerator nextObject])
		{
			[filters setObject:[[self.mFilters objectForKey:key] toDictionary] forKey:key];
		}
		[holder setObject:filters forKey:@"filters"];
	}
	
	return [NSDictionary dictionaryWithDictionary:holder];
}

-(NSString*)toJson
{
	NSDictionary* content = [self toDictionary];
	NSError* error;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:content options:0 error:&error];
	if(error)
		return nil;
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
