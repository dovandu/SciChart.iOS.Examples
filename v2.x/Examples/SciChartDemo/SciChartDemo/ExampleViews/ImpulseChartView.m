//
//  SCIImpulseChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 9/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ImpulseChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ImpulseChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData{
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];

    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    DoubleSeries *ds1Points = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.05 PointCount:50 Freq:5];
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [dataSeries appendRangeX:ds1Points.xValues Y:ds1Points.yValues Count:ds1Points.size];
    
    SCIEllipsePointMarker *ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setStrokeStyle:nil];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF0066FF]];
    [ellipsePointMarker setHeight:10];
    [ellipsePointMarker setWidth:10];
    
    SCIFastImpulseRenderableSeries *impulseSeries = [[SCIFastImpulseRenderableSeries alloc] init];
    impulseSeries.dataSeries = dataSeries;
    impulseSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0066FF withThickness:1.0];
    impulseSeries.style.pointMarker = ellipsePointMarker;
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    [surface.renderableSeries add:impulseSeries];
    [self addModifiers];
    
    [surface invalidateElement];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
}

@end