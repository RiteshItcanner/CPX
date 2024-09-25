//
//  UIView+Extension.swift
//  Saudi Coupon
//
//  Created by Appbirds on 21/02/19.
//  Copyright © 2019 Appbirds. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    
    func setLTRLayout() {
        self.semanticContentAttribute = .forceLeftToRight
        for subview in self.subviews {
            subview.setLTRLayout()
        }
    }
    
    @IBInspectable var borderWidthNew: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadiusNew: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColorNew: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 9.0) {
        
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = #colorLiteral(red: 0.4666666667, green: 0.6039215686, blue: 0.9450980392, alpha: 0.4792418574)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

class ShadowBoxView: UIView {
    
    var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 5
    private var fillColor: UIColor = .white
    private let shadowH: CGFloat = 3
    private let shadowRadius: CGFloat = 1
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //    self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        
        if shadowLayer != nil {
            shadowLayer.removeFromSuperlayer()
            shadowLayer = nil
        }
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0.1137254902, alpha: 0.2)// #colorLiteral(red: 0.9019607843, green: 0.9294117647, blue: 0.9921568627, alpha: 1)
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: shadowH)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = shadowRadius
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
//    func removeShadowLayer() {
//        if shadowLayer != nil {
//            shadowLayer.removeFromSuperlayer()
//            shadowLayer = nil
//        }
//    }
//
//    func updateShadowFrames() {
//        if let layerFound = layer.sublayers?.first as? CAShapeLayer {
//            layerFound.removeFromSuperlayer()
//
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//            shadowLayer.fillColor = fillColor.cgColor
//
//            shadowLayer.shadowColor = #colorLiteral(red: 0.4666666667, green: 0.6039215686, blue: 0.9450980392, alpha: 0.5)
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0.0, height: shadowH)
//            shadowLayer.shadowOpacity = 1
//            shadowLayer.shadowRadius = shadowRadius
//
//            layer.insertSublayer(shadowLayer, at: 0)
//        }
//    }
//
//    func updateShadowToReduceRadius() {
//        removeShadowLayer()
//
//        if let layerFound = layer.sublayers?.first as? CAShapeLayer {
//            layerFound.removeFromSuperlayer()
//        }
//        shadowLayer = CAShapeLayer()
//
//        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//        shadowLayer.fillColor = fillColor.cgColor
//
//        shadowLayer.shadowColor = #colorLiteral(red: 0.9019607843, green: 0.9294117647, blue: 0.9921568627, alpha: 1)
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: 0.0, height: shadowH)
//        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowRadius = shadowRadius
//
//        layer.insertSublayer(shadowLayer, at: 0)
//    }
}

extension UIView {
    
    func flipView() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    enum Size: CGFloat {
        case zero = 0, one = 1, two = 2, three = 3, small = 4,five = 5, medium = 8, large = 12, tewntyFive = 25, thirty = 30, thirtyOne = 31, thirtyTwo = 32, thirtyFive = 45
    }
    
    func makeCircular() {
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }
    
    func makeCircular(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func applyRoundedCorner(size: Size = .small) {
        layer.cornerRadius = size.rawValue
        clipsToBounds = true
    }
 
    func dropShadowWithCALayer(color: UIColor, cornerRadius: UIView.Size, shadowRadius: CGFloat = 2) {
        layer.addShadow(color: color, cornerRadius: cornerRadius, shadowRadius: shadowRadius)
    }
    
    func roundCorners(corners: UIRectCorner, radius: Size = .small) -> Void {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius.rawValue, height: radius.rawValue))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}

class FourShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: Constant.ShadowRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: -1)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = 10
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class MainBackground: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.makeCircular()
        self.dropShadowWithCALayer(color: .lightGray, cornerRadius: .tewntyFive, shadowRadius: 3)
        
    }
}

class MainBackgroundTwo: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.makeCircular()
        self.dropShadowWithCALayer(color: .lightGray, cornerRadius: .thirty, shadowRadius: 3)
        
    }
}

class MainBackground70: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.makeCircular()
        self.dropShadowWithCALayer(color: .lightGray, cornerRadius: .five, shadowRadius: 3)
        
    }
}


class Border: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircular()
    }
}

// MARK: Gesture Extensions
extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    /// EZSwiftExtensions
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }


    /// EZSwiftExtensions
    public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction

        #if os(iOS)

        swipe.numberOfTouchesRequired = numberOfTouches

        #endif

        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }

    

    /// EZSwiftExtensions
    public func addPanGesture(target: AnyObject, action: Selector) {
        let pan = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }


    #if os(iOS)

    /// EZSwiftExtensions
    public func addPinchGesture(target: AnyObject, action: Selector) {
        let pinch = UIPinchGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
    }

    #endif

   

    /// EZSwiftExtensions
    public func addLongPressGesture(target: AnyObject, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }

}

extension CALayer {
    
