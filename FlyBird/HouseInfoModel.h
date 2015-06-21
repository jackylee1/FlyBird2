//
//  HouseInfoModel.h
//  FlyBird
//
//  Created by yosonyuan on 15/6/11.
//  Copyright (c) 2015年 yosonyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseInfoModel : NSObject
@property(nonatomic,strong) NSString* location;
@property(nonatomic,strong)NSString* size;
@property(nonatomic,strong)NSString *mortgage;
@property(nonatomic,strong)NSString *perPriece;
@property(nonatomic,strong)NSString *totalPrice;
@property(nonatomic,strong)NSString *agency;
@property(nonatomic,strong)NSString *photo1;
@property(nonatomic,strong)NSString *photo2;
@property(nonatomic,strong)NSString *photo3;
@property(nonatomic,strong)NSString *photo4;
@property(nonatomic,strong)NSString *photo5;
@property(nonatomic,strong)NSString *photo6;
@property(nonatomic,strong)NSString *photo7;
@property(nonatomic,strong)NSString *photo8;
@property(nonatomic,strong)NSString *photo9;
@property(nonatomic,strong)NSString *photo10;
@property(nonatomic,strong)NSString *photoI1;
@property(nonatomic,strong)NSString *photoI2;
@property(nonatomic,strong)NSString *photoI3;
@property(nonatomic,strong)NSString *photoI4;
@property(nonatomic,strong)NSString *photoI5;
@property(nonatomic,strong)NSString *photoI6;
@property(nonatomic,strong)NSString *photoI7;
@property(nonatomic,strong)NSString *photoI8;
@property(nonatomic,strong)NSString *photoI9;
@property(nonatomic,strong)NSString *photoI10;
- (void)parseResponse:(NSDictionary *)jsonDict;
@end
