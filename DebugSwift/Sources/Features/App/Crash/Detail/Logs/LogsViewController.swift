//
//  LogsViewController.swift
//  DebugSwift
//
//  Created by Matheus Gois on 20/12/23.
//

import UIKit

final class LogsViewController: BaseController {
    // MARK: - Properties
    
    private let logText: String

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.white
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .black
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = [.link]
        return textView
    }()

    // MARK: - Initialization

    init(text: String) {
        self.logText = text
        super.init()
        textView.text = text
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationButtons()
    }

    // MARK: - UI Setup

    private func setupUI() {
        title = "Logs"
        view.backgroundColor = UIColor.black

        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            textView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            textView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            textView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -8
            )
        ])
    }
    
    private func setupNavigationButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "square.and.arrow.up"),
                style: .plain,
                target: self,
                action: #selector(shareButtonTapped)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "doc.on.doc"),
                style: .plain,
                target: self,
                action: #selector(copyButtonTapped)
            )
        ]
    }
    
    @objc private func copyButtonTapped() {
        UIPasteboard.general.string = logText
        showAlert(
            with: "Logs copied to clipboard",
            title: "Copied!"
        )
    }
    
    @objc private func shareButtonTapped() {
        let activityVC = UIActivityViewController(
            activityItems: [logText],
            applicationActivities: nil
        )
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(activityVC, animated: true)
    }
}
