//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DonutChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DonutChartView: SinglePieChartWithLegendLayout {

    override func initExample() {
        let donutSeries = SCIDonutRenderableSeries()

        // hiding the donut Renderable series - needed for animation
        // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
        donutSeries.isVisible = false

        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 40, title: "Green", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 10, title: "Red", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 20, title: "Blue", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 15, title: "Yellow", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffFFFF00, finish: 0xfffed325)))

        // adding animations for the donut renderable series
        DispatchQueue.main.async {
            donutSeries.animate(0.7)
            donutSeries.isVisible = true
        }
        
        let legendModifier = SCIPieLegendModifier()
        legendModifier.orientation = .vertical;
        legendModifier.position = .bottom;
        legendModifier.sourceSeries = donutSeries;
        
        // setting the DonutChart's hole radius
        pieChartSurface.holeRadius = 100

        pieChartSurface.renderableSeries.add(donutSeries)
        pieChartSurface.chartModifiers.add(legendModifier)
        pieChartSurface.chartModifiers.add(SCIPieSelectionModifier())
    }
    
    func buildSegmentWithValue(segmentValue: Double, title: String, gradientBrush: SCIRadialGradientBrushStyle) -> SCIPieSegment {
        let segment = SCIPieSegment()
        segment.fillStyle = gradientBrush
        segment.value = segmentValue
        segment.title = title

        return segment
    }
}
