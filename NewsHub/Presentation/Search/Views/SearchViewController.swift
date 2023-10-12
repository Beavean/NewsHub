//
//  SearchViewController.swift
//  NewsHub
//
//  Created by Anton Petrov on 11.10.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - UI Elements

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let filterActivityIndicator = UIActivityIndicatorView(style: .medium)
    private let refreshControl = UIRefreshControl()
    private lazy var filterButton = UIBarButtonItem(title: LocalizedString.filterButton.localized,
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(openFilterController))
    private let searchField = UISearchBar().apply {
        $0.placeholder = LocalizedString.searchPlaceholder.localized
        $0.textContentType = .none
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartQuotesType = .no
    }

    private let tableView = UITableView().apply {
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
    }

    private let loadingCell = UITableViewCell(style: .default, reuseIdentifier: #function).apply {
        $0.textLabel?.text = LocalizedString.loadingArticles.localized
        $0.textLabel?.textAlignment = .center
    }

    // MARK: - Properties

    private let viewModel: SearchViewModel

    // MARK: - Initialization

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActivityIndicator()
        setupTableView()
        setupRefreshControl()
        setupViewModelCallbacks()
        viewModel.fetchNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc func openFilterController() {
        let loadingButton = UIBarButtonItem(customView: filterActivityIndicator)
        navigationItem.rightBarButtonItem = loadingButton
        filterActivityIndicator.startAnimating()
        viewModel.fetchSources { [weak self] sources, error in
            guard let self else { return }
            self.navigationItem.rightBarButtonItem = self.filterButton
            if let sources {
                let filterController = FilterSelectionViewController(sources: sources, request: self.viewModel.request)
                filterController.delegate = self
                self.navigationController?.pushViewController(filterController, animated: true)
            } else if let error {
                self.showAlert(message: error.userLocalizedDescription)
            }
        }
    }

    @objc private func refreshNewsData() {
        viewModel.refreshNews()
    }

    // MARK: - Setup

    private func setupViewModelCallbacks() {
        viewModel.isLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }

        viewModel.onArticlesUpdated = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                guard self.viewModel.numberOfArticles > 0 else { return }
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }

        viewModel.onArticlesAdded = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }

        viewModel.onErrorOccurred = { [weak self] error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.showAlert(message: error)
            }
        }
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.titleView = searchField
        searchField.delegate = self
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UINib(nibName: ArticleTableViewCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
    }

    private func setupActivityIndicator() {
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.leftBarButtonItem = barButton
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshNewsData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.StyleDefaults.articleCellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfArticles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.hasMoreArticles && indexPath.row == viewModel.numberOfArticles - 1 {
            viewModel.fetchMoreNewsIfNeeded()
            return loadingCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? ArticleTableViewCell,
                let viewModel = viewModel.getCellViewModel(forIndex: indexPath.row)
            else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel.getWebViewModel(forIndex: indexPath.row) else { return }
        let webVC = WebViewController(viewModel: viewModel)
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.fetchNews(withQuery: searchBar.text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else { return }
        viewModel.fetchNews(withQuery: searchText)
    }
}

// MARK: - FilterSelectionDelegate

extension SearchViewController: FilterSelectionDelegate {
    func didUpdateNewsRequest(_ request: NewsRequest) {
        viewModel.fetchNews(withRequest: request)
    }
}
