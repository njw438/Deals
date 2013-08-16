//
//  ApiClient.m
//  Deals
//
//  Created by Nick Wroblewski on 8/15/13.
//  Copyright (c) 2013 Stretch Computing. All rights reserved.
//

#import "ApiClient.h"
#import "SBJson.h"
@implementation ApiClient



-(void)getDeals{
    @try {
        
        api = GetDeals;
        NSString *dealUrl = @"http://api.analoganalytics.com/publishers/fundogo/daily_deals/active.json";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:dealUrl]];
        
        [request setHTTPMethod: @"GET"];
        [request setValue:@"3.1.0" forHTTPHeaderField:@"API-Version"];

        
        self.serverData = [NSMutableData data];
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately: YES];
    }
    @catch (NSException *e) {

    }
}


-(void)getDealDetailsForUrl:(NSString *)url{
    @try {
        
        api = GetDealDetails;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
        
        [request setHTTPMethod: @"GET"];
        [request setValue:@"3.1.0" forHTTPHeaderField:@"API-Version"];
        
        
        self.serverData = [NSMutableData data];
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately: YES];
    }
    @catch (NSException *e) {
        
    }
}





- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mdata {
        
        [self.serverData appendData:mdata];
   
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @try {

        
        NSData *returnData = [NSData dataWithData:self.serverData];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        

        NSString *notificationName;
        NSDictionary *myDictionary;
        SBJsonParser *jsonParser = [SBJsonParser new];

        if (api == GetDeals) {
            notificationName = @"deals";
            NSArray *response = (NSArray *) [jsonParser objectWithString:returnString error:NULL];
            
            myDictionary = @{@"dealArray":response};
            
            
        }else if (api == GetDealDetails){
            notificationName = @"details";
            
            myDictionary = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];

        }
        
     
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:myDictionary];

        
    }@catch (NSException *exception) {
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    NSString *notificationName;
    
    if (api == GetDeals) {
        notificationName = @"deals";
    }else if (api == GetDealDetails){
        notificationName = @"details";
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:nil];

    
}

@end
