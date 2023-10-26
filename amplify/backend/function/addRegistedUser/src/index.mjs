import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
  //console.log(`EVENT: ${JSON.stringify(event)}`);
  const body = JSON.parse(event.body)
  const command = new PutCommand({
    TableName: "usernew-staging",
    Item: {
      userId: body.userId,
      username: body.username,
      mailAddress: body.mailAddress,
      avatarUrl: 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201409%2F29%2F20140929164844_rCLhV.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1698570916&t=2f592ece756f1331ed7f39c7ee5d9506"'
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
