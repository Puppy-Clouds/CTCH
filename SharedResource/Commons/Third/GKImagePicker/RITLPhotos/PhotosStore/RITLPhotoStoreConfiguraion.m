//
//  YPPhotoStoreConfiguraion.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoStoreConfiguraion.h"


NSString * ConfigurationCameraRoll = @"Camera Roll";
NSString * ConfigurationCameraRoll_zh = @"相机胶卷";
NSString * ConfigurationAllPhotos = @"All Photos";
NSString * ConfigurationAllPhotos_zh = @"所有照片";
NSString * ConfigurationHidden = @"Hidden";
NSString * ConfigurationHidden_zh = @"已隐藏";
NSString * ConfigurationSlo_mo = @"Slo-mo";
NSString * ConfigurationSlo_mo_zh = @"慢动作";
NSString * ConfigurationScreenshots = @"Screenshots";
NSString * ConfigurationScreenshots_zh = @"屏幕快照";
NSString * ConfigurationVideos = @"Videos";
NSString * ConfigurationVideos_zh = @"视频";
NSString * ConfigurationPanoramas = @"Panoramas";
NSString * ConfigurationPanoramas_zh = @"全景照片";
NSString * ConfigurationTime_lapse = @"Time-lapse";
NSString * ConfigurationTime_lapse_zh = @"延时摄影";
NSString * ConfigurationRecentlyAdded = @"Recently Added";
NSString * ConfigurationRecentlyAdded_zh = @"最近添加";
NSString * ConfigurationRecentlyDeleted = @"Recently Deleted";
NSString * ConfigurationRecentlyDeleted_zh = @"最近删除";
NSString * ConfigurationBursts = @"Bursts";
NSString * ConfigurationBursts_zh = @"长曝光";
NSString * ConfigurationFavorite = @"Favorite";
NSString * ConfigurationFavorite_zh = @"最爱";
NSString * ConfigurationSelfies = @"Selfies";
NSString * ConfigurationSelfies_zh = @"自拍";
NSString * ConfigurationLive_Photo = @"Live Photo";


static NSArray <NSString *>*  groupNames;

@implementation RITLPhotoStoreConfiguraion

+(void)initialize
{
    if (self == [RITLPhotoStoreConfiguraion class])
    {
    
        groupNames = @[NSLocalizedString(ConfigurationCameraRoll, @""),
                   NSLocalizedString(ConfigurationAllPhotos, @""),
                   NSLocalizedString(ConfigurationSlo_mo, @""),
                   NSLocalizedString(ConfigurationScreenshots, @""),
                   NSLocalizedString(ConfigurationPanoramas, @""),
                   NSLocalizedString(ConfigurationRecentlyAdded, @""),
                   NSLocalizedString(ConfigurationSelfies, @"")];
    }
}

-(NSArray *)groupNamesConfig
{
    return groupNames;
}

-(void)setGroupNames:(NSArray<NSString *> *)newGroupNames
{
    groupNames = newGroupNames;
    
    [self localizeHandle];
}

//初始化方法
-(instancetype)initWithGroupNames:(NSArray<NSString *> *)groupNames
{
    if (self = [super init])
    {
        [self setGroupNames:groupNames];
    }
    
    return self;
}


+(instancetype)storeConfigWithGroupNames:(NSArray<NSString *> *)groupNames
{
    return [[self alloc]initWithGroupNames:groupNames];
}



/** 本地化语言处理 */
- (void)localizeHandle
{
    NSMutableArray <NSString *> * localizedHandle = [NSMutableArray arrayWithArray:groupNames];
    
    for (NSUInteger i = 0; i < localizedHandle.count; i++)
    {
        [localizedHandle replaceObjectAtIndex:i withObject:NSLocalizedString(localizedHandle[i], @"")];
    }
    
    groupNames = [NSArray arrayWithArray:localizedHandle];
}


@end



