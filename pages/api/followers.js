// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import axios from 'axios';

export default async function handler(req, res) {
  const url = "https://api.cybertino.io/connect/"
  const address = req.query.address;
  const namespace = req.query.namespace;
  console.log(req.query);
  const body = {
    operationName: "FullIdentityQuery",
    query: `
    query FullIdentityQuery {
      identity(
            address: "${address}",
            network: ETH
        ) {
            followerCount(namespace: "${namespace}")
        }
    }
    `
  }
  const config = {
    url,
    data: body,
    method: "post"
  }
  const response = await axios(config);
  console.log(response.data);
  res.status(200).json({ name: 'John Doe' })
}
