//
//  GameSettingsViewController.m
//  GuessWord
//
//  Created by Karan Dhanu on 2012-11-22.
//  Copyright (c) 2012 TeamB. All rights reserved.
//

#import "GameSettingsViewController.h"
#import "GameInputOutput.h"
#import "GameViewController.h"
#include <SystemConfiguration/SystemConfiguration.h>

@interface GameSettingsViewController ()

@end

@implementation GameSettingsViewController

@synthesize username;
@synthesize password;
@synthesize connectedToData;
@synthesize rememberMeToggle;
@synthesize errorMessage;

bool hasDataConnection= NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doneEnterCredentials:(id)sender
{
    //1.download the file when user has done entering username and password
    //2. download the file from sever only if username and password is not bank
    //3. I need to find a to authenicate these usernames and passwords
    if(![username.text isEqualToString:@""])
    {
        //get the json file based on the username and password
        [GameInputOutput writeJsonToFile:@"http://chrishobbs.ca/groupb" forUsername:username.text forUserpassword:password.text remoteFilename:@"wordlist.json"];
        
    }
    if([self saveUserCredentials])
    {
        [self performSegueWithIdentifier:@"doneCredentials" sender:self];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self displayInternetConnectionStatus];
    
    //display the username, password
    username.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    password.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rememberCredentials:(id)sender
{
    if(rememberMeToggle.isOn)
    {
        
    }
    if(!rememberMeToggle.isOn)
    {
        
    }
}

- (void) displayInternetConnectionStatus
{
    hasDataConnection = [GameInputOutput isDataSourceAvailable];
    NSString * boolString = hasDataConnection ? @"Connected To Data" : @"No Data Connection";
    connectedToData.text = boolString;
    connectedToData.enabled = YES;
    if(hasDataConnection)
    {
        connectedToData.textColor =  [UIColor colorWithRed:0.10f green:0.53f blue:0.03f alpha:1.0f];
    }
    else
    {
        connectedToData.textColor =  [UIColor redColor];
    }
}

//http://stackoverflow.com/questions/782451/iphone-sdk-load-save-settings
- (BOOL) saveUserCredentials
{
    NSUserDefaults *userCredentials = [NSUserDefaults standardUserDefaults];
    bool saveCredentails = false;
    //only save credentials if user has remember me button to on
    if(rememberMeToggle.isOn)
    {
        
        if ((![username.text isEqualToString:@""]) && (![password.text isEqualToString:@""] && ![password.text isEqualToString:@"password"]))
        {
            [userCredentials setObject:username.text forKey:@"username"];
            [userCredentials setObject:password.text forKey:@"password"];
            return true;
        }
        else if ([username.text isEqualToString:@""] &&[password.text isEqualToString:@""])
        {
            username.text = @"";
            password.text = @"";
            [userCredentials setObject:username.text forKey:@"username"];
            [userCredentials setObject:password.text forKey:@"password"];
            return true;
        }
        else if([username.text isEqualToString:@""] ||[password.text isEqualToString:@""])
        {
            username.text = @"";
            password.text = @"";

            [userCredentials setObject:username.text forKey:@"username"];
            [userCredentials setObject:password.text forKey:@"password"];
            errorMessage.text = @"Invalid username or password";
            errorMessage.hidden = NO;
            return false;
        }
        
    }
    //do not save credentials
    else
    {
        username.text = @"";
        password.text = @"";
        [userCredentials setObject:username.text forKey:@"username"];
        [userCredentials setObject:password.text forKey:@"password"];
        return true;
    }
    return saveCredentails;
}

//-(void)saveSettings:(SharedData *)d{
    //settings=d;
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //[prefs setObject:settings.masterLocation forKey:@"masterLocation"];
    //[prefs setObject:settings.masterPort forKey:@"masterPort"];
    //[prefs setObject:settings.userName forKey:@"userName"];
    //[prefs setObject:settings.passWord forKey:@"passWord"];
    //[prefs setObject:settings.autoLogin forKey:@"autoLogin"];
//}

@end
