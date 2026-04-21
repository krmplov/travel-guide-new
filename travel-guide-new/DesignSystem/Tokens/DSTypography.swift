import UIKit

extension DS {
    enum Typography {
        static let headingXL = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let headingL = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let headingM = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let headingS = UIFont.systemFont(ofSize: 16, weight: .semibold)

        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let bodyStrong = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let bodySmall = UIFont.systemFont(ofSize: 14, weight: .regular)

        static let caption = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let error = UIFont.systemFont(ofSize: 13, weight: .regular)

        static let button = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
}
