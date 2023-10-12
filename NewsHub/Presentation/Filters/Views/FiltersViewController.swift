//
//  FiltersViewController.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import UIKit

protocol FilterSelectionDelegate: AnyObject {
    func didUpdateNewsRequest(_ request: NewsRequest)
}

final class FilterSelectionViewController: UITableViewController {
    // MARK: - Properties & UI Elements

    private var segmentedControl: UISegmentedControl!
    private let cellReuseIdentifier = "filterCell"
    private var viewModel: FilterSelectionViewModel
    weak var delegate: FilterSelectionDelegate?

    // MARK: - Initialization

    init(sources: [Source], request: NewsRequest) {
        viewModel = FilterSelectionViewModel(sources: sources, request: request)
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorInset = .zero
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupSegmentedControl()
    }

    // MARK: - Actions

    @objc private func segmentChanged() {
        viewModel.switchFilterMode(to: segmentedControl.selectedSegmentIndex)
        tableView.reloadData()
    }

    @objc private func saveButtonTapped() {
        delegate?.didUpdateNewsRequest(viewModel.newsRequest)
        navigationController?.popViewController(animated: true)
    }

    @objc private func clearButtonTapped() {
        viewModel.clearFilters()
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setupButtons() {
        let saveButton = UIBarButtonItem(title: LocalizedString.save.localized,
                                         style: .done,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton

        let clearButton = UIBarButtonItem(title: LocalizedString.clear.localized,
                                          style: .plain,
                                          target: self,
                                          action: #selector(clearButtonTapped))
        navigationItem.rightBarButtonItems = [saveButton, clearButton]
    }

    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: viewModel.segments)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = viewModel.currentMode.rawValue
        navigationItem.titleView = segmentedControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.titleForIndexPath(indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = viewModel.isIndexPathSelected(indexPath) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectIndexPath(indexPath)
        tableView.reloadData()
    }
}
