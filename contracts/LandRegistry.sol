// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title LandRegistry
/// @notice A simple blockchain-based land registration system.
/// Each land record stores the owner's name, age, the land's history,
/// and a unique ID (UID). Once registered, a record can be looked up
/// by UID or the full list of registered lands can be browsed.
contract LandRegistry {
    struct Land {
        string name;      // Name of the person registering the land
        uint256 age;       // Age of the registrant
        string history;   // Free-text history / description of the land
        string uid;        // Unique identifier for this land record
        address registeredBy; // Wallet address that submitted the record
        uint256 timestamp; // Block time the record was created
        bool exists;        // Internal flag to check existence
    }

    // uid => Land record
    mapping(string => Land) private lands;

    // Keeps track of every UID ever registered, so we can list them all
    string[] private allUIDs;

    event LandRegistered(
        string indexed uid,
        string name,
        uint256 age,
        uint256 timestamp
    );

    /// @notice Register a new land record.
    /// @dev Reverts if a record with the same UID already exists,
    /// so records can never be silently overwritten.
    function registerLand(
        string memory _name,
        uint256 _age,
        string memory _history,
        string memory _uid
    ) public {
        require(bytes(_uid).length > 0, "UID cannot be empty");
        require(!lands[_uid].exists, "A land with this UID is already registered");

        lands[_uid] = Land({
            name: _name,
            age: _age,
            history: _history,
            uid: _uid,
            registeredBy: msg.sender,
            timestamp: block.timestamp,
            exists: true
        });

        allUIDs.push(_uid);

        emit LandRegistered(_uid, _name, _age, block.timestamp);
    }

    /// @notice Fetch a single land record by its UID.
    function getLand(string memory _uid)
        public
        view
        returns (
            string memory name,
            uint256 age,
            string memory history,
            string memory uid,
            address registeredBy,
            uint256 timestamp
        )
    {
        require(lands[_uid].exists, "No land found with this UID");
        Land memory l = lands[_uid];
        return (l.name, l.age, l.history, l.uid, l.registeredBy, l.timestamp);
    }

    /// @notice Check whether a UID is already registered.
    function landExists(string memory _uid) public view returns (bool) {
        return lands[_uid].exists;
    }

    /// @notice Returns every UID ever registered, in registration order.
    /// The frontend uses this to power the "View Blockchain" (view all) button.
    function getAllUIDs() public view returns (string[] memory) {
        return allUIDs;
    }

    /// @notice Total number of land records registered so far.
    function totalLands() public view returns (uint256) {
        return allUIDs.length;
    }
}
