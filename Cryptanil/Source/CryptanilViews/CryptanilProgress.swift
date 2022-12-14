//
//  Progress.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 19.10.22.
//

import Foundation

class CryptanilProgress: UIView {
    
    private var progressWidth: CGFloat {
        return frame.width / 2
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupBackgroundView()
        startAnimation()
    }
    
    func setupBackgroundView() {
        backgroundColor = CryptanilColors.gray
        layer.cornerRadius = frame.height / 2
        layer.borderColor = CryptanilColors.gray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
    
    func setupProgressViews() -> UIView {
        let progressView = UIView()
        progressView.backgroundColor = CryptanilColors.blue
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: progressWidth).isActive = true
        progressView.heightAnchor.constraint(equalTo: heightAnchor, constant: -2).isActive = true
        progressView.layer.cornerRadius = (frame.size.height - 2) / 2
        return progressView
    }
    
    @objc func startAnimation() {
        let progressView = setupProgressViews()
        let progressLeading = progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -progressWidth)
        progressLeading.isActive = true
        self.layoutIfNeeded()
        progressLeading.constant = self.frame.width
        UIView.animate(withDuration: 3) {
            self.layoutIfNeeded()
        } completion: { _ in
            progressView.removeFromSuperview()
        }
        let timeInterval = subviews.count <= 1 ? 0 : 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            self?.startAnimation()
        }
    }
}
