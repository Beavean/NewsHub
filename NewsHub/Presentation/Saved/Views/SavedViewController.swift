//
//  SavedViewController.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

final class SavedViewController: UIViewController {
    private let tableView = UITableView().apply {
        $0.keyboardDismissMode = .onDrag
    }

    private let searchBar = UISearchBar().apply {
        $0.placeholder = LocalizedString.searchPlaceholder.localized
        $0.textContentType = .none
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartQuotesType = .no
        $0.returnKeyType = .done
        $0.showsCancelButton = true
    }

    private let viewModel: SavedViewModel

    // MARK: - Initialization

    init(viewModel: SavedViewModel) {
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
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSavedArticles()
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setup() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: ArticleTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.StyleDefaults.articleCellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ArticleTableViewCell
        else { return UITableViewCell() }
        let article = viewModel.filteredArticles[indexPath.row]
        let articleVM = ArticleCellViewModel(from: article, realmManager: viewModel.realmManager)
        cell.configure(with: articleVM)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteArticle(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension SavedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel.getWebViewModel(forIndex: indexPath.row) else { return }
        let webVC = WebViewController(viewModel: viewModel)
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SavedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterArticles(with: searchText)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.fetchSavedArticles()
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
