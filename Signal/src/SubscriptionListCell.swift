//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation

class SubscriptionListCell: UITableViewCell {
    class var cellReuseIdentifier: String { String(describing: self.self) }
    
    private static let avatarSize = CGSize(square: 64.0)
    
    private let avatarImageView = AvatarImageView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeHeadline
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_white : UIColor.ows_gray800
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeCaption1
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray500 : UIColor.ows_gray400
        return label
    }()
    
    let renewDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeCaption1
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_gray500 : UIColor.ows_gray400
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        self.contentView.addSubview(horizontalStackView)
        horizontalStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5.0, leading: 20.0, bottom: 5.0, trailing: 20.0))
        
        horizontalStackView.addArrangedSubview(self.avatarImageView)
        self.avatarImageView.autoSetDimensions(to: Self.avatarSize)
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        verticalStackView.addArrangedSubview(self.nameLabel)
        verticalStackView.addArrangedSubview(self.descriptionLabel)
        verticalStackView.addArrangedSubview(self.renewDateLabel)
        
        let verticalContainerView = UIView()
        verticalContainerView.addSubview(verticalStackView)
        verticalStackView.autoPinEdge(toSuperviewEdge: .leading)
        verticalStackView.autoPinEdge(toSuperviewEdge: .trailing)
        verticalStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 0.0, relation: .greaterThanOrEqual)
        verticalStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0.0, relation: .greaterThanOrEqual)
        verticalStackView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        horizontalStackView.addArrangedSubview(verticalContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withThreadViewModel threadViewModel: ThreadViewModel) {
        if let subscription = threadViewModel.subscription {
            self.descriptionLabel.text = subscription.subscriptionPlan.descriptionText
            self.renewDateLabel.text = subscription.subscriptionPlan.getRenewDateText(withExpiryDate: subscription.expirationDate)
            self.avatarImageView.image = OWSAvatarBuilder.buildImage(thread: threadViewModel.threadRecord, diameter: UInt(Self.avatarSize.width))
            
            if threadViewModel.isGroupThread {
                if threadViewModel.name.count == 0 {
                    self.nameLabel.text = MessageStrings.newGroupDefaultTitle
                } else {
                    self.nameLabel.text = threadViewModel.name;
                }
            } else {
                if threadViewModel.threadRecord.isNoteToSelf {
                    self.nameLabel.text = MessageStrings.noteToSelf
                } else if let contactAddress = threadViewModel.contactAddress {
                    self.nameLabel.text = self.contactsManager.displayName(for: contactAddress)
                } else {
                    self.nameLabel.text = ""
                }
            }
        }
    }
    
    /// This should be used only to test UI
    func debugConfigure(withSubscription subscription: Subscription, groupName: String) {
        self.nameLabel.text = groupName
        self.descriptionLabel.text = subscription.subscriptionPlan.descriptionText
        self.renewDateLabel.text = subscription.subscriptionPlan.getRenewDateText(withExpiryDate: subscription.expirationDate)
        self.avatarImageView.image = OWSAvatarBuilder.buildRandomAvatar(withDiameter: UInt(Self.avatarSize.width))
    }
}
