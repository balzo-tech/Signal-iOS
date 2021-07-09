//
//  Copyright (c) 2021 Attimo Srl. All rights reserved.
//

import Foundation
import UIKit

class AvatarView: UIView {
    
    private static let avatarSize = CGSize(square: 64.0)
    
    private let avatarImageView = AvatarImageView()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ows_dynamicTypeHeadline
        label.textColor = Theme.isDarkThemeEnabled ? UIColor.ows_white : UIColor.ows_gray800
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        self.addSubview(horizontalStackView)
        horizontalStackView.autoPinEdgesToSuperviewEdges()
        
        horizontalStackView.addArrangedSubview(self.avatarImageView)
        self.avatarImageView.autoSetDimensions(to: Self.avatarSize)
        horizontalStackView.addArrangedSubview(self.nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func update(withAddress address: SignalServiceAddress) {
        self.avatarImageView.image = OWSContactAvatarBuilder(address: address,
                                                             colorName: .default,
                                                             diameter: UInt(Self.avatarSize.width)).buildDefaultImage()
        self.nameLabel.text = self.contactsManager.displayName(for: address)
    }
    
    public func update(withThreadViewModel threadViewModel: ThreadViewModel) {
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
    
    /// This should be used only to test UI
    public func debugUpdate(name: String) {
        self.nameLabel.text = name
        self.avatarImageView.image = OWSAvatarBuilder.buildRandomAvatar(withDiameter: UInt(Self.avatarSize.width))
    }
}
