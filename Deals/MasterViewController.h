//
//  MasterViewController.h
//  Deals
//
//  Created by Nick Wroblewski on 8/15/13.
//  Copyright (c) 2013 Stretch Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dealArray;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
-(IBAction)refreshDeals;

@end
