//
//  WTStaticTableDataSource.h
//  WTStaticTableViewDemo
//
//  Created by Water Lou on 21/2/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTStaticTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (void) setCellAtIndexPath:(NSIndexPath *)indexPath
                  identifier:(NSString *)identifier
                onSetupCell:(void(^)(UITableViewCell*))setupCellBlock
                   onSelect:(void(^)(UITableView*, NSIndexPath*))selectBlockOrNil;

- (void) insertCellAtIndexPath:(NSIndexPath *)indexPath
                     identifier:(NSString *)identifier
                   onSetupCell:(void(^)(UITableViewCell*))setupCellBlock
                      onSelect:(void(^)(UITableView*, NSIndexPath*))selectBlockOrNil;

- (void) appendCellAtSection:(NSInteger) section
                   identifier:(NSString *)identifier
                 onSetupCell:(void(^)(UITableViewCell*))setupCellBlock
                    onSelect:(void(^)(UITableView*, NSIndexPath*))selectBlockOrNil;

- (void) moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath;
- (void) deleteCellAtIndexPath:(NSIndexPath *)indexPath;

- (void) setSection:(NSInteger)section header:(NSString*)header;
- (void) setSection:(NSInteger)section footer:(NSString*)footer;

- (void) removeAllObjects;
- (void) removeAllObjectsAtSection:(NSInteger)section;

@property (nonatomic, assign) CGFloat rowHeight;

- (void)registerClass:(Class)cellClass; // default cell class, otherwise simple cell only

@end
