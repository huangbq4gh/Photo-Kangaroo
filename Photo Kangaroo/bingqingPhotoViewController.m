//
//  bingqingPhotoViewController.m
//  Photo Kangaroo
//
//  Created by Bingqing Huang on 5/17/14.
//  Copyright (c) 2014 Bingqing Huang. All rights reserved.
//

#import "bingqingPhotoViewController.h"
#import "bingqingPhotoCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "bingqingDetailViewController.h"
#import "bingqingPresentDetailTransition.h"
#import "bingqingDismissDetailTransition.h"

@interface bingqingPhotoViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *photos;
@end

@implementation bingqingPhotoViewController

//instancetype  return an object which is the same type with the method is runing in.
- (instancetype)init{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(159.0, 159.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);

}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"Photo Kangaroo";
    [self.collectionView registerClass:[bingqingPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary * responseObject, NSError *error) {
            
            self.accessToken = responseObject[@"credentials"][@"token"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
        }];
    }else{
        [self refresh];
    }
}

-(void) refresh{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/noodles/media/recent?access_token=%@",self.accessToken];
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    }];
    [task resume];
}

//number of collectionViewCell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photos count];
}

//cell for indexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    bingqingPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *photo = self.photos[indexPath.row];
    
    bingqingDetailViewController *viewController = [[bingqingDetailViewController alloc]init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[bingqingPresentDetailTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[bingqingDismissDetailTransition alloc]init];
}




@end
