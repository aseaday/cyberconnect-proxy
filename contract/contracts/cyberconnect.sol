// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

contract CyberConnect is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public volume;
    bytes32 private jobId;
    uint256 private fee;
    mapping(bytes32 => string) private task2addr;
    mapping(string => uint256) public addr2value;

    event RequestVolume(bytes32 indexed requestId, uint256 volume);

    /**
     * @notice Initialize the link token and target oracle
     *
     * Kovan Testnet details:
     * Link Token: 0xa36085F69e2889c224210F603D836748e7dC0088
     * Oracle: 0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656 (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
        setChainlinkOracle(0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656);
        jobId = 'ca98366cc7314957b8c012c72f05aeeb';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    function getUrl(string calldata addr,  string calldata ns) public pure returns (string memory url) {
         url = "https://cyberconnect-proxy.vercel.app/api/followers";
         url = string.concat(url, "?address=", addr, "&namespace=", ns);
         return url;
    }
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestFollowersData(string calldata addr,  string calldata ns) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // Set the URL to perform the GET request on
        string memory url = getUrl(addr, ns);
        req.add('get', url);
        req.add('path', 'data,identity,followerCount'); // Chainlink nodes 1.0.0 and later support this format
        bytes32 _requestId = sendChainlinkRequest(req, fee);
        task2addr[_requestId] = addr;
        return _requestId;
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId) {
        emit RequestVolume(_requestId, _volume);
        string memory callerAddr = task2addr[_requestId];
        addr2value[callerAddr] = _volume;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }
}