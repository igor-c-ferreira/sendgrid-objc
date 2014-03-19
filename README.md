# Sendgrid - Objective-C

This library allows you to quickly and easily send emails through SendGrid using Objective-C.

**Important:** This library requires [AFNetworking](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking) 2.0 or higher.

```objective-c
[[Sendgrid sharedInstance] configSendgridWithUser:@"user" andPassword:@"password"];

SendgridMessage* message = [[Sendgrid sharedInstance] createNewMessage];
[message addTo:@"Foo <foo@bar.com>"];
[message addTo:@"foo1@bar.com"];
[message addTo:@"foo2@bar.com" withName:@"Foo 2"];
message.subject = "subject goes here";
[message setFrom:@"Me <me@bar.com>"];
msg.simpleTextBody = @"hello world";   
msg.htmlBody = @"<h1>hello world!</h1>";
    
[[Sendgrid sharedInstance] sendMessage:message withSuccess:nil andError:nil];
```

## Install via Source

    1. Clone this repository.
    2. Copy the Sendgrid folder to your project.
    3. Import both Sendgrid and AFNetworking in your project

## Usage

To begin using this library, config the SendGrid singleton with your SendGrid credentials
```objective-c
[[Sendgrid sharedInstance] configSendgridWithUser:@"user" andPassword:@"password"];
```

Create a new message
```objective-c
SendgridMessage* message = [[Sendgrid sharedInstance] createNewMessage];
```

Customize the parameters of your email message.
```objective-c
[message addTo:@"foo@bar.com"];
message.subject = "subject goes here";
[message setFrom:@"Me <me@bar.com>"];
msg.simpleTextBody = @"hello world";   
msg.htmlBody = @"<h1>hello world!</h1>";
```
For the full list of available parameters, check out the [Docs](http://sendgrid.com/docs/API_Reference/Web_API/mail.html)

### Adding To addresses

You can add a to by the addTo method

```objective-c
[message addTo:@"foo@bar.com"];
```

**Note** At least one to must be set.

### Adding a file attachment
You can add any file to your message using the SendgridAttachment class

```objective-c
SendgridAttachment* file = [[SendgridAttachment alloc] initWithData:data forMimeType:@"application/msword" withFileName:@"document.doc" asInline:NO];
[message addAttachment:file];
```

**Using the attachment factory**
```objective-c
SendgridAttachment* pdfFile = [SendgridAttachment createPDFAttachmentWithData:pdfData withName:@"document.pdf"];
[message addAttachment:pdfFile];
```

### Adding an image attachment
You can add an image attachment to your email message.

```objective-c
[message addAttachment:[createPNGAttachmentWithImage:self.photo withName:@"image.png" asInline:YES]];
```

**Displaying attached image inline**
```objective-c
SendgridAttachment* image = [SendgridAttachment createPNGAttachmentWithImage:self.photo withName:@"image.png" asInline:YES];
[message addAttachment:image];
message.htmlBody = [NSString stringWithFormat:@"<img src =\"%@\"><h1>hello world</h1>",image.inlineTag];
```

### Using the SMTP API

You can use the [SMTP API](http://sendgrid.com/docs/API_Reference/SMTP_API/) by using the SendgridSmtpOptions class

**Associating the options to the message**
```objective-c
SendgridSmtpOptions* options = [[SendgridSmtpOptions alloc] init];
SendgridMessage* message = [[Sendgrid sharedInstance] createNewMessageWithSmtpOptions:options];
```

**Adding sub values**
```objective-c
[message addTo:@"foo@bar.com"];
[options setSubstitutionValue:@"Foo" forKey:@"%name%" onEmail:@"foo@bar.com"];
```

**Adding roles**
```objective-c
[options setSubstitutionValue:@"%tester%" forKey:@"%role%" onEmail:@"foo@bar.com"];
```

**Adding sections**
```objective-c
[options addSection:@"%tester%" withValue:@"Hello tester %name%"];
```

**Adding Filters**
```objective-c
[options addFilter:[SendgridFilter createClickTrackFilterEnabled:YES]];
```

**Adding Categories**
```objective-c
[options addCategory:@"billing_notifications"];
```

**Adding Unique Arguments**
```objective-c
[options addUniqueArg:@"customerAccountNumber" withValue:@"55555"];
[options addUniqueArg:@"activationAttempt" withValue:@"1"];
```

## Documentation

### Project

This project documentation was generated using the [AppleDoc](https://github.com/tomaz/appledoc) project.
To install it to your XCode, install the AppleDoc and run the Documentation Target.

### Docset

You can find the Sendgrid.docset into the documentation folder

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

