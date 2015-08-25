//
//  Helper.m
//  CardBasedLearning
//
//  Created by hoanghien on 8/29/14.
//  Copyright (c) 2014 Digital Sheep Learning, Inc . All rights reserved.
//

#import "Helper.h"


@implementation Helper

#pragma mark Loading View

+ (void)showLoadingViewOn:(UIView *)aView withText:(NSString *)text{
	
	UIView *loadingView = [[UIView alloc] init];
	loadingView.frame = CGRectMake(0, 0, aView.bounds.size.width, aView.bounds.size.height + 40);
	loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
	loadingView.tag = 1011;
	UILabel *loadingLabel = [[UILabel alloc ] init];
	
	UIView* roundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
	roundedView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
	roundedView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	roundedView.layer.borderColor = [UIColor clearColor].CGColor;
	roundedView.layer.borderWidth = 1.0;
	roundedView.layer.cornerRadius = 10.0;
	[loadingView addSubview:roundedView];
	
	loadingLabel.text = text;
	loadingLabel.frame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y + 50, 200, 30);
	//loadingLabel.adjustsFontSizeToFitWidth = YES;
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:14];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.tag = 1012;
	[loadingView addSubview:loadingLabel];
	
	UIActivityIndicatorView *activityIndication = [[UIActivityIndicatorView alloc] init];
	activityIndication.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	activityIndication.frame = CGRectMake((loadingView.frame.size.width - 30)/2,
										  roundedView.frame.origin.y + 15,
										  30,
										  30);
	
	//	NSLog(@"%@",activityIndication);
	[activityIndication startAnimating];
	[loadingView addSubview:activityIndication];
	
	//	[activityIndication release];
	[aView addSubview:loadingView];
}

+ (BOOL)isiOS7orHigher
{
    float ios = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ios >= 7.0) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)removeLoadingViewOn:(UIView *)superView{
	for (UIView *aView in superView.subviews) {
		if ((aView.tag == 1011)  && [aView isKindOfClass:[UIView class]]) {
			[aView removeFromSuperview];
		}
	}
}

+ (void)updateLoadingViewOn:(UIView *)superView withText:(NSString*)text{
	for (UIView *aView in superView.subviews) {
		if ((aView.tag == 1012)  && [aView isKindOfClass:[UILabel class]]) {
			[(UILabel*)aView setText:text];
		}
	}
}

//+ (NSString*)getURlFromPath:(NSString*)path{
//    return [kServerUrl stringByAppendingString:path];
//}
//
//+(BOOL)isNetworkAvaiable{
//    NetworkStatus status = [[AppDelegate shareApp].reachability currentReachabilityStatus];
//    if (status == NotReachable) {
//        return NETWORK_AVAIABLE;
//    }else{
//        return NETWORK_ERROR;
//    }
//}

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

