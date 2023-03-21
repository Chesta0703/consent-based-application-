// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ConsentRegistry {
    struct Consent {
        bool given;
        address issuer;
        address holder;
        string dataType;
    }

    mapping(address => mapping(address => mapping(string => Consent))) public consents;

    event ConsentGiven(address indexed holder, address indexed issuer, string dataType, address indexed recipient);
    event ConsentRevoked(address indexed holder, address indexed issuer, string dataType, address indexed recipient);

    function give_consent(address holder, string memory dataType, address recipient) public {
        Consent storage consent = consents[holder][msg.sender][dataType];
        require(consent.issuer == msg.sender, "Issuer not authorized to give consent for this data type");

        consent.given = true;
        consent.holder = holder;

        emit ConsentGiven(holder, msg.sender, dataType, recipient);
    }

    function revoke_consent(address holder, string memory dataType, address recipient) public {
        Consent storage consent = consents[holder][msg.sender][dataType];
        require(consent.issuer == msg.sender, "Issuer not authorized to revoke consent for this data type");

        consent.given = false;

        emit ConsentRevoked(holder, msg.sender, dataType, recipient);
    }

    function check_consent(address holder, string memory dataType, address recipient) public view returns (bool) {
        Consent storage consent = consents[holder][msg.sender][dataType];
        return consent.given && consent.holder == holder && consent.issuer == msg.sender;
    }

    // New functions
    mapping(address => mapping(string => mapping(string => string))) public userData;

    function update_user_data(string memory dataType, string memory newData) public {
        userData[msg.sender][dataType][newData] = newData;
    }

    function get_user_data(address userAddress, string memory dataType) public view returns (string memory) {
        return userData[userAddress][dataType][userData[userAddress][dataType]];
    }

    function present_data(string memory dataType, address recipient) public {
        require(check_consent(msg.sender, dataType, recipient), "Holder has not given consent for this data type to this recipient");
        emit DataPresented(msg.sender, recipient, dataType, get_user_data(msg.sender, dataType));
    }

    event DataPresented(address indexed holder, address indexed recipient, string dataType, string data);
}
