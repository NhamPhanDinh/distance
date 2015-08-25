//
//  Helper.h
//  CardBasedLearning
//
//  Created by hoanghien on 8/29/14.
//  Copyright (c) 2014 Digital Sheep Learning, Inc . All rights reserved.
//

/** This function get localizable string by key
 @return string value
 */


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface Helper : NSObject


/** MARK: Language
 */
/** This function read localized language with key
 */
static inline NSString * language(NSString *key){
    return NSLocalizedString(key, key);
}

static inline NSString * langDict(NSString *key, NSDictionary *dic){
    NSString *value =  NSLocalizedString(key, key);
    for (NSString *k in dic) {
        NSString *v = [[dic objectForKey:k] description];
        value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", k] withString:v];
    }
    return value;
}

+ (void)showLoadingViewOn:(UIView *)aView withText:(NSString *)text;
+ (void)removeLoadingViewOn:(UIView *)superView;
//+ (BOOL)isNetworkAvaiable;
+ (BOOL)isiOS7orHigher;
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (NSString*)convertGMTToDate:(NSString*)dateStr;
//+ (NSString*)convertDateToGMT:(NSString *)currentDate;

//+ (NSDate*)convertStringToDate:(NSString*)date;
//+ (NSString *)dayStringFromDate:(NSDate*)date;
//+ (NSString *)monthStringFromDate:(NSDate*)date;
//+ (NSString *)yearStringFromDate:(NSDate*)date;
//+(NSString*)convertToJapanDate:(NSDate*)date format:(NSString*)formatDate;
+ (CGRect)getScreenSize;

+ (NSString*)convertNumberToHourMinuteSecond:(long long) time;

+ (void)addLeftSpaceForTextField:(UITextField*)textfield space:(CGFloat)space;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

//thang's add on 11/02
+ (NSString *)getVideoDateFromDataAttributeString:(NSDate *)dateAttr;

+ (NSString *)getVideoTimeFromDataAttributeString:(NSDate *)dateAttr;

+ (NSString *)getNumOfFileFromDurationValue:(long long)duration;

+ (float)convertPointToinches:(float)pointDistance;

+ (float)convertInchesToPoint:(float)inches;

+ (float)convertPointToMM:(float)pointDistance;

@end
