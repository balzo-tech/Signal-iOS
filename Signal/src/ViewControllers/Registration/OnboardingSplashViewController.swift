//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

import UIKit
import PromiseKit
import SafariServices

@objc
public class OnboardingSplashViewController: OnboardingBaseViewController {
    
    private enum LabelInteractions: CaseIterable {
        case privacyPolicy
        case termsOfService
        
        var text: String {
            switch self {
            case .privacyPolicy: return CommonStrings.privacyPolicy
            case .termsOfService: return CommonStrings.termsOfService
            }
        }
        
        func handleNavigation(presenter: UIViewController) {
            var stringUrl: String
            switch self {
            case .privacyPolicy: stringUrl = kLegalPrivacyUrlString
            case .termsOfService: stringUrl = kLegalTermsUrlString
            }
            
            guard let url = URL(string: stringUrl) else {
                owsFailDebug("Invalid URL.")
                return
            }
            let safariVC = SFSafariViewController(url: url)
            presenter.present(safariVC, animated: true)
        }
    }

    override var primaryLayoutMargins: UIEdgeInsets {
        var defaultMargins = super.primaryLayoutMargins
        // we want the hero image a bit closer to the top than most
        // onboarding content
        defaultMargins.top = 0
        defaultMargins.left = 17
        defaultMargins.right = 17
        return defaultMargins
    }
    
    private var legalLabelInteractionManager: UILabelInteractionManager?

    override public func loadView() {
        view = UIView()
        view.addSubview(primaryView)
        primaryView.autoPinEdgesToSuperviewEdges()

        view.backgroundColor = Theme.backgroundColor

        let logoImage = UIImage(named: "loop-logo-128")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.minificationFilter = .trilinear
        logoImageView.layer.magnificationFilter = .trilinear
        logoImageView.autoSetDimension(.height, toSize: 100)
        logoImageView.accessibilityIdentifier = "onboarding.splash." + "logoImageView"

        let titleLabel = self.createTitleLabel(text: NSLocalizedString("ONBOARDING_SPLASH_TITLE", comment: "Title of the 'onboarding splash' view."))
        primaryView.addSubview(titleLabel)
        titleLabel.accessibilityIdentifier = "onboarding.splash." + "titleLabel"
        titleLabel.setContentHuggingVerticalLow()
        titleLabel.setCompressionResistanceLow()
        
        let explanationLabel = UILabel()
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        explanationLabel.lineBreakMode = .byWordWrapping
        explanationLabel.isUserInteractionEnabled = true
        explanationLabel.accessibilityIdentifier = "onboarding.splash." + "explanationLabel"
        self.legalLabelInteractionManager = UILabelInteractionManager(withLabel: explanationLabel,
                                                                      text: NSLocalizedString("ONBOARDING_SPLASH_TERM_AND_PRIVACY_POLICY",
                                                                                              comment: "Link to the 'terms and privacy policy' in the 'onboarding splash' view."),
                                                                      lineSpacing: 5.0,
                                                                      normalTextFont: UIFont.ows_dynamicTypeCaption2.ows_medium,
                                                                      normalTextColor: Theme.primaryTextColor,
                                                                      interactableFont: UIFont.ows_dynamicTypeCaption2.ows_medium,
                                                                      interactableColor: Theme.accentBlueColor,
                                                                      interactableUnderline: true,
                                                                      interactionCallback: self.handleLabelInteractions,
                                                                      interactableStrings: LabelInteractions.allCases.map { $0.text })
        explanationLabel.setContentHuggingVerticalLow()
        explanationLabel.setCompressionResistanceLow()

        let continueButton = self.linkButton(title: CommonStrings.continueButton,
                                                    selector: #selector(continuePressed),
                                                    font: UIFont.ows_semiboldFont(withSize: 20))
        continueButton.accessibilityIdentifier = "onboarding.splash." + "continueButton"
        let primaryButtonView = OnboardingBaseViewController.horizontallyWrap(primaryButton: continueButton)

        let stackView = UIStackView(arrangedSubviews: [
            UIView.spacer(withHeight: 160),
            logoImageView,
            UIView.spacer(withHeight: 134),
            titleLabel,
            UIView.spacer(withHeight: 14),
            explanationLabel,
            UIView.vStretchingSpacer(minHeight: 60, maxHeight: 88),
            primaryButtonView
            ])
        stackView.axis = .vertical
        stackView.alignment = .fill

        primaryView.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewMargins()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.legalLabelInteractionManager?.refreshLabel()
    }

    // MARK: - Events

    @objc func didTapModeSwitch() {
        Logger.info("")

        onboardingController.onboardingSplashRequestedModeSwitch(viewController: self)
    }

    @objc func explanationLabelTapped(sender: UIGestureRecognizer) {
        guard sender.state == .recognized else {
            return
        }
        guard let url = URL(string: kLegalTermsUrlString) else {
            owsFailDebug("Invalid URL.")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @objc func continuePressed() {
        Logger.info("")

        onboardingController.onboardingSplashDidComplete(viewController: self)
    }
    
    private func handleLabelInteractions(_ text: String) {
        if let interaction = LabelInteractions.allCases.first(where: { $0.text == text }) {
            interaction.handleNavigation(presenter: self)
        } else {
            assertionFailure("Unhandled legal interaction")
        }
    }
}
