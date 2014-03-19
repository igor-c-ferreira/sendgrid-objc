//
//  SendgridSmtpOptions.h
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import <Foundation/Foundation.h>
#import "SendgridFilter.h"

/*!
@abstract	Model to retrieve the Sendgrid SMTP options
*/
@interface SendgridSmtpOptions : NSObject

@property (nonatomic, readonly) NSArray* toList;
@property (nonatomic, readonly) NSDictionary* substitutionKeys;
@property (nonatomic, readonly) NSArray* sections;
@property (nonatomic, readonly) NSArray* categories;
@property (nonatomic, readonly) NSDictionary* uniqueArgs;
@property (nonatomic, readonly) NSArray* filters;

#pragma mark -
#pragma mark To block
#pragma mark -
/*!
@abstract	Add a to to the options (It is used to complete the tags)
@param	email	Email of the to
@param	name	Name of the to (Optional)
*/
-(void)addTo:(NSString*)email withName:(NSString*)name;
/*!
@abstract	Remove a to from the options
@param	email	Email that will be removed
*/
-(void)removeTo:(NSString*)email;

#pragma mark -
#pragma mark Subs area (http://sendgrid.com/docs/API_Reference/SMTP_API/substitution_tags.html)
#pragma mark -

/*!
@abstract	Set a sub value for a specfic sub key
@discussion	The email informed need to be in the to list.
@param	value	Value that will be associated to that sub
@param	key		Key of that value
@param	email	Email that the value will be associated to
*/
-(void)setSubstitutionValue:(NSString*)value forKey:(NSString*)key onEmail:(NSString*)email;

/*!
@abstract	Get a sub value
@discussion	The email informed need to be in the to list.
@param	key		Key of that value
@param	email	Email that the value will be associated to
@return	The value for that key. Or nil, if the email is not in the to list
*/
-(NSString*)getSubstitutionValueForKey:(NSString*)key onEmail:(NSString*)email;
/*!
@abstract	Add a key to the sub list. Associating an empty value for the emails in the to list
@param	key	The key that will be generated
*/
-(void)addSubstitutionKey:(NSString*)key;
/*!
@abstract	Retrieve all the values for a specific sub key
@param	key	Sub key
@return	All the values for that key
*/
-(NSArray*)substitutionValuesForKey:(NSString*)key;
/*!
@abstract	Remove all the values of a specific sub key
@param	key	Key that will be removed
*/
-(void)removeSubstitutionValuesWithKey:(NSString*)key;

#pragma mark -
#pragma mark Sections area (http://sendgrid.com/docs/API_Reference/SMTP_API/section_tags.html)
#pragma mark -

/*!
@abstract	Add a section for the options
@param	section	Section title
@param	value	Section value
*/
-(void)addSection:(NSString*)section withValue:(NSString*)value;
/*!
@abstract	Remove a section from the options
@param	section Section that will be removed
*/
-(void)removeSection:(NSString*)section;

#pragma mark -
#pragma mark Category area (http://sendgrid.com/docs/API_Reference/SMTP_API/categories.html)
#pragma mark -

/*!
@abstract	Add a category for the options
@param	category	Category that will be created
*/
-(void)addCategory:(NSString*)category;
/*!
@abstract	Remove a category from the options
@param	category	Category that will be removed
*/
-(void)removeCategory:(NSString*)category;

#pragma mark -
#pragma mark Unique args area (http://sendgrid.com/docs/API_Reference/SMTP_API/unique_arguments.html)
#pragma mark -

/*!
@abstract	Add an unique arg for the options
@param	arg		Argument title
@param	value	Argument value
*/
-(void)addUniqueArg:(NSString*)arg withValue:(NSString*)value;
/*!
@abstract	Remove an argument from the options
@param	arg	Title of the argument that will be removed
*/
-(void)removeUniqueArg:(NSString*)arg;

#pragma mark -
#pragma mark Filter area (http://sendgrid.com/docs/API_Reference/SMTP_API/apps.html)
#pragma mark -

/*!
@abstract	Add a filter (app) to the options
@param	filter	Filter that will be added
*/
-(void)addFilter:(SendgridFilter*)filter;
/*!
@abstract	Get the filter informations (or nil if the option don't have the filter of that type)
@param	type	Type of the filter
@return	The filter information
*/
-(SendgridFilter*)filterOfType:(NSString*)type;
/*!
@abstract	Remove a filter from the options
@param	type	Type of the filter that will be removed
*/
-(void)removeFilterOfType:(NSString*)type;

#pragma mark -
#pragma mark Utils
#pragma mark -
-(id)initWithJson:(NSString*)json;
-(NSString*)toJson;

@end
