//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/12
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRDrawTool.h"
#import "JRColorPanel.h"
#import "Masonry.h"
#import "JRImageEditorGestureManager.h"
#import <XXNibBridge/XXNibBridge.h>
#import "JRUIKit.h"
#import "JRTextToolView.h"

@interface JRDrawTool ()
@property (nonatomic, weak) JRDrawView *canvas;
@property (nonatomic, assign) CGSize originalImageSize;
@property (nonatomic, weak) JRColorPanel *colorPanel;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) dispatch_semaphore_t lock;


@end

@implementation JRDrawTool

- (instancetype)initWithImageEditor:(JRPhotoImageEditorViewController *)editor
{
    self = [super init];
    
    if(self)
    {
        self.lock = dispatch_semaphore_create(1);
        
        self.editor = editor;
        self.allLineMutableArray = [NSMutableArray new];
        self.canvas = self.editor.drawingView;

        JRColorPanel *colorPanel = [JRColorPanel xx_instantiateFromNib];
        colorPanel.backButton.alpha = 0.5f;
        colorPanel.backButton.enabled = NO;
        [editor.view addSubview:colorPanel];
        self.colorPanel = colorPanel;
        [colorPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo([JRColorPanel fixedHeight]);
            make.bottom.mas_equalTo(editor.mainToolBarView.mas_top).mas_offset(0);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visableCurrentTool:) name:@"REATOREACURRENTTOOLBAR" object:nil];
        
        [self setupActions];
    }
    
    return self;
}

- (void)visableCurrentTool:(NSNotification *)notice {
    int currentModel = [notice.object intValue];
    
    if (currentModel == 1) {
        self.editor.currentMode = 0;
        [self.editor panAction];
    }
}

- (void)setupActions
{
    __weak JRDrawTool *weakSelf = self;
    [self.colorPanel setUndoButtonTappedBlock:
    ^{
        __strong JRDrawTool *strongSelf = weakSelf;
        [strongSelf backToLastDraw];
        
        if (strongSelf.allLineMutableArray.count > 0)
        {
            strongSelf.colorPanel.backButton.alpha = 1.0f;
            strongSelf.colorPanel.backButton.enabled = YES;
        }
        else
        {
            strongSelf.colorPanel.backButton.alpha = 0.5f;
            strongSelf.colorPanel.backButton.enabled = NO;
        }
    }];
    
    self.drawToolStatus = ^(BOOL canPrev)
    {
        __strong JRDrawTool *strongSelf = weakSelf;
        if (canPrev)
        {
            strongSelf.colorPanel.backButton.alpha = 1.0f;
            strongSelf.colorPanel.backButton.enabled = YES;

        }
        else
        {
            strongSelf.colorPanel.backButton.alpha = 0.5f;
            strongSelf.colorPanel.backButton.enabled = NO;

        }
    };
    
    self.drawingCallback = ^(BOOL isDrawing)
    {
         __strong JRDrawTool *strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:isDrawing animation:YES];
    };
    
    self.drawingDidTap =
    ^(UITapGestureRecognizer *sender){
         __strong JRDrawTool *strongSelf = weakSelf;
        strongSelf.colorPanel.alpha = 1.0;
    
//        [strongSelf.editor hiddenTopAndBottomBar:!strongSelf.editor.barsHiddenStatus animation:YES];
        //激活文字编辑状态
        for (UIView *subView in strongSelf.editor.containerView.subviews)
        {
            if ([subView isKindOfClass:[JRTextToolView class]])
            {
//                [JRTextToolView setNewActiveTextView:(JRTextToolView *)subView withGesture:sender];
                JRTextToolView *textToolView = (JRTextToolView *)subView;
                [textToolView tapViewMethod:sender];
                
            }
        }
    };
    
    [self.canvas setDrawViewBlock:^(CGContextRef ctx)
    {
        __strong JRDrawTool *strongSelf = weakSelf;
        Lock_Guard_Lock
        (
            strongSelf->_lock,
            NSArray<JRGPath *> *pathArray = [strongSelf.allLineMutableArray copy];
         );
        
        for (JRGPath *path in pathArray)
        {
            [path drawPath];
        }
    }];
}

