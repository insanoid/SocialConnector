//
//  SM_TWKit.h
//
//  Created by Karthikeya Udupa on 10/18/13.
//  Copyright (c) 2013 Karthikeya Udupa K M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface SM_TWKit : NSObject


+ (instancetype)sharedInstance;

- (void)TwitterShareAction:(UIViewController *)baseViewController withContent:(NSString *)message url:(NSURL *)url andImage:(UIImage *)image withCompletionHandler:(void (^)(TWTweetComposeViewControllerResult result))completionHandler;

@end