    func addShadow(color: UIColor, cornerRadius: UIView.Size, shadowRadius: CGFloat = 4) {
        self.cornerRadius = cornerRadius.rawValue
        self.shadowOffset = .zero
        self.shadowOpacity = 0.8
        self.shadowRadius = shadowRadius
        self.shadowColor = color.cgColor //UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1).cgColor //color.cgColor
        self.masksToBounds = false
        if cornerRadius.rawValue != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        masksToBounds = false
        sublayers?.filter{ $0.frame.equalTo(self.bounds) }
            .forEach{ $0.roundCorners(radius: self.cornerRadius) }
        self.contents = nil
        if let sublayer = sublayers?.first,
            sublayer.name == "Constants.contentLayerName" {
            sublayer.removeFromSuperlayer()
        }
        let contentLayer = CALayer()
        contentLayer.name = "Constants.contentLayerName"
        contentLayer.contents = contents
        contentLayer.frame = bounds
        contentLayer.cornerRadius = cornerRadius
        contentLayer.masksToBounds = true
        insertSublayer(contentLayer, at: 0)
    }
}

// MARK: Frame Extensions
extension UIView {
    //TODO: Add pics to readme
    /// EZSwiftExtensions, resizes this view so it fits the largest subview
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            let newWidth = aView.x + aView.width
            let newHeight = aView.y + aView.height
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// EZSwiftExtensions, resizes this view so it fits the largest subview
    public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth = aView.x + aView.width
                let newHeight = aView.y + aView.height
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// EZSwiftExtensions
    public func resizeToFitWidth() {
        let currentHeight = self.height
        self.sizeToFit()
        self.height = currentHeight
    }

    /// EZSwiftExtensions
    public func resizeToFitHeight() {
        let currentWidth = self.width
        self.sizeToFit()
        self.width = currentWidth
    }

    /// EZSwiftExtensions
    @objc public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.width, height: self.height)
        }
    }

    /// EZSwiftExtensions
    @objc public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.width, height: self.height)
        }
    }

    /// EZSwiftExtensions
    @objc public var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.height)
        }
    }

    /// EZSwiftExtensions
    @objc public var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.width, height: value)
        }
    }

    /// EZSwiftExtensions
    @objc public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    /// EZSwiftExtensions
    @objc public var right: CGFloat {
        get {
            return self.x + self.width
        } set(value) {
            self.x = (self.superview?.width ?? 0) - self.width - value //value - self.width
        }
    }
    
    /// EZSwiftExtensions
    @objc public var rightView: CGFloat {
        get {
            return self.x + self.width
        } set(value) {
            self.x = value - self.width
        }
    }
    

    /// EZSwiftExtensions
    @objc public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    /// EZSwiftExtensions
    @objc public var bottom: CGFloat {
        get {
            return self.y + self.height
        } set(value) {
            self.y = value - self.height
        }
    }

    /// EZSwiftExtensions
    @objc public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    /// EZSwiftExtensions
    @objc public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    /// EZSwiftExtensions
    @objc public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    /// EZSwiftExtensions
    @objc public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    /// EZSwiftExtensions
    public func leftOffset(_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }

    /// EZSwiftExtensions
    public func rightOffset(_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }

    /// EZSwiftExtensions
    public func topOffset(_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }

    /// EZSwiftExtensions
    public func bottomOffset(_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
    /// SwifterSwift: First responder.
    public var firstResponder: UIView? {
        guard !isFirstResponder else {
            return self
        }
        for subView in subviews {
            if subView.isFirstResponder {
                return subView
            }
        }
        return nil
    }

    //TODO: Add to readme
    /// EZSwiftExtensions
    public func alignRight(_ offset: CGFloat) -> CGFloat {
        return self.width - offset
    }

    /// EZSwiftExtensions
    public func reorderSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                if reorder {
                    let aView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }

    /// EZSE: Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.x = parentView.width/2 - self.width/2
    }

    /// EZSE: Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.y = parentView.height/2 - self.height/2
    }

    /// EZSE: Centers view in superview horizontally & vertically
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }
}

//TODO: add to readme
extension UIView {
    /// EZSwiftExtensions [UIRectCorner.TopLeft, UIRectCorner.TopRight]
    @objc func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func RoundedView(){
            let maskPath1 = UIBezierPath(roundedRect: bounds,
                byRoundingCorners: [.topLeft , .topRight],
                cornerRadii: CGSize(width: 8, height: 8))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = bounds
            maskLayer1.path = maskPath1.cgPath
            layer.mask = maskLayer1
        }
    
    @objc func applyCornerRadius(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }

    /// EZSwiftExtensions
    func roundView() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
    }
    
    func semiCircleView(backgroudColor: UIColor) {
        let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height)
        let circleRadius = bounds.size.width / 2
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let semiCirleLayer = CAShapeLayer()
        semiCirleLayer.path = circlePath.cgPath
        semiCirleLayer.fillColor = backgroudColor.cgColor
//        layer.addSublayer(semiCirleLayer)
        layer.insertSublayer(semiCirleLayer, at: 0)
    }
    
    func addDashedBorder() {
        self.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }

        let color = UIColor(named: "theme_blue")!.cgColor // Change to your preferred color
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [6, 3] // Dash pattern (6 points on, 3 points off)
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 12).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }

    
}

class BetaBadgeView: UIView {
    
    init(text: String) {
        super.init(frame: .zero)
        
        // Configure the label
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        
        // Configure the background
        self.backgroundColor = .red
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        // Add label to the view
        self.addSubview(label)
        
        // Set constraints for the label
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
