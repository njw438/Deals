//
//  DetailViewController.m
//  Deals
//
//  Created by Nick Wroblewski on 8/15/13.
//  Copyright (c) 2013 Stretch Computing. All rights reserved.
//

#import "DetailViewController.h"
#import "ApiClient.h"
#import <QuartzCore/QuartzCore.h>


@implementation DetailViewController

#pragma mark - Managing the detail item


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealsComplete:) name:@"details" object:nil];

    ApiClient *tmp = [[ApiClient alloc] init];
    NSString *detailUrl = [[self.dealObject valueForKey:@"connections"] valueForKey:@"details"];
    [tmp getDealDetailsForUrl:detailUrl];
    
}

- (void)viewDidLoad
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:14.0/255.0 green:149.0/255.0 blue:219.0/255.0 alpha:1.0];
    [self.view addSubview:label];
    label.text = @"Details";
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealsComplete:(NSNotification *)notification{
    
   
    NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
    
    
    BOOL error = YES;
    
    if (responseInfo) {
        error = NO;
        self.whiteBackView.hidden = NO;
        self.whiteBackView.layer.cornerRadius = 7.0;
        
        self.valuePropText.text = [responseInfo valueForKey:@"value_proposition"];
        self.priceText.text = [NSString stringWithFormat:@"Price: $%.2f", [[responseInfo valueForKey:@"price"] doubleValue]];
        
        NSString *expiresDate = [responseInfo valueForKey:@"ends_at"];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        NSDate *expireDate = [dateFormat dateFromString:expiresDate];
        [dateFormat setDateFormat:@"MM/dd HH:mm a"];
        self.expiresText.text = [NSString stringWithFormat:@"Expires: %@", [dateFormat stringFromDate:expireDate]];
        
        
        self.descriptionText.text = [responseInfo valueForKey:@"description"];
        
        self.numberAvailable.text = [NSString stringWithFormat:@"Remaining: %d", [[responseInfo valueForKey:@"total_quantity_available"] intValue]];
        
        self.minLabel.text = [NSString stringWithFormat:@"Min Purchase: %d", [[responseInfo valueForKey:@"minimum_purchase_quantity"] intValue]];
                                     
        if ([[responseInfo valueForKey:@"photo"] length] > 0) {
            
            NSString *imageUrl = [responseInfo valueForKey:@"photo"];
            
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageUrl]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.imageTextView.image = [UIImage imageWithData:data];
                    
                    
                });
            });
            
            
            
        }
    }
  
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Deals Found" message:@"No deals were found, please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}






- (IBAction)goBack {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
