//
//  MainViewController.m
//  Sample
//
//  Created by Igor Ferreira on 3/18/14.
//  Copyright (c) 2014 Igor Ferreira. All rights reserved.
//

#import "MainViewController.h"
#import "Sendgrid.h"
#import "SelectorViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *user;

@end

@implementation MainViewController

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
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)continueAction:(id)sender
{
    [[Sendgrid sharedInstance] configSendgridWithUser:self.user.text andPassword:self.password.text];
    [self.navigationController pushViewController:[[SelectorViewController alloc] init] animated:YES];
}

@end
