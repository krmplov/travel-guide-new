import UIKit

final class PlacesListViewController: UIViewController, PlacesListView {
    private var viewModel: PlacesListViewModel
    private let listManager = PlacesListTableManager()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск мест"
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = DS.Color.brand
        searchBar.searchTextField.font = DS.Typography.body
        searchBar.searchTextField.textColor = DS.Color.text
        searchBar.searchTextField.backgroundColor = DS.Color.surface
        searchBar.searchTextField.layer.cornerRadius = DS.Radius.medium
        searchBar.searchTextField.layer.borderWidth = DS.BorderWidth.standard
        searchBar.searchTextField.layer.borderColor = DS.Color.border.cgColor
        searchBar.searchTextField.clipsToBounds = true
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
        tableView.backgroundColor = DS.Color.background
        tableView.separatorColor = DS.Color.border
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

    private lazy var stateView: DSState = {
        let view = DSState()
        view.onRetry = { [weak self] in
            self?.viewModel.didLoad()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.backgroundColor = DS.Color.background
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
        view.addSubview(stateView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func update(_ state: PlacesListViewState) {
        switch state {
        case .loading(let isRefreshing):
            if isRefreshing {
                tableView.isHidden = false
                stateView.render(.hidden)
            } else {
                tableView.isHidden = true
                stateView.render(.loading(text: "Загрузка мест..."))
            }

        case .content(let items):
            listManager.setItems(items)
            tableView.reloadData()

            endRefreshingIfNeeded()
            tableView.backgroundView = nil
            stateView.render(.hidden)
            tableView.isHidden = false

        case .empty(let message, let showsInlineInList):
            endRefreshingIfNeeded()

            if showsInlineInList {
                listManager.setItems([])
                tableView.reloadData()
                let emptyView = DSEmpty()
                emptyView.configure(text: message)
                tableView.backgroundView = emptyView
                tableView.isHidden = false
                stateView.render(.hidden)
            } else {
                tableView.backgroundView = nil
                tableView.isHidden = true
                stateView.render(.empty(text: message))
            }

        case .error(let message):
            endRefreshingIfNeeded()
            tableView.backgroundView = nil
            tableView.isHidden = true
            stateView.render(.error(message: "Ошибка:\n\(message)", retryTitle: "Повторить"))
        }
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
