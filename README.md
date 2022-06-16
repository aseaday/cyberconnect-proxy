This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started
>**Warning**
> Because of the problem of chainlink, it would failed sometime. 

> Build on Kovan: https://kovan.etherscan.io/address/0xd615bcb13b0ce8331312d9ab1449fac9890ba5e8

1. call the method `requestFollowersData` to update address's followers data on a certain ns
```
function requestFollowersData(string calldata addr,  string calldata ns) public returns (bytes32 requestId)
```
2. read the followers from the method/map `addr2value`
![](/assets/screenshot.png)


## Develop
There are two parts in this project:
1. a proxy server to proxy the original cybereconnect graph ql api to simple api for oracle to use.
2. the oracle contract
### Run the proxy server
First, run the development server:

```bash
npm run dev
# or
yarn dev
```