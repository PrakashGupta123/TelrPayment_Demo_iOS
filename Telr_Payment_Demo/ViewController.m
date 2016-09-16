//
//  ViewController.m
//  Telr_Payment_Demo
//
//  Created by Admin on 03/09/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "XMLReader.h"
#import "CJSONDeserializer.h"

@interface ViewController ()<NSXMLParserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self Ws_Calling_methodName];
    
    
   
   
}

/*"<mobile>"
 "<store>%@</store>"===> U will see this at the top of ur Telyr a/c when u login, its a five digit code Store ID: *****

 
"<key>%@</key>"---> you will get this when u have Mobile API enable in your telr a/c. How to enable this i will tell u when I am finished with this

"<device>"
"<type>%@</type>"----> Your device type
"<id>%@</id>" -----> Device id vendoridentifier id, pls save this value in a keychain because you will get a different one whenever you will install the same app again and again
"<agent>%@</agent>"---> leave this blank
"<accept>%@</accept>"-----> leave this blank
"</device>"

"<app>"
"<name>%@</name>"----> name of the Application
"<version>%@</version>"----> Application version
"<user>%@</user>" -----> bundle identifier
"<id>%@</id>" ----> not sure about this but I have used "12345" and it worked
"</app>"

"<tran>"
"<test>%@</test>" -----> set this 0 for live and other value for Test purpose
"<type>%@</type>" ------> FOr testing purpose you have to use PayPage
"<class>%@</class>" ------> set this value "cont" for test purpose
"<cartid>%@</cartid>" -----> generate a unique number everytime because it's unique. Best if you combine alphabets+digits+ special characters
"<description>%@</description>" -----> Blah Blah..your App description
"<currency>%@</currency>" -----> Currency You have specify in your Telr account. I am using INR
"<amount>%@</amount>"------> Amout to be deducted
"<ref>%@</ref>" -----> any previous transaction reference number, if you don't have any pls use "000000000001". I am using this
"</tran>"

"<card>"
"<number>%@</number>" ------> 4242424242424242, test purpose
"<expiry>"
"<month>%@</month>"--->mm , any value will work
"<year>%@</year>"----> yyyy, any value will work
"</expiry>"
"<cvv>%@</cvv>"---> 123
"</card>"

"<billing>"

"<name>"
"<title>%@</title>"----> Title
"<first>%@</first>" ---> first name
"<last>%@</last>" ------> last name
"</name>\n"

"<address>"

"<line1>%@</line1>"
"<line2>%@</line2>"
"<line3>%@</line3>"
"<city>%@</city>"
"<region>%@</region>"
"<country>%@</country>"
"<zip>%@</zip>"

"</address>"

"<email>%@</email>"

"</billing>"

"</mobile>"

*/


/*--->  You will get the response in xml hence I have used XML reader inorder to convert that reponse which suits you the best
 
 1. You will get different html links in your response and you have to load this links in webview and from there the payment process will proceed.
 
 2 . If you are unable to get successful response then you will get the error part in tha they have desribed with codes , pls see through documents for more detail.
 
 */

-(void)Ws_Calling_methodName
{
        NSString *paramString = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                          
                          "<mobile>"
                          "<store>%@</store>"
                          "<key>%@</key>"
                          
                          "<device>"
                          "<type>%@</type>"
                          "<id>%@</id>"
                          "<agent>%@</agent>"
                          "<accept>%@</accept>"
                          "</device>"
                          
                          "<app>"
                          "<name>%@</name>"
                          "<version>%@</version>"
                          "<user>%@</user>"
                          "<id>%@</id>"
                          "</app>"
                          
                          "<tran>"
                          "<test>%@</test>"
                          "<type>%@</type>"
                          "<class>%@</class>"
                          "<cartid>%@</cartid>"
                          "<description>%@</description>"
                          "<currency>%@</currency>"
                          "<amount>%@</amount>"
                          "<ref>%@</ref>"
                          "</tran>"
                             
                             "<card>"
                             "<number>%@</number>"
                             "<expiry>"
                             "<month>%@</month>"
                             "<year>%@</year>"
                             "</expiry>"
                             "<cvv>%@</cvv>"
                             "</card>"
                             
                            "<billing>"
                             
                             "<name>"
                             "<title>%@</title>"
                             "<first>%@</first>"
                             "<last>%@</last>"
                             "</name>\n"
                             
                            "<address>"
                             
                             "<line1>%@</line1>"
                             "<line2>%@</line2>"
                             "<line3>%@</line3>"
                             "<city>%@</city>"
                             "<region>%@</region>"
                             "<country>%@</country>"
                             "<zip>%@</zip>"
                             
                            "</address>"
                             
                              "<email>%@</email>"
                             
                             "</billing>"
                             
                            "</mobile>"
                             
                             ,@"",@"",@"iPhone5c",@"",@"",@"",@"Telr_Payment_Demo",@"1.0",@"xyz.Demo",@"123456",@"1",@"PayPage",@"cont",@"systr107",@"Testing",@"INR",@"9.50",@"000000000001",@"4111111111111111",@"02",@"2018",@"123",@"*****",@"Prakash",@"Gupta",@"MahaSagar",@"Manorma Ganj",@"Near Geeta Bhawan",@"indore",@"MP",@"IN",@"452001",@"p*********a@gmail.com"];
    
    
       NSString *requestURL=@"https://secure.innovatepayments.com/gateway/mobile.xml";
    
    NSURL *url=[NSURL URLWithString:requestURL];
    
    NSData *data=[paramString dataUsingEncoding:NSUTF8StringEncoding];
   
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] init];
    [mRequest setURL:url];
    //   [mRequest setTimeoutInterval:180.0];
    [mRequest setHTTPMethod:@"POST"];
 

    [mRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     [mRequest setHTTPBody:data];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *responseData1  = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc]initWithData:responseData1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
//    NSString *string=responseString;
//    NSRange searchFromRange = [string rangeOfString:@"<start>"];
//    NSRange searchToRange = [string rangeOfString:@"</start>"];
//    NSString *substring = [string substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)];
//    NSLog(@"subs=%@",substring);
    
    NSDictionary *dict;
   
    dict = [XMLReader dictionaryForXMLData:responseData1
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    
   
    
    NSDictionary *mob = [[dict valueForKey:@"mobile"]valueForKey:@"trace"];
    NSString *val = [[[[dict valueForKey:@"mobile"]valueForKey:@"webview"]valueForKey:@"abort"]valueForKey:@"text"];
    
    
   
    if (error!=nil)
    {
        NSLog(@"Webservice Error==%@",error);
    }
    else
    {
        NSString *responseDic =[NSJSONSerialization JSONObjectWithData:responseData1 options:NSUTF8StringEncoding error:&error];
        
        if (error!=nil)
        {
            NSLog(@"Webservice Error==%@",error);
            
        }
        else
        {
            NSLog(@"responseDic ======\n %@",responseDic);
//            [delegate getResponse:responseDic];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
