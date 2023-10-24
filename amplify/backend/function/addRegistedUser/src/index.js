import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event, context) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);
  console.log(context)
  const command = new PutCommand({
    TableName: "user",
    Item: {
      userId: "fxb",
      username: 'fanxuebin',
      mailAddress: '222@qq.com',
      phone:'1112e31232'
    },
  });
  try {
    await docClient.send(command);
  } catch (err) {
    console.log(err);
    throw err;
  }
};
