//
//  ApiClient.h
//  Deals
//
//  Created by Nick Wroblewski on 8/15/13.
//  Copyright (c) 2013 Stretch Computing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GetDeals = 0,
    GetDealDetails=1,
    
    
} APIS;


@interface ApiClient : NSObject <NSURLConnectionDelegate> {
    APIS api;

}

@property (nonatomic, strong) NSMutableData *serverData;
@property (nonatomic, strong) NSURLConnection *urlConnection;

-(void)getDeals;
-(void)getDealDetailsForUrl:(NSString *)url;






@end
