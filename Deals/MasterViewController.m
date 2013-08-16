//
//  MasterViewController.m
//  Deals
//
//  Created by Nick Wroblewski on 8/15/13.
//  Copyright (c) 2013 Stretch Computing. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ApiClient.h"


@implementation MasterViewController



-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealsComplete:) name:@"deals" object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    
    ApiClient *tmp = [[ApiClient alloc] init];
    [tmp getDeals];
    
    [super viewDidLoad];

    
    self.dealArray = [NSMutableArray array];
    
    
    //UI
    
    self.navigationController.navigationBar.hidden = YES;
    double color = 240.0/255.0;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:color green:color blue:color alpha:1.0];
    

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:14.0/255.0 green:149.0/255.0 blue:219.0/255.0 alpha:1.0];
    [self.view addSubview:label];
    label.text = @"Deals";
    
    [self.myTableView reloadData];
    
}


-(void)refreshDeals{
    [self.activity startAnimating];
    self.refreshButton.hidden = YES;
    ApiClient *tmp = [[ApiClient alloc] init];
    [tmp getDeals];
}

-(void)dealsComplete:(NSNotification *)notification{
    
    self.refreshButton.hidden = NO;
    [self.activity stopAnimating];
    NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];

    BOOL error = YES;
    
    if (responseInfo && [responseInfo valueForKey:@"dealArray"]) {
        self.dealArray = [responseInfo valueForKey:@"dealArray"];        
        
        if ([self.dealArray count] > 0) {
            error = NO;
            [self.myTableView reloadData];

        }
    }
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Deals Found" message:@"No deals were found, please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}


#pragma mark - Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dealArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dealCell"];
    
    UIView *backView =  (UIView *)[cell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UIImageView *dealImage = (UIImageView *)[cell.contentView viewWithTag:3];
    UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:4];
    UILabel *timeLeftLabel = (UILabel *)[cell.contentView viewWithTag:5];

    
    
    NSDictionary *dealObject = [self.dealArray objectAtIndex:indexPath.row];
    
    nameLabel.text = [dealObject valueForKey:@"value_proposition"];
    priceLabel.text = [NSString stringWithFormat:@"Price: $%.2f", [[dealObject valueForKey:@"price"] doubleValue]];
    
    NSString *expiresDate = [dealObject valueForKey:@"ends_at"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *expireDate = [dateFormat dateFromString:expiresDate];
    [dateFormat setDateFormat:@"MM/dd HH:mm a"];
    timeLeftLabel.text = [NSString stringWithFormat:@"Expires: %@", [dateFormat stringFromDate:expireDate]];
    
    
    if ([[dealObject valueForKey:@"photo"] length] > 0) {
        
        NSString *imageUrl = [dealObject valueForKey:@"photo"];
        
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageUrl]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dealImage.image = [UIImage imageWithData:data];
                
                
            });
        });

        
        
    }
    backView.layer.cornerRadius =6.0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 111;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goDetail"]) {
        
        DetailViewController *detail = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        
        detail.dealObject = [self.dealArray objectAtIndex:indexPath.row];
        
    }
}

@end
