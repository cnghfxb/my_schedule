import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
  //console.log(`EVENT: ${JSON.stringify(event)}`);
  const body = JSON.parse(event.body)
  const command = new PutCommand({
    TableName: "user-dev",
    Item: {
      userId: body.userId,
      mailAddress: body.mailAddress,
      nickname: body.nickname,
      avatarUrl: 'https://gd-hbimg.huaban.com/9980f53d02800ebad0472f0fe1a6eed9a1ba699ec27f-mvUjPb_fw658webp'
    },
  });
  try {
    await docClient.send(command);
      const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
  return response;
  } catch (err) {
    console.log(err);
    throw err;
  }
};
