import UIKit

final class DSState: UIView {
    enum State: Equatable {
        case hidden
        case loading(text: String)
        case empty(text: String)
        case error(message: String, retryTitle: String)
    }

    private lazy var loadingView = DSLoading()
    private lazy var emptyView = DSEmpty()
    private lazy var errorView: DSError = {
        let view = DSError()
        view.onRetry = { [weak self] in
            self?.onRetry?()
        }
        return view
    }()

    var onRetry: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        render(.hidden)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = DS.Color.background
        translatesAutoresizingMaskIntoConstraints = false

        [loadingView, emptyView, errorView].forEach { subview in
            addSubview(subview)

            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    func render(_ state: State) {
        switch state {
        case .hidden:
            isHidden = true
            loadingView.isHidden = true
            emptyView.isHidden = true
            errorView.isHidden = true

        case .loading(let text):
            isHidden = false
            loadingView.isHidden = false
            emptyView.isHidden = true
            errorView.isHidden = true
            loadingView.configure(text: text)

        case .empty(let text):
            isHidden = false
            loadingView.isHidden = true
            emptyView.isHidden = false
            errorView.isHidden = true
            emptyView.configure(text: text)

        case .error(let message, let retryTitle):
            isHidden = false
            loadingView.isHidden = true
            emptyView.isHidden = true
            errorView.isHidden = false
            errorView.configure(message: message, retryTitle: retryTitle)
        }
    }
}
