//
//  Network.SectionHeader.swift
//  DebugSwift
//
//  Created by DebugSwift on 19/01/26.
//

import UIKit

protocol NetworkSectionHeaderDelegate: AnyObject {
    func sectionHeaderDidTapCopy(_ header: NetworkSectionHeader, section: Int)
}

final class NetworkSectionHeader: UIView {
    weak var delegate: NetworkSectionHeaderDelegate?
    var section: Int = 0

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .black

        addSubview(titleLabel)
        addSubview(copyButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: copyButton.leadingAnchor, constant: -8),

            copyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            copyButton.widthAnchor.constraint(equalToConstant: 44),
            copyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configure(title: String, section: Int) {
        titleLabel.text = title
        self.section = section
    }

    @objc private func copyTapped() {
        delegate?.sectionHeaderDidTapCopy(self, section: section)

        // Visual feedback
        let originalColor = copyButton.tintColor
        copyButton.tintColor = .systemGreen
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
            self.copyButton.tintColor = originalColor
        })
    }
}