+ (void)addLeftSpaceForTextField:(UITextField *)textfield space:(CGFloat)space {
    CGRect frame = textfield.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = space;
    UIView* view = [[UIView alloc] initWithFrame:frame];
    [textfield setLeftView:view];
    [textfield setLeftViewMode:UITextFieldViewModeAlways];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

/**
 * Convert local date to GMT
 * @param local date
 * @return
 */

//+ (NSString*)convertDateToGMT:(NSString *)currentDate{
//    
//    NSLog(@"currentDate = %@",currentDate);
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = DAY_FORMAT;
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithName:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    NSDate *date = [dateFormatter dateFromString:currentDate];
//    NSLog(@"date convert to GMT =  %@",date);
//    
//    NSString *dateStr = [dateFormatter stringFromDate:date];
//    
//    return [Helper replaceTimeZone:dateStr];
//}

/**
 * Convert GMT to local date
 * @param GMT date
 * @return
 */

+ (NSString*)convertGMTToDate:(NSString*)dateStr{
    NSString *result = dateStr;
    NSRange replaceRange = [dateStr rangeOfString:@"GMT"];
    if (replaceRange.location == NSNotFound){
        replaceRange = [dateStr rangeOfString:@"JST"];
        if (replaceRange.location != NSNotFound) {
            result  = [dateStr substringToIndex:replaceRange.location];
        }
    }else{
        result  = [dateStr substringToIndex:replaceRange.location];
    }
    
    return result;
}



/**
 * Replace "GMT" string
 *
 *@params date string
 *@return
 */

+ (NSString*)replaceTimeZone:(NSString*)dateStr{
    NSString *result = dateStr;
    NSRange replaceRange = [dateStr rangeOfString:@"GMT"];
    if (replaceRange.location != NSNotFound){
        result  = [dateStr stringByReplacingCharactersInRange:replaceRange withString:@""];
    }
    return result;
}

/**
 * Convert string to date
 *
 *@params date
 *@return
 */

//+ (NSDate*)convertStringToDate:(NSString*)date{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = DAY_FORMAT;
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    
//    return [dateFormatter dateFromString:date];
//}

/**
 * Convert date to string
 *
 *@params date
 *@return
 */

//+ (NSString *)dayStringFromDate:(NSDate*)date{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = DAY_FORMAT;
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    NSString *dateStr = [dateFormatter stringFromDate:date];
//    return  [Helper replaceTimeZone:dateStr];
//}


//+ (NSString *)monthStringFromDate:(NSDate*)date{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = MONTH_FORMAT;
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    NSString *dateStr = [dateFormatter stringFromDate:date];
//    return  [Helper replaceTimeZone:dateStr];
//}

//+ (NSString *)yearStringFromDate:(NSDate*)date{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = YEAR_FORMAT;
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    NSString *dateStr = [dateFormatter stringFromDate:date];
//    return  [Helper replaceTimeZone:dateStr];
//}

/**
 * Convert Japan Date String
 *
 *@params date
 *@return
 */

//+(NSString*)convertToJapanDate:(NSDate*)date format:(NSString*)formatDate
//{
//    if (date == nil) {
//        return @"";
//    }
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSSecondCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitWeekday) fromDate:date];
//    
//    int year = (int)[components year];
//    int month = (int)[components month];
//    int day = (int)[components day];
//    
//    NSString *dayStr = @"";
//    if (day < 10) {
//        dayStr = [NSString stringWithFormat:@"0%d日",day];
//    }else{
//        dayStr = [NSString stringWithFormat:@"%d日",day];
//    }
//    
//    NSString *monthStr = @"";
//    if (month < 10) {
//        monthStr = [NSString stringWithFormat:@"0%d月",month];
//    }else{
//        monthStr = [NSString stringWithFormat:@"%d月",month];
//    }
//    
//    NSString *yearStr =[NSString stringWithFormat:@"%d年",year];
//    
//    NSString *jpDate = @"";
//    if ([formatDate isEqual:DAY_FORMAT]) {
//        jpDate = [NSString stringWithFormat:@"%@%@%@",yearStr,monthStr,dayStr];
//    }
//    else if ([formatDate isEqualToString:MONTH_FORMAT])
//    {
//        jpDate = [NSString stringWithFormat:@"%@%@",yearStr,monthStr];
//    }
//    else if ([formatDate isEqualToString:YEAR_FORMAT])
//    {
//        jpDate = [NSString stringWithFormat:@"%@",yearStr];
//    }
//    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat: @"EEEE"];
//    
//    NSString *dayOfWeek = [formatter stringFromDate:date];
//    
//    if ([dayOfWeek isEqualToString:@"Sunday"]) {
//        dayOfWeek =  @"（日）";
//    }else  if ([dayOfWeek isEqualToString:@"Monday"]) {
//        dayOfWeek =  @"（月）";
//    }else  if ([dayOfWeek isEqualToString:@"Tuesday"]) {
//        dayOfWeek =  @"（火）";
//    }else  if ([dayOfWeek isEqualToString:@"Wednesday"]) {
//        dayOfWeek =  @"（水）";
//    }else  if ([dayOfWeek isEqualToString:@"Thursday"]) {
//        dayOfWeek =  @"（木）";
//    }else  if ([dayOfWeek isEqualToString:@"Friday"]) {
//        dayOfWeek =  @"（金）";
//    }else  if ([dayOfWeek isEqualToString:@"Saturday"]) {
//        dayOfWeek =  @"（土）";
//    }
//    
//    if ([formatDate isEqual:DAY_FORMAT]) {
//        jpDate = [NSString stringWithFormat:@"%@%@",jpDate,dayOfWeek];
//    }
//    
//    formatter = Nil;
//    
//    return jpDate;
//}

