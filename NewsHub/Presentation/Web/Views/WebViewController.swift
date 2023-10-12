//
//  WebViewController.swift
//  NewsHub
//
//  Created by Anton Petrov on 11.10.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Properties

    private var toolbar: UIToolbar!
    private var goBackButton: UIBarButtonItem!
    private var goForwardButton: UIBarButtonItem!
    private var refreshButton: UIBarButtonItem!
    private var resetButton: UIBarButtonItem!
    private var saveArticleButton: UIButton!
    private var webView: WKWebView!
    private let viewModel: WebViewModel

    // MARK: - Initialization

    init(viewModel: WebViewModel) {
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
        setupWebView()
        setupToolbar()
        loadRequest()
    }

    // MARK: - Actions

    @objc private func saveArticleTapped() {
        viewModel.toggleSaveStatus()
        configureSaveButton()
    }

    @objc private func goBack() {
        webView.goBack()
    }

    @objc private func goForward() {
        webView.goForward()
    }

    @objc private func refreshPage() {
        webView.reload()
    }

    @objc private func resetPage() {
        loadRequest()
    }

    // MARK: - Setup

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.fillSuperview()
    }

    private func setupNavigationBar() {
        navigationItem.title = viewModel.sourceName
        navigationController?.navigationBar.isTranslucent = false
        saveArticleButton = UIButton()
        configureSaveButton()
        saveArticleButton.addTarget(self, action: #selector(saveArticleTapped), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: saveArticleButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setupToolbar() {
        toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        goBackButton = UIBarButtonItem(title: "←",
                                       style: .plain,
                                       target: self,
                                       action: #selector(goBack))
        goForwardButton = UIBarButtonItem(title: "→",
                                          style: .plain,
                                          target: self,
                                          action: #selector(goForward))
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                        target: self,
                                        action: #selector(refreshPage))
        resetButton = UIBarButtonItem(title: LocalizedString.reset.localized,
                                      style: .plain,
                                      target: self,
                                      action: #selector(resetPage))

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.items = [space, goBackButton, space, resetButton, space, refreshButton, space, goForwardButton, space]
        toolbar.sizeToFit()
        toolbar.anchor(left: view.leftAnchor,
                       bottom: view.safeAreaLayoutGuide.bottomAnchor,
                       right: view.rightAnchor)
    }

    private func loadRequest() {
        guard let url = viewModel.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func configureSaveButton() {
        let image = viewModel.isSaved
            ? Constants.SystemImage.bookmarkFill.image
            : Constants.SystemImage.bookmark.image
        saveArticleButton.setImage(image, for: .normal)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        goBackButton.isEnabled = webView.canGoBack
        goForwardButton.isEnabled = webView.canGoForward
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        showAlert(message: UserError.noConnection.userLocalizedDescription)
    }

    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        showAlert(message: UserError.noConnection.userLocalizedDescription)
    }
}
