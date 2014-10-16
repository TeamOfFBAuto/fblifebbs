//
//  NotificationFBModel.m
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "NotificationFBModel.h"

@implementation NotificationFBModel
@synthesize fb_actid = _fb_actid;
@synthesize fb_atype = _fb_atype;
@synthesize fb_content = _fb_content;
@synthesize fb_face_orifinal = _fb_face_orifinal;
@synthesize fb_face_small = _fb_face_small;
@synthesize fb_id = _fb_id;
@synthesize fb_oatype = _fb_oatype;
@synthesize fb_status = _fb_status;
@synthesize fb_time = _fb_time;
@synthesize fb_uid = _fb_uid;



-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.fb_oatype = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"oatype"]];
        self.fb_atype = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"atype"]];
        self.fb_actid = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"actid"]];
        self.fb_id = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"id"]];
        self.fb_time = [zsnApi timechange1:[zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"time"]]];
        self.fb_status = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"status"]];
        self.fb_content = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"content"]];
        self.fb_uid = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"uid"]];
        self.fb_face_small = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"face_small"]];
        self.fb_face_orifinal = [zsnApi exchangeStringForDeleteNULL:[dic objectForKey:@"face_orifinal"]];
    }
    
    return self;
}





@end
