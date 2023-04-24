import UIKit

class CircularProgressBar: UIView {
    
    private var gradientLayer = CAGradientLayer()
    
    private let progressLayer = CAShapeLayer()
    private let progressPath = UIBezierPath()
    
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    private var _progressValue: CGFloat = 0.75
    private var lineWidth: CGFloat = 3
    
    var strokeEnd: CGFloat = 0.8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw(self.bounds)
        setProgress(self.bounds)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        draw(self.bounds)
        setProgress(self.bounds)
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 18, startAngle: -.pi / 2, endAngle: (.pi * 2) - (.pi / 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineCap = .round
        
        let color: UIColor = .lightGrey
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.strokeEnd = 1
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func setProgress(_ rect: CGRect) {
        
        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 18, startAngle: -.pi / 2, endAngle: (.pi * 2) - (.pi / 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineCap = .round
        
        let color: UIColor = .primaryPurple
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.strokeEnd = strokeEnd
        
        self.layer.addSublayer(shapeLayer)
    }
}
