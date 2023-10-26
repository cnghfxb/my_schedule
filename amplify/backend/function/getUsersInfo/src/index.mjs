import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
    const userId = event.queryStringParameters['userId']
    const username = event.queryStringParameters['username']

    const command = new GetCommand({
        TableName: "usernew-staging",
        Key: {
            userId,
            username
        }
      });
    const response = await docClient.send(command);

    return {
        statusCode: 200,
        body: JSON.stringify(response.Item),
    };
};
