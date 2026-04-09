import UIKit

enum TextStyle {
    case headingXL
    case headingL
    case headingM
    case headingS
    case body
    case bodyStrong
    case bodySmall
    case caption
    case error
}

extension UILabel {
    func apply(_ style: TextStyle) {
        switch style {
        case .headingXL:
            font = DS.Typography.headingXL
            textColor = DS.Color.text
        case .headingL:
            font = DS.Typography.headingL
            textColor = DS.Color.text
        case .headingM:
            font = DS.Typography.headingM
            textColor = DS.Color.text
        case .headingS:
            font = DS.Typography.headingS
            textColor = DS.Color.text
        case .body:
            font = DS.Typography.body
            textColor = DS.Color.text
        case .bodyStrong:
            font = DS.Typography.bodyStrong
            textColor = DS.Color.text
        case .bodySmall:
            font = DS.Typography.bodySmall
            textColor = DS.Color.text
        case .caption:
            font = DS.Typography.caption
            textColor = DS.Color.textSubtle
        case .error:
            font = DS.Typography.error
            textColor = DS.Color.danger
        }
    }
}
