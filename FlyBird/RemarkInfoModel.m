//
//  RemarkInfoModel.m
//  FlyBird
//
//  Created by yosonyuan on 15/6/11.
//  Copyright (c) 2015年 yosonyuan. All rights reserved.
//

#import "RemarkInfoModel.h"

@implementation RemarkInfoModel
-(void)parseResponse:(NSDictionary *)jsonDict{
    id obj = [jsonDict objectForKey:@"commentimgs"];
    if(obj !=nil && [obj isKindOfClass:[NSString class]]){
        self.photo1 = obj;
    }
    obj = [jsonDict objectForKey:@"commentimgs2"];
    if(obj !=nil && [obj isKindOfClass:[NSString class]]){
        self.photo2 = obj;
    }
    obj = [jsonDict objectForKey:@"commentimgsinfo"];
    if(obj !=nil && [obj isKindOfClass:[NSString class]]){
        self.photoI1 = obj;
    }
    obj = [jsonDict objectForKey:@"commentimgs2info"];
    if(obj !=nil && [obj isKindOfClass:[NSString class]]){
        self.photoI2 = obj;
    }
    obj = [jsonDict objectForKey:@"description"];
    if(obj !=nil && [obj isKindOfClass:[NSString class]]){
        self.otherInfo = obj;
    }
}
@end
