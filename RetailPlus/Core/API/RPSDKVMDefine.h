//
//  RPvmGuide.h
//  RetailPlus
//
//  Created by zhanglinfeng on 14-6-17.
//  Copyright (c) 2014年 lin dong. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef enum
//{
//    Rand_All = 0,
//    Rank_Manager = 1,
//    Rank_StoreManager,
//    Rank_Assistant,
//    Rank_Vendor,
//}Rank;
@interface RPvmGuide : NSObject
@property (nonatomic,retain) NSString          * strName;
@property (nonatomic,retain) NSString          * strCreator;
@property (nonatomic,retain) NSString          * strPath;
@property (nonatomic,retain) NSString          * strUrl;
@property (nonatomic,retain) NSString          * strDate;
@property (nonatomic,retain) NSString          * strID;
@property (nonatomic,retain) NSString          * strType;
@property (nonatomic,assign) float             size;
@end


@interface FollowStore : NSObject //关注店铺
@property (nonatomic,retain) NSString          * strUserId;
@property (nonatomic,retain) NSString          * strStoreId;
@property (nonatomic,retain) NSString          * strFollowStoreId;
@property (nonatomic,retain) NSString          * strStoreName;
@property (nonatomic,retain) NSString          * strBrandName;
@property (nonatomic,retain) NSString          * strStoreThumb;
@property (nonatomic,retain) NSString          * strShopMap;

@property (nonatomic,assign) NSInteger           pendingCount;
@property (nonatomic,assign) NSInteger           rejectCount;
@end

@interface VisualDisplay : NSObject  //视觉陈列
@property (nonatomic,retain) NSString   * strVisualDisplayId;
@property (nonatomic,retain) NSString   * strTitle;
@property (nonatomic,retain) NSString   * strImgUrl;
@property (nonatomic,retain) NSString   * strUserName;
@property (nonatomic,retain) NSString   * strComments;
@property (nonatomic) Rank                rank;
@property (nonatomic,assign) int          states;//0待审核  1不合格  2通过
@property (nonatomic,assign) float        x;
@property (nonatomic,assign) float        y;

@end

//@interface AddVisualDisplayModel : NSObject
//@property (nonatomic,retain) NSString   * strTitle;
//@property (nonatomic,retain) NSString   * strStoreId;
//@property (nonatomic,retain) NSString   * strComments;
//@property (nonatomic,assign) float        x;
//@property (nonatomic,assign) float        y;
//@property (nonatomic,retain) NSMutableArray * arrayImg;
//@end

@interface VMImage : NSObject  //图片信息
@property (nonatomic,retain) NSString     *strImgId;
@property (nonatomic,retain) UIImage      *imgData;
@property (nonatomic,retain) NSString     *strComments;
@property (nonatomic,assign) float        regX;
@property (nonatomic,assign) float        regY;
@property (nonatomic,assign) float        regWidth;
@property (nonatomic,assign) float        regHeight;
//@property (nonatomic,retain) NSString     *strUrl;
//@property (nonatomic,retain) NSString     *strUrlthumb;
@end

@interface ReplyList : NSObject //视觉陈列详细信息
@property (nonatomic,retain)NSMutableArray     * arrayImg;
@property (nonatomic,retain)NSMutableArray     * arrayReply;
@end

@interface VMReply : NSObject
@property (nonatomic,retain) NSString       *strVisualDisplayId;
//@property (nonatomic,retain) NSString       *StoreId;
@property (nonatomic,retain) NSString       *strUserId;
@property (nonatomic,retain) NSString       *strUsername;//用户名
@property (nonatomic) Rank                  rank;//用户等级
@property (nonatomic,assign)int             type ;//0: addpic 1:回复图片 2引用，3:修改状态
@property (nonatomic,assign)int             states; //type = 3 起效
@property (nonatomic,retain) NSString       *strComment;//回复内容
@property (nonatomic,retain) NSString       *strDate;
@property (nonatomic,retain) NSMutableArray *arrayimgReply; //0 1
@end

@interface  ReplyImg: NSObject
@property (nonatomic,retain) NSString       *strImgId;
@property (nonatomic,retain) NSString       *strComments;
@property (nonatomic,retain) NSString       *strImgPath;
@property (nonatomic,retain) NSString       *strThumbPath;
@property (nonatomic,retain) NSString       *strUserName;
@property (nonatomic)Rank                    rank;
@end

@interface  ReplyImgDetail: NSObject
@property (nonatomic,retain) NSString       *strImgId;
@property (nonatomic,assign) float           regX;
@property (nonatomic,assign) float           regY;
@property (nonatomic,assign) float           regWidth;
@property (nonatomic,assign) float           regHeigth;
@end
//@interface imgreply : NSObject
//imgid
//x
//y
//w
//h
//@end

//@interface vmimg : NSObject
//id
//url
//urlthumb
//comment
//@end