#pragma mark - implementation 重写父方法

- (void)setup
{
    //初始化一些东西
    self.originalImageSize = self.editor.imageView.image.size;
    self.colorPanel.hidden = NO;
    
    //滑动手势
    if (!self.panGesture)
    {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
        self.panGesture.delegate = [JRImageEditorGestureManager instance];
        self.panGesture.maximumNumberOfTouches = 1;
    }
    
    //点击手势
    if (!self.tapGesture)
    {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidTap:)];
        self.tapGesture.delegate = [JRImageEditorGestureManager instance];
        self.tapGesture.numberOfTouchesRequired = 1;
        self.tapGesture.numberOfTapsRequired = 1;
        
    }
    
    [_canvas addGestureRecognizer:self.panGesture];
//    [_canvas addGestureRecognizer:self.tapGesture];
    _canvas.userInteractionEnabled = YES;
    _canvas.layer.shouldRasterize = YES;
    // 修改线条羽化效果
    //_canvas.layer.minificationFilter = kCAFilterNearest;//kCAFilterLinear;//kCAFilterTrilinear;
    
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    self.panGesture.enabled = YES;
    self.tapGesture.enabled = YES;
    
    self.editor.drawingView.userInteractionEnabled = YES;
}

- (void)cleanup
{
    self.colorPanel.hidden = YES;
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGesture.enabled = NO;
    self.tapGesture.enabled = NO;
}

- (UIView *)drawView
{
    return self.canvas;
}

- (void)hideTools:(BOOL)hidden
{
    if (hidden)
    {
        self.editor.mainToolBarView.alpha = 0;
        self.colorPanel.alpha = 0;
    }
    else
    {
        self.editor.mainToolBarView.alpha = 1.0f;
        self.colorPanel.alpha = 1.0f;
    }
}

- (void)backToLastDraw
{
    Lock_Guard
    (
        [_allLineMutableArray removeLastObject];
    );
    
    [self drawLine];
    
    if (self.drawToolStatus)
    {
        Lock_Guard
        (
            BOOL canPrev = _allLineMutableArray.count > 0 ? YES : NO;
        );
        
        self.drawToolStatus(canPrev);
    }
}

#pragma mark - Gesture
//tap
- (void)drawingViewDidTap:(UITapGestureRecognizer *)sender
{
    if (self.drawingDidTap)
    {
        self.drawingDidTap(sender);
    }
}

//draw
- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:self.canvas];
    
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        // 初始化一个UIBezierPath对象, 把起始点存储到UIBezierPath对象中, 用来存储所有的轨迹点
        JRGPath *path = [JRGPath pathToPoint:currentDraggingPosition pathWidth:MAX(1, self.pathWidth)];
        path.pathColor = self.colorPanel.currentColor;
        
        Lock_Guard
        (
            [_allLineMutableArray addObject:path];
        );
    }
    
    if(sender.state == UIGestureRecognizerStateChanged)
    { // 获得数组中的最后一个UIBezierPath对象(因为我们每次都把UIBezierPath存入到数组最后一个,因此获取时也取最后一个)
        
        Lock_Guard
        (
         JRGPath *path = [_allLineMutableArray lastObject];
        );
        
        [path pathLineToPoint:currentDraggingPosition];//添加点
        [self drawLine];
        
        if (self.drawingCallback)
        {
            self.drawingCallback(YES);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (self.drawToolStatus)
        {
            Lock_Guard
            (
                BOOL canPrev = _allLineMutableArray.count > 0 ? YES : NO;
            );
            
            self.drawToolStatus(canPrev);
        }
        
        if (self.drawingCallback)
        {
            self.drawingCallback(NO);
        }
    }
}

#pragma mark - Draw
- (void)drawLine
{
    [self.canvas setNeedDraw];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
