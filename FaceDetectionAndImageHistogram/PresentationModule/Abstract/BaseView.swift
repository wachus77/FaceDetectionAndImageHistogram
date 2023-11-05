//
//  BaseView.swift
//  FaceDetectionAndImageHistogram
//
//  Created by Iwaszek, Tomasz on 05/11/2023.
//

import UIKit

class BaseView<ViewModel>: UIView {
    var viewModel: ViewModel
    /// Indicating if keyboard should be closed on touch
    var closeKeyboardOnTouch = true

    /// Initialize an instance and calls required methods
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        guard let setupableView = self as? ViewSetupable else { return }
        setupableView.setupView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - SeeAlso: UIView.touchesBegan()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if closeKeyboardOnTouch {
            endEditing(true)
        }
    }
}
