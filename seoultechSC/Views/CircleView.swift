//import Foundation
//
//class CircleView : UIView {
//    // round view
//    let roundView = UIView(
//        frame: CGRect(
//            x: circleContainerView.bounds.origin.x,
//            y: circleContainerView.bounds.origin.y,
//            width: circleContainerView.bounds.size.width - 4,
//            height: circleContainerView.bounds.size.height - 4
//        )
//    )
//    roundView.backgroundColor = .white
//    roundView.layer.cornerRadius = roundView.frame.size.width / 2
//
//    // bezier path
//    let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
//                                  radius: roundView.frame.size.width / 2,
//                                  startAngle: CGFloat(-0.5 * .pi),
//                                  endAngle: CGFloat(1.5 * .pi),
//                                  clockwise: true)
//    // circle shape
//    let circleShape = CAShapeLayer()
//    circleShape.path = circlePath.cgPath
//    circleShape.strokeColor = UIColor.customColor?.cgColor
//    circleShape.fillColor = UIColor.clear.cgColor
//    circleShape.lineWidth = 4
//    // set start and end values
//    circleShape.strokeStart = 0.0
//    circleShape.strokeEnd = 0.8
//
//    // add sublayer
//    roundView.layer.addSublayer(circleShape)
//    // add subview
//    circleContainerView.addSubview(roundView)
//}
