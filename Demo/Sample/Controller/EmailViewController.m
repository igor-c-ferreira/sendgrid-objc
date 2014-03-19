//
//  SimpleEmailViewController.m
//  Sample
//
//  Created by Igor Ferreira on 3/18/14.
//  Copyright (c) 2014 Igor Ferreira. All rights reserved.
//

#import "EmailViewController.h"
#import "Sendgrid.h"

@interface EmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *from;
@property (weak, nonatomic) IBOutlet UITextField *to;
@property (weak, nonatomic) IBOutlet UITextView *message;

@end

@implementation EmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.title = @"Subject: Message";
    UIBarButtonItem* send = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendEmail:)];
    [self.navigationItem setRightBarButtonItem:send];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)sendEmail:(id)sender
{
    [self.view becomeFirstResponder];
    [self.to resignFirstResponder];
    [self.from resignFirstResponder];
    [self.message resignFirstResponder];
    
    if(![Sendgrid isValidEmail:self.to.text] || ![Sendgrid isValidEmail:self.from.text])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(self.useSMTP)
        [self sendSmtpEmail];
    else
        [self sendSimpleEmail];
}

-(void)sendSimpleEmail
{
    // 1 - Create the message
    SendgridMessage* message = [[Sendgrid sharedInstance] createNewMessage];
    
    // 2 - Set the from e the to
    [message setFrom:self.from.text];
    [message addTo:self.to.text];
    
    // 3 - Set a subject
    message.subject = @"Sendgrid";
    
    // 4 - Set the messages
    [message setHtmlBody:self.message.text];        //HTML format
    [message setSimpleTextBody:self.message.text];  //Simple text format
    
    [self sendMessage:message];
}

-(void)sendSmtpEmail
{
    //The Sendgrid API have a method to split the "name <email@host.com>" input format
    NSArray* toComponents = [Sendgrid filterEmailAndNameFromField:self.to.text];
    NSString* toEmail = [toComponents objectAtIndex:0];
    
    // 1 - Create the SMTP API options object
    SendgridSmtpOptions* options = [[SendgridSmtpOptions alloc] init];
    
    // 2 - Add a filter to track the email click
    [options addFilter:[SendgridFilter createClickTrackFilterEnabled:YES]];
    
    // 3 - Create a sub tag for the name
	[options addSubstitutionKey:@"%name%"];
    
    // 4 - Create a sub tag for the role
	[options addSubstitutionKey:@"%role%"];
    
    // 5 - Add a section to perform in block
	[options addSection:@"%tester%" withValue:@"Tester %name%"];
    
    // 6 - Add a category to the email (statistics)
	[options addCategory:@"Test"];
    
    // 7 - Add a unique arg to the email
	[options addUniqueArg:@"Environment" withValue:@"Test"];
    
    // 8 - Create the message with the options
    SendgridMessage* message = [[Sendgrid sharedInstance] createNewMessageWithSmtpOptions:options];
    
    // 9 - Set a subject
    message.subject = @"Sendgrid";
    
    // 10 - Add a from and a to
    [message setFrom:self.from.text];
    [message addTo:self.to.text];
    
    // 11 - Config the value for the %name% sub tag
    [options setSubstitutionValue:@"Foo" forKey:@"%name%" onEmail:toEmail];
    
	// 12 - Config the value for the %role% sub tag
    [options setSubstitutionValue:@"%tester%" forKey:@"%role%" onEmail:toEmail];
    
    // 13 - Add a rtf file as attachment
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"rtf"];
    NSData* rtfData = [NSData dataWithContentsOfFile:filePath];
    [message addAttachment:[[SendgridAttachment alloc] initRTFAttachmentWithData:rtfData withName:@"file.rtf"]];
    
    // 14 - Add a JPG as inline attachment
    UIImage* jpegData = [UIImage imageNamed:@"siteBanner.jpg"];
    SendgridAttachment* image = [[SendgridAttachment alloc] initJPGAttachmentWithImage:jpegData withName:@"pog.jpg" asInline:YES];
    [message addAttachment:image];
    
    // 15 - Edit the message to use the %role% sub tag and the inline attachment
    NSString* htmlMessage = @"<p>Hello %role%</p>";
    htmlMessage = [htmlMessage stringByAppendingString:self.message.text];
    htmlMessage = [htmlMessage stringByAppendingFormat:@"<br/><img src=\"%@\">",image.inlineTag];
    [message setHtmlBody:htmlMessage];
    
    // 16 - Edit the simple message to use the %role% sub tag
    NSString* simpleMessage = @"Hello %role%\n";
    simpleMessage = [simpleMessage stringByAppendingString:self.message.text];
    [message setSimpleTextBody:simpleMessage];
    
    [self sendMessage:message];
}

-(void)sendMessage:(SendgridMessage*)message
{
    [[Sendgrid sharedInstance] sendMessage:message withSuccess:^(NSString *message) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } andError:^(NSString *message, NSArray *errors) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
