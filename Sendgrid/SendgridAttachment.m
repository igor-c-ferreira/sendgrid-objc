//
//  SendgridAttachment.m
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import "SendgridAttachment.h"

#define MAX_FILE_SIZE (7 * 1024 * 1024) //The Sendgrid API have a 7MB file size limit

@interface SendgridAttachment()

@end

@implementation SendgridAttachment

-(id)initPDFAttachmentWithData:(NSData*)pdfFile withName:(NSString*)name
{
	return [self initWithData:pdfFile forMimeType:@"application/pdf" withFileName:name asInline:NO];
}
-(id)initTXTAttachmentWithData:(NSData*)txtFile withName:(NSString*)name
{
	return [self initWithData:txtFile forMimeType:@"text/plain" withFileName:name asInline:NO];
}
-(id)initRTFAttachmentWithData:(NSData*)rtffile withName:(NSString*)name
{
	return [self initWithData:rtffile forMimeType:@"text/rtf" withFileName:name asInline:NO];
}
-(id)initPNGAttachmentWithData:(NSData*)pngFile withName:(NSString*)name asInline:(BOOL)isInline
{
	return [self initWithData:pngFile forMimeType:@"image/png" withFileName:name asInline:isInline];
}
-(id)initPNGAttachmentWithImage:(UIImage*)pngFile withName:(NSString*)name asInline:(BOOL)isInline
{
	return [self initWithData:UIImagePNGRepresentation(pngFile) forMimeType:@"image/png" withFileName:name asInline:isInline];
}
-(id)initJPGAttachmentWithData:(NSData*)jpgFile withName:(NSString*)name asInline:(BOOL)isInline
{
	return [self initWithData:jpgFile forMimeType:@"image/jpg" withFileName:name asInline:isInline];
}
-(id)initJPGAttachmentWithImage:(UIImage*)jpgFile withName:(NSString*)name asInline:(BOOL)isInline
{
	return [self initWithData:UIImageJPEGRepresentation(jpgFile, 1.0) forMimeType:@"image/jpg" withFileName:name asInline:isInline];
}

-(id)initWithData:(NSData*)data forMimeType:(NSString*)mimeType withFileName:(NSString*)name asInline:(BOOL)isInline
{
	NSError* error;
	NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"^[\\w,\\s\\-_]+\\.[A-Za-z]{3}$"
																	  options:NSRegularExpressionAllowCommentsAndWhitespace
																		error:&error];
	if([regex rangeOfFirstMatchInString:name options:0 range:NSMakeRange(0, name.length)].location == NSNotFound)
	{
		return nil;
	}
	
	if(data.length == 0 || data.length > MAX_FILE_SIZE)
		return nil;
	
	
	self = [super init];
	if(self)
	{
        _isInline = isInline;
		_binaryContent = data;
		_mimeType = mimeType;
		[self changeFileName:name];
		self.token = self.fileName;
	}
	return self;
}

-(NSString*)changeFileName:(NSString *)fileName
{
	NSError* error;
	NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"^[\\w,\\s\\-_]+\\.[A-Za-z]{3}$"
																	  options:NSRegularExpressionAllowCommentsAndWhitespace
																		error:&error];
	if([regex rangeOfFirstMatchInString:fileName options:0 range:NSMakeRange(0, fileName.length)].location != NSNotFound)
	{
		_fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		if(self.isInline) {
			_inlineTag = [NSString stringWithFormat:@"cid:%@",self.fileName];
		} else {
			_inlineTag = nil;
		}
	}
	return _inlineTag;
}

@end
