//
//  SKIMServiceDefs.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-8-6.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#ifndef NewZhongYan_SKIMServiceDefs_h
#define NewZhongYan_SKIMServiceDefs_h


/*!
 @enum
 @brief 聊天类型
 @constant MessageBodyType_Text 文本类型
 @constant MessageBodyType_Image 图片类型
 @constant MessageBodyType_Video 视频类型
 @constant MessageBodyType_Location 位置类型
 @constant MessageBodyType_Voice 语音类型
 @constant MessageBodyType_File 文件类型
 @constant MessageBodyType_Command 命令类型
 */
typedef enum {
    MessageBodyType_Text = 1,
    MessageBodyType_Image,
    MessageBodyType_Video,
    MessageBodyType_Location,
    MessageBodyType_Voice,
    MessageBodyType_File,
    MessageBodyType_Command
}MessageBodyType;


/*!
 @enum
 @brief 聊天消息发送状态
 @constant MessageDeliveryState_Pending 待发送
 @constant MessageDeliveryState_Delivering 正在发送
 @constant MessageDeliveryState_Delivered 已发送, 成功
 @constant MessageDeliveryState_Failure 已发送, 失败
 */
typedef enum {
    MessageDeliveryState_Pending = 0,
    MessageDeliveryState_Delivering,
    MessageDeliveryState_Delivered,
    MessageDeliveryState_Failure
}MessageDeliveryState;

#define EMOTION_NAME_REGX   @"\\[\\w+\\]"               // 实际正则应为\[\w+\]
#define EMOTION_REGX        @"/.{2}\\n"               // 实际正则应为/.{2}\\n
#define PICTURE_REGX        @"/\\{\\{.+/\\}\\}"         // 实际正则应为/\{\{.+/\}\}
#define FONT_REGX           @"/\\[\\[.+\\]\\]"         // 实际正则应为/\[\[.+\]\]

//表情名称
#define EMOTION_NAME @[@"[微笑]", @"[吐舌笑脸]", @"[偷笑]", @"[憨笑]", @"[呲牙]", @"[可爱]", @"[害羞]", @"[色]", @"[示爱]", @"[酷]", @"[得意]", @"[大兵]", @"[再见]", @"[难过]", @"[撇嘴]", @"[发呆]", @"[傲慢]", @"[白眼]", @"[擦汗]", @"[流汗]", @"[惊讶]", @"[尴尬]", @"[惊恐]", @"[流泪]", @"[大哭]", @"[发怒]", @"[糗大了]", @"[奋斗]", @"[饥饿]", @"[困]", @"[睡]", @"[抓狂]", @"[吐]", @"[晕]", @"[折磨]", @"[咒骂]", @"[疑问]", @"[闭嘴]", @"[抠鼻]", @"[嘘…]", @"[左哼哼]", @"[右哼哼]", @"[哈欠]", @"[鄙视]", @"[委屈]", @"[快哭了]", @"[阴险]", @"[亲亲]", @"[吓]", @"[可怜]", @"[坏笑]", @"[猪头]", @"[握手]", @"[OK]", @"[胜利]", @"[强]", @"[抱拳]", @"[NO]", @"[弱]", @"[勾引]", @"[拳头]", @"[差劲]", @"[爱你]", @"[鼓掌]", @"[拥抱]", @"[爱心]", @"[心碎]", @"[玫瑰]", @"[凋谢]", @"[敲打]", @"[刀]", @"[菜刀]", @"[会议]", @"[飞机]", @"[汽车]", @"[包子]", @"[比萨]", @"[汉堡]", @"[咖啡]", @"[啤酒]", @"[西瓜]", @"[米饭]", @"[蛋糕]", @"[礼物]", @"[约会]", @"[足球]", @"[篮球]", @"[乒乓]", @"[下雨]", @"[月亮]", @"[太阳]"]

#define EMOTION_ID @[@"/:)\n", @"/;P\n", @"/tx\n", @"/:>\n", @"/:D\n", @"/;D\n", @"/:$\n", @"/:B\n", @"/sa\n", @"/:+\n", @"/8)\n", @"/:;\n", @"/zj\n", @"/:(\n", @"/:~\n", @"/:|\n", @"/;o\n", @"/:Y\n", @"/ch\n", @"/:L\n", @"/:0\n", @"/:-\n", @"/:!\n", @"/:<\n", @"/:`\n", @"/:@\n", @"/&-\n", @"/;f\n", @"/:g\n", @"/|)\n", @"/:Z\n", @"/:Q\n", @"/:T\n", @"/;@\n", @"/:8\n", @"/ma\n", @"/yw\n", @"/:X\n", @"/kb\n", @"/;x\n", @"/<@\n", @"/>@\n", @"/-0\n", @"/>-\n", @"/P-\n", @"/'|\n", @"/yx\n", @"/:*\n", @"/@x\n", @"/8*\n", @"/B)\n", @"/zt\n", @"/ws\n", @"/ok\n", @"/sl\n", @"/hq\n", @"/@)\n", @"/no\n", @"/hr\n", @"/jj\n", @"/@@\n", @"/cj\n", @"/an\n", @"/gz\n", @"/yb\n", @"/ax\n", @"/xc\n", @"/mg\n", @"/dx\n", @"/qd\n", @"/kn\n", @"/pd\n", @"/hy\n", @"/fj\n", @"/qc\n", @"/BZ\n", @"/bs\n", @"/HB\n", @"/cf\n", @"/pj\n", @"/XG\n", @"/mf\n", @"/dg\n", @"/lw\n", @"/YI\n", @"/zq\n", @"/lq\n", @"/oo\n", @"/xy\n", @"/yl\n", @"/ty\n"]

#endif
