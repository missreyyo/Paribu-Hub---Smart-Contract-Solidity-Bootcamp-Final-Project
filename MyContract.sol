// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyContract {
    struct Tenant {
        string name;
        string t_address;
        bool isHome;
        bool isStore;
    }

    struct Owner {
        string name;
        string o_address;
        bool isHome;
        bool isStore;
    }

    struct Property {
        address ownerAddress;
        string addressInfo;
        string contractInfo;
        uint rentStartDate;
        uint rentEndDate;
        bool isTerminated;
    }

    struct RentalAgreement {
        address tenantAddress;
        address propertyOwner;
        uint agreementStartDate;
        uint agreementEndDate;
        bool isTerminated;
    }

    struct Complaint {
        address complainant;
        string description;
    }

    mapping(address => Tenant) public Tenants;
    mapping(address => Owner) public Owners;
    mapping(address => Property) public Properties;
    mapping(address => RentalAgreement) public RentalAgreements;
    Complaint[] public Complaints;

    event TenantRegistered(address indexed tenantAddress, string name, string t_address, bool isHome, bool isStore);
    event OwnerRegistered(address indexed ownerAddress, string name, string o_address, bool isHome, bool isStore);
    event PropertyRegistered(address indexed ownerAddress, string addressInfo, string contractInfo, uint rentStartDate, uint rentEndDate);
    event RentalAgreementStarted(address indexed tenantAddress, address indexed propertyOwner, uint agreementStartDate, uint agreementEndDate);
    event RentalAgreementTerminated(address indexed tenantAddress, address indexed propertyOwner, uint terminationDate);
    event ComplaintFiled(address indexed complainant, string description);

    modifier onlyTenant() {
        require(Tenants[msg.sender].isHome || Tenants[msg.sender].isStore, "Only registered tenants can perform this action.");
        _;
    }

    modifier onlyOwner() {
        require(Owners[msg.sender].isHome || Owners[msg.sender].isStore, "Only registered owners can perform this action.");
        _;
    }

    function registerTenant(string memory name, string memory t_address, bool isHome, bool isStore) public {
        require(!Tenants[msg.sender].isHome && !Tenants[msg.sender].isStore, "Tenant is already registered.");
        Tenant storage newTenant = Tenants[msg.sender];
        newTenant.name = name;
        newTenant.t_address = t_address;
        newTenant.isHome = isHome;
        newTenant.isStore = isStore;
        
        emit TenantRegistered(msg.sender, name, t_address, isHome, isStore);
    }

    function registerOwner(string memory name, string memory o_address, bool isHome, bool isStore) public {
        require(!Owners[msg.sender].isHome && !Owners[msg.sender].isStore, "Owner is already registered.");
        Owner storage newOwner = Owners[msg.sender];
        newOwner.name = name;
        newOwner.o_address = o_address;
        newOwner.isHome = isHome;
        newOwner.isStore = isStore;

        emit OwnerRegistered(msg.sender, name, o_address, isHome, isStore);
    }

    function registerProperty(string memory addressInfo, string memory contractInfo, uint rentStartDate, uint rentEndDate) public onlyOwner {
        Property storage newProperty = Properties[msg.sender];
        newProperty.ownerAddress = msg.sender;
        newProperty.addressInfo = addressInfo;
        newProperty.contractInfo = contractInfo;
        newProperty.rentStartDate = rentStartDate;
        newProperty.rentEndDate = rentEndDate;
        
        emit PropertyRegistered(msg.sender, addressInfo, contractInfo, rentStartDate, rentEndDate);
    }

    function startRentalAgreement(address tenantAddress, uint agreementStartDate, uint agreementEndDate) public onlyOwner {
        require(agreementStartDate <= agreementEndDate, "Invalid agreement dates.");

        RentalAgreement storage newAgreement = RentalAgreements[tenantAddress];
        newAgreement.tenantAddress = tenantAddress;
        newAgreement.propertyOwner = msg.sender;
        newAgreement.agreementStartDate = agreementStartDate;
        newAgreement.agreementEndDate = agreementEndDate;
        newAgreement.isTerminated = false;

        emit RentalAgreementStarted(tenantAddress, msg.sender, agreementStartDate, agreementEndDate);
    }

    function requestTermination() public onlyTenant {
        require(!RentalAgreements[msg.sender].isTerminated, "Agreement is already terminated");
        require(block.timestamp < RentalAgreements[msg.sender].agreementEndDate - 15 days, "Cannot terminate the agreement within 15 days of its end");
        RentalAgreements[msg.sender].isTerminated = true;
        emit RentalAgreementTerminated(msg.sender, RentalAgreements[msg.sender].propertyOwner, block.timestamp);
    }

    function fileComplaint(string memory description) public {
        Complaint storage newComplaint = Complaints.push();
        newComplaint.complainant = msg.sender;
        newComplaint.description = description;

        emit ComplaintFiled(msg.sender, description);
    }
}