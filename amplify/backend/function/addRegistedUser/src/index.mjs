import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
  //console.log(`EVENT: ${JSON.stringify(event)}`);
  const body = JSON.parse(event.body)
  const command = new PutCommand({
    TableName: "user-staging",
    Item: {
      userId: body.userId,
      username: body.username,
      mailAddress: body.mailAddress
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
