//
//  DetailViewController.h
//  Deals
//
//  Created by Nick Wroblewski on 8/15/13.
//  Copyright (c) 2013 Stretch Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
- (IBAction)goBack;

@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) NSDictionary *dealObject;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *whiteBackView;

@property (strong, nonatomic) IBOutlet UILabel *valuePropText;

@property (strong, nonatomic) IBOutlet UILabel *priceText;

@property (strong, nonatomic) IBOutlet UILabel *expiresText;


@property (strong, nonatomic) IBOutlet UILabel *numberAvailable;


@property (strong, nonatomic) IBOutlet UIImageView *imageTextView;

@property (strong, nonatomic) IBOutlet UITextView *descriptionText;

@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@end
