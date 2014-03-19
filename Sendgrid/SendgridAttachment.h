//
//  SendgridAttachment.h
//
//  Created by Igor Ferreira on 3/14/14.
//  Contact: http://linkedin.com/in/igorcferreira
//

#import <Foundation/Foundation.h>

/*!
@abstract	Class created to be a holder of the attachment files
*/
@interface SendgridAttachment : NSObject

/*! @abstract Set if the attachment will be used as an inline */
@property (nonatomic, readonly) BOOL isInline;
/*! @abstract Tag used to register the attachment for the inline */
@property (nonatomic, readonly) NSString* inlineTag;
/*! @abstract The filename of the attachment */
@property (nonatomic, strong, readonly) NSString* fileName;
/*! @abstract The binary array that holds the attachment content */
@property (nonatomic, strong, readonly) NSData* binaryContent;
/*! @abstract Mime type of the attachment */
@property (nonatomic, strong, readonly) NSString* mimeType;
/*! @abstract ID Token of this file */
@property (nonatomic, strong) NSString* token;

#pragma mark -
#pragma mark Default file types initializer
#pragma mark -
/*!
@abstract   Create a PDF Attachment
@param  pdfFile The NSData with the content of the file
@param  name    The name of the file
@return PDF Attachment
*/
-(id)initPDFAttachmentWithData:(NSData*)pdfFile withName:(NSString*)name;
/*!
@abstract   Create a simple txt Attachment
@param  txtFile The NSData with the content of the file
@param  name    The name of the file
@return TXT Attachment
*/
-(id)initTXTAttachmentWithData:(NSData*)txtFile withName:(NSString*)name;
/*!
@abstract   Create a Rich text Attachment
@param  rtffile The NSData with the content of the file
@param  name    The name of the file
@return RTF Attachment
*/
-(id)initRTFAttachmentWithData:(NSData*)rtffile withName:(NSString*)name;
/*!
@abstract   Create a PNG Attachment that can be sent inline
@param  pngFile     The NSData with the content of the file
@param  name        The name of the file
@param  isInline    A flag that indicates if the attachment will be sent as inline or not
@return PNG Attachment
*/
-(id)initPNGAttachmentWithData:(NSData*)pngFile withName:(NSString*)name asInline:(BOOL)isInline;
/*!
@abstract   Create a PNG Attachment that can be sent inline
@param  pngFile     The UIImage with the content of the file
@param  name        The name of the file
@param  isInline    A flag that indicates if the attachment will be sent as inline or not
@return PNG Attachment
*/
-(id)initPNGAttachmentWithImage:(UIImage*)pngFile withName:(NSString*)name asInline:(BOOL)isInline;
/*!
@abstract   Create a JPG Attachment that can be sent inline
@param  jpgFile     The NSData with the content of the file
@param  name        The name of the file
@param  isInline    A flag that indicates if the attachment will be sent as inline or not
@return JPG Attachment
*/
-(id)initJPGAttachmentWithData:(NSData*)jpgFile withName:(NSString*)name asInline:(BOOL)isInline;
/*!
@abstract   Create a JPG Attachment that can be sent inline
@param  jpgFile     The UIImage with the content of the file
@param  name        The name of the file
@param  isInline    A flag that indicates if the attachment will be sent as inline or not
@return JPG Attachment
*/
-(id)initJPGAttachmentWithImage:(UIImage*)jpgFile withName:(NSString*)name asInline:(BOOL)isInline;

#pragma mark -
#pragma mark General initializer
#pragma mark -
/*!
@abstract	Initializer of the attachment
@param	data		The binary array of the content
@param	mimeType	The mime type of the file
@param	name		The file name
@param	isInline	A flag to indicate if the file will be used as inline
*/
-(id)initWithData:(NSData*)data forMimeType:(NSString*)mimeType withFileName:(NSString*)name asInline:(BOOL)isInline;

#pragma mark -
#pragma mark Setters
#pragma mark -
/*!
@abstract	Method to change the attached file name
@discussion	This method was created to data "protection"
@param	fileName	Name that will be set to the file
*/
-(NSString*)changeFileName:(NSString*)fileName;

@end
