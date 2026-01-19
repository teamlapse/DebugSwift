//
//  Network.Cell.Detail.swift
//  DebugSwift
//
//  Created by Matheus Gois on 14/12/23.
//  Copyright © 2023 apple. All rights reserved.
//

import UIKit

// MARK: - SelectableTextView

/// A UITextView subclass that properly handles text selection and contextual menus
final class SelectableTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupInteraction()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInteraction()
    }

    private func setupInteraction() {
        // Enable text interaction for iOS 17+
        if #available(iOS 17.0, *) {
            textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        // Add long press gesture for showing menu
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        addGestureRecognizer(longPressGesture)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }

        becomeFirstResponder()

        // Select all text when long pressing
        selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)

        // Show context menu
        let menuController = UIMenuController.shared
        if !menuController.isMenuVisible {
            menuController.showMenu(from: self, rect: bounds)
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Allow copy, select, and select all actions
        if action == #selector(copy(_:)) ||
           action == #selector(selectAll(_:)) ||
           action == #selector(select(_:)) {
            return true
        }
        return false
    }

    override func copy(_ sender: Any?) {
        if let selectedRange = selectedTextRange,
           let selectedText = text(in: selectedRange),
           !selectedText.isEmpty {
            UIPasteboard.general.string = selectedText
        } else {
            // Copy all text if nothing is selected
            UIPasteboard.general.string = text
        }
    }
}

final class NetworkTableViewCellDetail: UITableViewCell {
    let details: SelectableTextView = {
        let textView = SelectableTextView()
        textView.font = UIFont.systemFont(
            ofSize: 12,
            weight: .medium
        )
        textView.isScrollEnabled = false

        textView.textColor = UIColor.white
        textView.backgroundColor = .clear
        textView.isSelectable = true
        textView.isEditable = false
        textView.dataDetectorTypes = []
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        return textView
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setup(_ description: String, _ searched: String?) {
        details.text = description

        setupHighlighted(description, searched)
    }

    private func setupHighlighted(_ description: String, _ searched: String?) {
        guard let searched, !searched.isEmpty else {
            return
        }

        let attributedString = NSMutableAttributedString(string: description)
        let highlightedWords = searched.lowercased().components(separatedBy: " ")
        let fullRange = NSRange(location: 0, length: (description as NSString).length)

        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: fullRange)

        for word in highlightedWords {
            var searchRange = fullRange
            while searchRange.location != NSNotFound {
                searchRange = (description as NSString).range(
                    of: word,
                    options: .caseInsensitive,
                    range: searchRange
                )

                if searchRange.location != NSNotFound {
                    attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: searchRange)
                    attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: searchRange)
                    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: searchRange)

                    searchRange = NSRange(
                        location: searchRange.location + searchRange.length,
                        length: (description as NSString).length - (searchRange.location + searchRange.length)
                    )
                }
            }
        }

        details.attributedText = attributedString
    }

    private func setupUI() {
        setupViews()
        setupConstraints()

        contentView.backgroundColor = UIColor.black
        backgroundColor = UIColor.black
        selectionStyle = .none
    }

    func setupViews() {
        // Add UI components to the contentView
        contentView.addSubview(details)
    }

    func setupConstraints() {
        // Number Label
        details.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            details.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            details.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            details.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            details.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
