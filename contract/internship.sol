// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChainTracker {
    struct Product {
        uint id;
        string name;
        string currentLocation;
        address owner;
        string status;
    }

    uint public productCount = 0;
    mapping(uint => Product) public products;
    mapping(address => uint[]) public ownerProducts;

    event ProductCreated(uint id, string name, string location, address owner, string status);
    event ProductTransferred(uint id, address from, address to, string location, string status);

    function createProduct(string memory _name, string memory _location, string memory _status) public {
        productCount++;
        products[productCount] = Product(productCount, _name, _location, msg.sender, _status);
        ownerProducts[msg.sender].push(productCount);
        emit ProductCreated(productCount, _name, _location, msg.sender, _status);
    }

    function transferProduct(uint _productId, address _newOwner, string memory _newLocation, string memory _newStatus) public {
        Product storage product = products[_productId];
        require(product.owner == msg.sender, "Only the current owner can transfer this product");

        // Transfer ownership and update location and status
        ownerProducts[product.owner][_productId-1] = 0;
        product.owner = _newOwner;
        product.currentLocation = _newLocation;
        product.status = _newStatus;

        ownerProducts[_newOwner].push(_productId);
        emit ProductTransferred(_productId, msg.sender, _newOwner, _newLocation, _newStatus);
    }

    function getProduct(uint _productId) public view returns (Product memory) {
        return products[_productId];
    }

    function getOwnerProducts(address _owner) public view returns (uint[] memory) {
        return ownerProducts[_owner];
    }
}