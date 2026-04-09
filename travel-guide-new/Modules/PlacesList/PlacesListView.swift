import UIKit

final class PlacesListViewController: UIViewController, PlacesListView {
    private var viewModel: PlacesListViewModel
    private let listManager = PlacesListTableManager()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск мест"
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        searchBar.sizeToFit()
        return searchBar
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        tableView.dataSource = listManager
        tableView.delegate = listManager
        tableView.register(
            PlaceTableViewCell.self,
            forCellReuseIdentifier: PlaceTableViewCell.reuseIdentifier
        )
        tableView.refreshControl = refreshControl
        tableView.tableHeaderView = searchBar
        return tableView
    }()

    private lazy var stateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Повторить", for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()

    private lazy var tableBackgroundLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    init(viewModel: PlacesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Места"

        setupUI()
        listManager.delegate = self

        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.update(state)
            }
        }

        viewModel.didLoad()
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(stateContainerView)
        stateContainerView.addSubview(activityIndicator)
        stateContainerView.addSubview(statusLabel)
        stateContainerView.addSubview(retryButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stateContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stateContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stateContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.topAnchor.constraint(equalTo: stateContainerView.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),

            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: stateContainerView.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: stateContainerView.trailingAnchor),

            retryButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: stateContainerView.bottomAnchor)
        ])
    }

    func update(_ state: PlacesListViewState) {
        switch state {
        case .loading(let isRefreshing):
            if isRefreshing {
                tableView.isHidden = false
                stateContainerView.isHidden = true
                activityIndicator.stopAnimating()
                statusLabel.isHidden = true
                retryButton.isHidden = true
            } else {
                tableView.isHidden = true
                stateContainerView.isHidden = false
                activityIndicator.startAnimating()
                statusLabel.isHidden = false
                statusLabel.text = "Загрузка мест..."
                retryButton.isHidden = true
            }

        case .content(let items):
            listManager.setItems(items)
            tableView.reloadData()

            endRefreshingIfNeeded()
            tableView.backgroundView = nil
            activityIndicator.stopAnimating()
            stateContainerView.isHidden = true
            statusLabel.isHidden = true
            retryButton.isHidden = true
            tableView.isHidden = false

        case .empty(let message, let showsInlineInList):
            endRefreshingIfNeeded()
            activityIndicator.stopAnimating()
            retryButton.isHidden = true

            if showsInlineInList {
                listManager.setItems([])
                tableView.reloadData()
                tableBackgroundLabel.text = message
                tableView.backgroundView = tableBackgroundLabel
                tableView.isHidden = false
                stateContainerView.isHidden = true
                statusLabel.isHidden = true
            } else {
                tableView.backgroundView = nil
                tableView.isHidden = true
                stateContainerView.isHidden = false
                statusLabel.isHidden = false
                statusLabel.text = message
            }

        case .error(let message):
            endRefreshingIfNeeded()
            tableView.backgroundView = nil
            tableView.isHidden = true
            stateContainerView.isHidden = false
            activityIndicator.stopAnimating()
            statusLabel.isHidden = false
            statusLabel.text = "Ошибка:\n\(message)"
            retryButton.isHidden = false
        }
    }

    @objc
    private func didTapRetry() {
        viewModel.didLoad()
    }

    @objc
    private func didPullToRefresh() {
        viewModel.didPullToRefresh()
    }

    private func endRefreshingIfNeeded() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension PlacesListViewController: PlacesListTableManagerDelegate {
    func placesListTableManagerDidSelectPlace(id: Int) {
        viewModel.didSelectPlace(id: id)
    }
}

extension PlacesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didChangeSearchQuery(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel.didChangeSearchQuery("")
        searchBar.resignFirstResponder()
    }
}
