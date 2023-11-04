import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, UpdateCommand } from "@aws-sdk/lib-dynamodb";


const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
  console.log(event)
  try {
    const body = JSON.parse(event.body)
    const userId = body["userId"];
    const updateColumn = body["updateColumn"];
    const value = body["value"];

    const command = new UpdateCommand({
      TableName: "user-dev",
      Key: {
        userId,
      },
      UpdateExpression: `set ${updateColumn} = :${updateColumn}`,
      ExpressionAttributeValues: {
        [`:${updateColumn}`]: value,
      },
      ReturnValues: "ALL_NEW",
    });
    await docClient.send(command);
    return {
      statusCode: 200,
      //  Uncomment below to enable CORS requests
      //  headers: {
      //      "Access-Control-Allow-Origin": "*",
      //      "Access-Control-Allow-Headers": "*"
      //  },
      body: JSON.stringify("Hello from Lambda!"),
    };
  } catch (err) {
    console.log(err);
    throw err;
  }
};
