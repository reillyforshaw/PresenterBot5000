//
//  SlideViewController.swift
//  PresenterBot 5000
//
//  Created by Reilly Forshaw on 2018-02-05.
//  Copyright © 2018 Reilly Forshaw. All rights reserved.
//

import Foundation
import UIKit

class SlideViewController : UIViewController {
  typealias Slide = String

  private struct State {
    private let slides: [Slide]
    private let slideIndex: Int

    var currentSlideAndProgress: (slide: Slide, slideNumber: Int, numberOfSlides: Int)? {
      guard slideIndex < slides.count else { return nil }

      return (slide: slides[slideIndex], slideNumber: slideIndex + 1, numberOfSlides: slides.count)
    }

    var hasPreviousSlide: Bool { return slideIndex > 0 }
    var hasNextSlide: Bool { return slideIndex < (slides.count - 1) }

    var next: State? {
      guard hasNextSlide else { return nil }

      return State(slides: slides, slideIndex: slideIndex + 1)
    }

    private init(slides: [Slide], slideIndex: Int) {
      self.slides = slides
      self.slideIndex = slideIndex
    }

    static func forPresentation(of slides: [Slide]) -> State {
      return State(slides: slides, slideIndex: 0)
    }
  }

  @IBOutlet private weak var slideTextLabelContainer: UIView!
  @IBOutlet private weak var slideTextLabel: UILabel! { didSet { addStyleToSlideText() } }
  @IBOutlet private weak var backButton: UIButton! { didSet { addStyle(to: backButton) } }
  @IBOutlet private weak var progressLabel: UILabel! { didSet { addStyleToProgressLabel() } }
  @IBOutlet private weak var forwardButton: UIButton! { didSet { addStyle(to: forwardButton) } }

  override var prefersStatusBarHidden: Bool { return true }

  private let state: State

  private init(state: State) {
    self.state = state

    super.init(nibName: nil, bundle: nil)
  }

  convenience init(slides: [Slide]) {
    self.init(state: .forPresentation(of: slides))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(white: 0.15, alpha: 1)

    backButton.isHidden = !state.hasPreviousSlide
    forwardButton.isHidden = !state.hasNextSlide

    guard let (slide, slideNumber, numberOfSlides) = state.currentSlideAndProgress else { return }

    slideTextLabel.text = slide
    progressLabel.text = "\(slideNumber) of \(numberOfSlides)"
  }

  override func viewDidLayoutSubviews() {
    guard let slideText = slideTextLabel.text.map({ $0 as NSString }) else { return }

    var fontSize = 100 as CGFloat

    let containerSize = CGSize(width: slideTextLabelContainer.frame.width, height: CGFloat.infinity)

    func height(forFontSize fontSize: CGFloat) -> CGFloat {
      return slideText.boundingRect(with: containerSize, options: [.usesLineFragmentOrigin], attributes: [.font : UIFont.systemFont(ofSize: fontSize)], context: nil).height
    }

    while height(forFontSize: fontSize) > slideTextLabelContainer.frame.height {
      fontSize -= 1
    }

    slideTextLabel.font = .systemFont(ofSize: fontSize)
  }

  private func addStyleToSlideText() {
    slideTextLabel.textColor = .white
  }

  private func addStyle(to navigationButton: UIButton) {
    navigationButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
  }

  private func addStyleToProgressLabel() {
    progressLabel.textColor = UIColor(white: 0.75, alpha: 1)
    progressLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
  }

  @IBAction private func back() {
    navigationController?.popViewController(animated: true)
  }

  @IBAction private func forward() {
    navigationController?.pushViewController(SlideViewController(state: state.next!), animated: true)
  }
}
