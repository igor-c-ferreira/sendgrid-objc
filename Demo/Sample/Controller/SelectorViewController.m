//
//  SelectorViewController.m
//  Sample
//
//  Created by Igor Ferreira on 3/18/14.
//  Copyright (c) 2014 Igor Ferreira. All rights reserved.
//

#import "SelectorViewController.h"
#import "EmailViewController.h"

@interface SelectorViewController ()

@end

@implementation SelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)simpleEmailAction:(id)sender {
    EmailViewController* email = [[EmailViewController alloc] init];
    email.useSMTP = NO;
    [self.navigationController pushViewController:email animated:YES];
}

- (IBAction)emailWithSMTPAction:(id)sender {
    EmailViewController* email = [[EmailViewController alloc] init];
    email.useSMTP = YES;
    [self.navigationController pushViewController:email animated:YES];
}

@end
