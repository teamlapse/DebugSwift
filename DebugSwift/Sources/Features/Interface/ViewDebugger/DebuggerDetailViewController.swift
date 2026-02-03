//
//  DebuggerDetailViewController.swift
//  DebugSwift
//
//  Created by Matheus Gois on 05/01/24.
//

import UIKit

final class DebuggerDetailViewController: UIViewController {
    private var snapshotDescription: String = ""
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    init(snapshot: Snapshot) {
        super.init(nibName: nil, bundle: nil)
        title = snapshot.element.title
        snapshotDescription = snapshot.element.description
        textView.text = snapshotDescription
        if let cgImage = snapshot.snapshotImage {
            imageView.image = .init(cgImage: cgImage).outline()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        textView.backgroundColor = UIColor.black
        textView.textColor = UIColor.white
        
        setupNavigationButtons()

        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            imageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            imageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            imageView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 1 / 3
            )
        ])

        // Adiciona o UITextView
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        UIPasteboard.general.string = snapshotDescription
        let alert = UIAlertController(
            title: "Copied!",
            message: "View details copied to clipboard",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func shareButtonTapped() {
        let activityVC = UIActivityViewController(
            activityItems: [snapshotDescription],
            applicationActivities: nil
        )
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(activityVC, animated: true)
    }
}
