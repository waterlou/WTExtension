//
//  WTStaticTableDataSource.m
//  WTStaticTableViewDemo
//
//  Created by Water Lou on 21/2/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import "WTStaticTableDataSource.h"

@interface WTStaticTableRow : NSObject

@property (nonatomic, copy) void (^setupBlock)(UITableViewCell*);
@property (nonatomic, copy) void(^selectBlock)(UITableView*, NSIndexPath*);
@property (nonatomic, copy) NSString *identifier;

@end

@implementation WTStaticTableRow

@end

@interface WTStaticTableSection : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *rows;

- (void) setRow: (WTStaticTableRow*)row atIndex:(NSInteger)index;
- (void) insertRow: (WTStaticTableRow*)row atIndex:(NSInteger)index;

@end

@implementation WTStaticTableSection

- (id) init
{
    self = [super init];
    if (self)
    {
        self.rows = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
- (void) dealloc
{
    // for testing cyclic lock
    NSLog(@"releasing data source");
}
*/

- (void) setRow: (WTStaticTableRow*)row atIndex:(NSInteger)index
{
    if (index < self.rows.count) {
        self.rows[index] = row;
    }
    else {
        // create dummy row until fill up
        while (index > self.rows.count) {
            WTStaticTableRow *dummy = [[WTStaticTableRow alloc] init];
            [self.rows addObject: dummy];
        }
        [self.rows insertObject:row atIndex:index];
    }
}

- (void) insertRow: (WTStaticTableRow*)row atIndex:(NSInteger)index
{
    if (index < self.rows.count) {
    }
    else {
        // create dummy row until fill up
        while (index > self.rows.count) {
            WTStaticTableRow *dummy = [[WTStaticTableRow alloc] init];
            [self.rows addObject: dummy];
        }
    }
    [self.rows insertObject:row atIndex:index];
}

@end



@interface WTStaticTableDataSource() {
    NSMutableArray *_cellData;
    Class _cellClass;
}

- (WTStaticTableRow *) getItemAtIndexPath : (NSIndexPath *) indexPath;

@end

@interface WTStaticTableDataSource(UITableViewDataSourceAndDelegate)<UITableViewDataSource, UITableViewDelegate>
@end


@implementation WTStaticTableDataSource

- (id) init
{
    self = [super init];
    if (self)
    {
        _cellData = [[NSMutableArray alloc] init];
        _rowHeight = 44.0f;
        _cellClass = [UITableViewCell class];
    }
    return self;
}

- (void)registerClass:(Class)cellClass
{
    _cellClass = cellClass;
}


/* get the section object, create it if not exist */
- (WTStaticTableSection *) sectionData : (NSInteger) section
{
    if (section < _cellData.count) {
        return _cellData[section];
    }
    else {
        WTStaticTableSection *sectionData;
        while (section+1 > _cellData.count) {
            sectionData = [[WTStaticTableSection alloc] init];
            [_cellData addObject: sectionData];
        }
        return sectionData;
    }
}

- (void) setCellAtIndexPath:(NSIndexPath *)indexPath
                  identifier:(NSString *)identifier
                onSetupCell:(void(^)(UITableViewCell*))setupCellBlock
                   onSelect:(void(^)(UITableView*, NSIndexPath*))selectBlockOrNil
{
    WTStaticTableRow *row = [[WTStaticTableRow alloc] init];
    row.identifier = identifier;
    NSAssert(setupCellBlock!=nil, @"setupCellBlock cannot be nil");
    row.setupBlock = setupCellBlock;
    if (selectBlockOrNil) row.selectBlock = selectBlockOrNil;
    WTStaticTableSection *sectionData = [self sectionData: indexPath.section];
    [sectionData setRow:row atIndex:indexPath.row];
}

- (void) insertCellAtIndexPath:(NSIndexPath *)indexPath
                     identifier:(NSString *)identifier
                   onSetupCell:(void(^)(UITableViewCell*))setupCellBlock
                      onSelect:(void(^)(UITableView*, NSIndexPath*))selectBlockOrNil
{
    WTStaticTableRow *row = [[WTStaticTableRow alloc] init];
    row.identifier = identifier;
    NSAssert(setupCellBlock!=nil, @"setupCellBlock cannot be nil");
    row.setupBlock = setupCellBlock;
    if (selectBlockOrNil) row.selectBlock = selectBlockOrNil;
    WTStaticTableSection *sectionData = [self sectionData: indexPath.section];
    [sectionData insertRow:row atIndex:indexPath.row];
}

- (void) appendCellAtSection:(NSInteger) section
                   identifier:(NSString *)identifier
                 onSetupCell:(void(^)(UITableViewCell*))setupCellBlock
                    onSelect:(void(^)(UITableView*, NSIndexPath*))selectBlockOrNil
{
    //NSLog(@"inserting at section %d", section);
    WTStaticTableSection *sectionData = [self sectionData: section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionData.rows.count inSection:section];
    [self setCellAtIndexPath:indexPath identifier:identifier onSetupCell:setupCellBlock onSelect:selectBlockOrNil];
}

- (void) moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
    //TODO: not implemented
}

- (void) deleteCellAtIndexPath:(NSIndexPath *)indexPath
{
    WTStaticTableSection *sectionData = _cellData[indexPath.section];
    [sectionData.rows removeObjectAtIndex:indexPath.row];
}


- (void) setSection:(NSInteger)section header:(NSString*)header
{
    WTStaticTableSection *sectionData = [self sectionData: section];
    sectionData.header = header;
}

- (void) setSection:(NSInteger)section footer:(NSString*)footer
{
    WTStaticTableSection *sectionData = [self sectionData: section];
    sectionData.footer = footer;
}


- (void) removeAllObjects
{
    [_cellData removeAllObjects];
}
- (void) removeAllObjectsAtSection:(NSInteger)section
{
    WTStaticTableSection *sectionData = _cellData[section];
    [sectionData.rows removeAllObjects];
}

- (WTStaticTableRow *) getItemAtIndexPath : (NSIndexPath *) indexPath
{
    WTStaticTableSection *sectionData = _cellData[indexPath.section];
    return sectionData.rows[indexPath.row];
}


@end

@implementation WTStaticTableDataSource(UITableViewDataSourceAndDelegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WTStaticTableSection *sectionData = _cellData[section];
    return sectionData.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTStaticTableRow *rowData = [self getItemAtIndexPath: indexPath];
    UITableViewCell *cell;
    NSString *cellIdentifier = rowData.identifier;
    if (cellIdentifier==nil) cellIdentifier = @"GenericStaticTableCell";
    cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell==nil) {
        cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    rowData.setupBlock(cell);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cellData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WTStaticTableSection *sectionData = _cellData[section];
    return sectionData.header;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    WTStaticTableSection *sectionData = _cellData[section];
    return sectionData.footer;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
 */

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteCellAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    WTStaticTableSection *fromSection = [self sectionData: fromIndexPath.section];
    WTStaticTableRow *row = fromSection.rows[fromIndexPath.row];
    [fromSection.rows removeObject: row];
    WTStaticTableSection *toSection = fromIndexPath.section==toIndexPath.section ? fromSection : [self sectionData: toIndexPath.section];
    [toSection insertRow:row atIndex:toIndexPath.row];
}



///////////////////////////////////////////////////
// Delegate
///////////////////////////////////////////////////

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WTStaticTableRow *rowData = [self getItemAtIndexPath: indexPath];
    if (rowData.selectBlock) {
        rowData.selectBlock(tableView, indexPath);
    }
}

@end

