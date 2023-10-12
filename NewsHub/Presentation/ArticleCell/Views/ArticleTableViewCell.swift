//
//  ArticleTableViewCell.swift
//  NewsHub
//
//  Created by Anton Petrov on 10.10.2023.
//

import SDWebImage
import UIKit

final class ArticleTableViewCell: UITableViewCell {
    @IBOutlet private var newsImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var sourceLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var overlayView: UIView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var buttonBlurView: UIView!

    static let reuseIdentifier = String(describing: ArticleTableViewCell.self)

    private var viewModel: ArticleCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupOverlayBlurEffect()
        setupButtonBlurEffect()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        sourceLabel.text = nil
        authorLabel.text = nil
        saveButton.setImage(Constants.SystemImage.bookmark.image, for: .normal)
        viewModel = nil
    }

    // MARK: - Actions

    @IBAction private func saveButtonTapped() {
        viewModel?.toggleSaveStatus()
        updateSaveButton()
    }

    // MARK: - Configuration

    func configure(with viewModel: ArticleCellViewModel) {
        buttonBlurView.layer.cornerRadius = buttonBlurView.layer.bounds.height / 2
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        sourceLabel.text = viewModel.sourceName
        authorLabel.text = viewModel.author
        let placeholderImage = Constants.SystemImage.noteText.image
        if let imageUrl = URL(string: viewModel.imageUrl ?? "") {
            newsImageView.sd_setImage(with: imageUrl, placeholderImage: placeholderImage)
        } else {
            newsImageView.image = placeholderImage
        }
        buttonBlurView.isHidden = viewModel.shouldHideSaveButton
        updateSaveButton()
    }

    // MARK: - Setup

    private func setup() {
        containerView.layer.cornerRadius = Constants.StyleDefaults.cornerRadius
        selectionStyle = .none
    }

    private func setupOverlayBlurEffect() {
        let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = overlayView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.addSubview(blurEffectView)
        overlayView.sendSubviewToBack(blurEffectView)
        overlayView.backgroundColor = .clear
    }

    private func setupButtonBlurEffect() {
        let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = buttonBlurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        buttonBlurView.addSubview(blurEffectView)
        buttonBlurView.sendSubviewToBack(blurEffectView)
        buttonBlurView.backgroundColor = .clear
    }

    private func updateSaveButton() {
        guard let viewModel else { return }
        if viewModel.isSaved == true {
            saveButton.setImage(Constants.SystemImage.bookmarkFill.image, for: .normal)
        } else {
            saveButton.setImage(Constants.SystemImage.bookmark.image, for: .normal)
        }
    }
}
