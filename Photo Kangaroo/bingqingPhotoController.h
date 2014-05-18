//
//  bingqingPhotoController.h
//  Photo Kangaroo
//
//  Created by Bingqing Huang on 5/17/14.
//  Copyright (c) 2014 Bingqing Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bingqingPhotoController : NSObject

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion: (void(^)(UIImage *image))completion;

@end
