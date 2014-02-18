//
//  ViewController.m
//  SMSocialConnector
//
//  Created by Karthik on 18/02/2014.
//
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SM_FBKit sharedInstance] openSession:^(NSError *error) {
        if(error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"An error occured while connecting to Facebook, please try again."] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return ;
        }else{
            
            
            NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"testapp",@"name",
                                                              @"http://www.testapp.com",@"link", nil],
                                    nil];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:actionLinks options:0 error:nil];
            NSString* actionLinksStr = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Testing Facebook", @"name",
                                           @"Testing facebook caption.", @"caption",
                                           @"A sample facebook application to test facebook caption.", @"description",
                                           @"http://www.google.com", @"link",
                                           @"https://github.global.ssl.fastly.net/images/modules/logos_page/GitHub-Mark.png", @"picture",
                                           actionLinksStr, @"actions",
                                           nil];
            [[SM_FBKit sharedInstance] postToWall:params withCompletion:^(NSError *error_post) {
                if(error_post){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"An error occured while posting to facebook."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.animationType = MBProgressHUDAnimationZoom;
                    HUD.delegate = (id<MBProgressHUDDelegate>)self;
                    HUD.labelText = @"Posteado";
                    
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:3];
                });
            }];
            
        }
    }];
    
}

- (IBAction)twitterAction:(id)sender {
    
    [[SM_TWKit sharedInstance] TwitterShareAction:self.navigationController withContent:@"Twitter message string goes here can add image and urls" url:nil andImage:nil withCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
        if(result!=TWTweetComposeViewControllerResultDone){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"An error occured while posting to twitter."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.animationType = MBProgressHUDAnimationZoom;
                HUD.delegate = (id<MBProgressHUDDelegate>)self;
                HUD.labelText = @"Twiteado";
                
                [HUD show:YES];
                [HUD hide:YES afterDelay:3];
            });
        }
    }];
    
}

- (IBAction)locationAction:(id)sender {
    
    [SM_LocationKit getBallParkLocationOnSuccess:^(CLLocation *loc) {
        NSLog(@"-- %@", loc);
    } onFailure:^(NSInteger failCode) {
        NSLog(@"-- Failed:%@",failCode==0?@"Authorization Failure":@"Timeout Failure");
    }
     ];
    
    [SM_LocationKit getPlacemarkLocationOnSuccess:^(CLPlacemark *place) {
        NSLog(@"-- %@", place);
    } onFailure:^(NSInteger failCode) {
        NSLog(@"-- Failed:%@",failCode==0?@"Authorization Failure":@"Timeout Failure");
    }];
    
    
}
@end