+ (NSString*)convertNumberToHourMinuteSecond:(long long)time{
    NSString *str,*strMinute,*strSecond,*strHour;
    int minute, second, hour;
    
    minute = (int)time/60;
    second = (int)time%60;
    hour = minute/60;
    minute = minute%60;
    
    if(second >= 10){
        strSecond = [NSString stringWithFormat:@"%d",second];
    }else{
        strSecond = [NSString stringWithFormat:@"0%d",second];
    }
    
    if(minute >= 10){
        strMinute = [NSString stringWithFormat:@"%d",minute];
    }else{
        strMinute = [NSString stringWithFormat:@"0%d",minute];
    }
    
    if(hour >= 10){
        strHour = [NSString stringWithFormat:@"%d",hour];
    }else{
        strHour = [NSString stringWithFormat:@"0%d",hour];
    }
    
    str = [NSString stringWithFormat:@"%@:%@:%@",strHour,strMinute,strSecond];
    return str;
}


+ (CGRect)getScreenSize{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // grab the window frame and adjust it for orientation
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow]
                        rootViewController].view;
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
//    CGRect adjustedFrame = [rootView convertRect:originalFrame fromView:nil];
//    return adjustedFrame;
    return originalFrame;
}

/**
 *@brief: get date formatter for NSDate
 *@param:
 *@author: thangnh
 */
+ (NSString *)getVideoDateFromDataAttributeString:(NSDate *)dateAttr {
    NSString *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    date = [formatter stringFromDate:dateAttr];
    return date;
}

/**
 *@brief:
 *@param:
 *@author:
 */
+ (NSString *)getVideoTimeFromDataAttributeString:(NSDate *)dateAttr {
    NSString *time = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    time = [formatter stringFromDate:dateAttr];
    return  time;
}
/**
 *@brief:
 *@param:
 *@author:
 */
+ (NSString *)getNumOfFileFromDurationValue:(long long)duration {
    NSString *numStr = nil;
    int minute, second, hour, num;
    
    minute = (int)duration/60;
    second = (int)duration%60;
    hour = minute/60;
    minute = minute%60;
    num = hour * 60 + minute;
    (second > 0) ? num++ : num;
    numStr = [NSString stringWithFormat:@"%dファイル", num];
    
    return numStr;
}

+ (float)convertPointToinches:(float)pointDistance{
    float inches = 0;
    float inchesScreen = 0;
    if([self getScreenSize].size.width == 320){
        NSLog(@"IP4 & 5");
        inchesScreen = 1.94f;
    }else if([self getScreenSize].size.width == 375){
        NSLog(@"IP6");
        inchesScreen = 2.3f;
    }else if([self getScreenSize].size.width == 414){
        NSLog(@"IP6+");
        inchesScreen = 2.7f;
    }
    
    inches = pointDistance*inchesScreen/[self getScreenSize].size.width;
    return inches;
}

+ (float)convertPointToMM:(float)pointDistance{
    float mm = 0;
    float inchesScreen = 0;
    if([self getScreenSize].size.width == 320){
        NSLog(@"IP4 & 5");
        inchesScreen = 1.94f;
    }else if([self getScreenSize].size.width == 375){
        NSLog(@"IP6");
        inchesScreen = 2.3f;
    }else if([self getScreenSize].size.width == 414){
        NSLog(@"IP6+");
        inchesScreen = 2.7f;
    }
    
    mm = (pointDistance*inchesScreen/[self getScreenSize].size.width)*25.4f;
    return mm;
}

+ (float)convertInchesToPoint:(float)inches{
    float point = 0;
    float inchesScreen = 0;
    if([self getScreenSize].size.width == 320){
        NSLog(@"IP4 & 5");
        inchesScreen = 1.94f;
    }else if([self getScreenSize].size.width == 375){
        NSLog(@"IP6");
        inchesScreen = 2.3f;
    }else if([self getScreenSize].size.width == 414){
        NSLog(@"IP6+");
        inchesScreen = 2.7f;
    }
    
    point = [self getScreenSize].size.width*inches/inchesScreen;
    return point;
}

@end
