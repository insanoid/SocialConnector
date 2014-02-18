//
//  SM_TWKit.m
//
//  Created by Karthikeya Udupa on 10/18/13.
//  Copyright (c) 2013 Karthikeya Udupa K M. All rights reserved.
//

#import "SM_TWKit.h"

@implementation SM_TWKit


NSString * const TwitterAccountErrorMessage = @"There are no Twitter accounts configured. You can add or create a Twitter account in Settings.";
NSString * const TwitterPostingError = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";

+ (instancetype)sharedInstance {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.class new];
    });
    return instance;
}


- (void)getTwitterAccountOnCompletion:(void (^)(ACAccount *))completionHandler {
  
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    if([store respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)]){
        [store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
            if(granted) {
                // Remember that twitterType was instantiated above
                NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
                
                // If there are no accounts, we need to pop up an alert
                if(twitterAccounts == nil || [twitterAccounts count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                                    message:TwitterAccountErrorMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                } else {
                    //Get the first account in the array
                    ACAccount *twitterAccount = [twitterAccounts objectAtIndex:0];
                    completionHandler(twitterAccount);
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                                message:TwitterAccountErrorMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
            completionHandler(nil);
        }];
    }
}

- (void)TwitterShareAction:(UIViewController *)baseViewController withContent:(NSString *)message url:(NSURL *)url andImage:(UIImage *)image withCompletionHandler:(void (^)(TWTweetComposeViewControllerResult result))completionHandler {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:message];
        
        if (image)
        {
            [tweetSheet addImage:image];
        }
        
        if (url)
        {
            [tweetSheet addURL:url];
        }
        [baseViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:TwitterPostingError
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    
}



@end
