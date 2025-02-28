const { MongoClient } = require("mongodb");
const AWS = require("aws-sdk");
const https = require("https");

const MONGO_DB_URL_SECRET_NAME = process.env.MONGO_DB_URL_SECRET_NAME;
const secrets_manager = new AWS.SecretsManager();
// const secret = await secrets_manager
//   .getSecretValue({ SecretId: MONGO_DB_URL_SECRET_NAME })
//   .promise();
// const connectionString = secret.SecretString;

exports.handler = async (event) => {
  try {
    if (!event.Records || event.Records.length === 0) {
      console.log("No messages received.");
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "No messages in queue" }),
      };
    }

    console.log("Messages received, starting to process the data.");
    await Promise.all(
      event.Records.map(async (record) => {
        const body = JSON.parse(record.body);
        console.log("Processing message:", body);
        const single_ip = body.ip.split(",")[0];
        const response = await fetch(`http://ip-api.com/json/${single_ip}`);
        const data = await response.json();

        const client = new MongoClient(
          "mongodb+srv://darshan:Darshan5579%21%40%23@portfolio-cluster.uxctt.mongodb.net/?retryWrites=true&w=majority&appName=portfolio-cluster",
          {
            useUnifiedTopology: true,
          }
        );

        try {
          await client.connect();
          console.log("Connected to the database");
          const db = client.db("analytics");
          const collection = db.collection("ip_data");
          // await collection.insertOne(data);
          const now = new Date();
          const result = await collection.updateOne(
            { query: data.query },
            {
              $set: { updatedAt: now },
              $setOnInsert: { ...data, createdAt: now },
            },
            { upsert: true }
          );
          if (result.upsertedCount > 0) {
            console.log("New document inserted");
          } else {
            console.log(
              "Document with this query already exists. No insertion performed."
            );
          }
        } catch (error) {
          console.error(error.message);
        } finally {
          await client.close();
        }
      })
    );

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Messages processed" }),
    };
  } catch (error) {
    console.error("Error processing SQS message:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to process SQS message" }),
    };
  }
};
